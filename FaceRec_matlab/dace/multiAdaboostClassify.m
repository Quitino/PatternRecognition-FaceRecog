function class = multiAdaboostClassify(TestFace, multiAdaboostStruct)

% ����:--TestFace:������������m*n ��2ά����ÿ��һ����������
%     --multiAdaboostStruct:����Adaboost��ѵ��������ɺ��� multiAdaboostTrain ���أ�Ĭ���Ǵ�Mat/multiAdaboostTrain.mat�ļ��ж�ȡ
%
% ���:--class: m*1 ����������Ӧ TestFace �����ǩ


% ����ѵ�����
if nargin < 2
    t = dir('Mat/multiAdaboostTrain.mat');
    if length(t) == 0
        error('û���ҵ�ѵ������ļ������ڷ�����ǰ���Ƚ���ѵ����');
    end
    load('Mat/multiAdaboostTrain.mat');
end

nClass = multiAdaboostStruct.nClass; % ���������
AdaboostStruct = multiAdaboostStruct.AdaboostStruct; % ����������֮�����Ϣ




%%%%%%%%%%%%%%%%%%%%%%%% ͶƱ���Խ���������� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
m = size(TestFace, 1);
Voting = zeros(m, nClass); % m������������ÿ������nPerson ������ͶƱ��

for iIndex = 1:nClass-1
    for jIndex = iIndex+1:nClass
        classes=ADABOOST_te(AdaboostStruct{iIndex}{jIndex},@threshold_te,TestFace);
        % ͶƱ
        Voting(:, iIndex) = Voting(:, iIndex) + (classes == 2);
        Voting(:, jIndex) = Voting(:, jIndex) + (classes == 1);
                
    end % for jClass
end % for iClass



% final decision by voting result
[vecMaxVal, class] = max( Voting, [], 2 );
%display(sprintf('TestFace��Ӧ�������:%d',class));