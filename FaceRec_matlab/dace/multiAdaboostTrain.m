function multiAdaboostStruct = multiAdaboostTrain(TrainData, nSampPerClass,nClass)
%function multiAdaboostStruct = multiAdaboostTrain(TrainData, nSampPerClass)
% ����1��1ͶƱ���Խ� Adaboost �ƹ������������ѵ�����̣�������Adaboostѵ�����������multiAdaboostStruct��
%
% ����:--TrainData:ÿ����һ����������
%     --nClass:�������������
%     --nSampPerClass:nClass*1ά����������¼ÿ���������Ŀ���� nSampPerClass(iClass)
%     �����˵�iClass���������Ŀ
%imshow
% ���:--multiAdaboostStruct:һ����������Adaboostѵ������Ľṹ��
%��ʼѵ������Ҫ����ÿ�����ķ��೬ƽ�棬��(nClass-1)*nClass/2��

for ii=1:(nClass-1)
    for jj=(ii+1):nClass
        clear X;
        clear Y;
        startPosII = sum( nSampPerClass(1:ii-1) ) + 1;
        endPosII = startPosII + nSampPerClass(ii) - 1;
        X(1:nSampPerClass(ii), :) = TrainData(startPosII:endPosII, :);
            
        startPosJJ = sum( nSampPerClass(1:jj-1) ) + 1;
        endPosJJ = startPosJJ + nSampPerClass(jj) - 1;
        X(nSampPerClass(ii)+1:nSampPerClass(ii)+nSampPerClass(jj), :) = TrainData(startPosJJ:endPosJJ, :);
        
        
        % �趨��������ʱ�����ǩ
        Y = ones(nSampPerClass(ii) + nSampPerClass(jj), 1)+1;
        Y(nSampPerClass(ii)+1:nSampPerClass(ii)+nSampPerClass(jj)) = 1;
        
        % ��ii���˺͵�jj������������ʱ�ķ������ṹ��Ϣ
        AdaboostStruct{ii}{jj}=ADABOOST_tr(@threshold_tr,@threshold_te, X, Y, 20);%����20�ε���
     end
end

% ��ѧ�õķ�����
multiAdaboostStruct.AdaboostStruct = AdaboostStruct;
multiAdaboostStruct.nClass = nClass;