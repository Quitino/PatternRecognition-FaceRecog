function test()
% ���Զ����������Լ���ʶ����
%
% �����accuracy --- ���ڲ��Լ��ϵ�ʶ����

global SVM;
global Adaboost;

display(' ');
display(' ');
display('���Կ�ʼ...');

nFacesPerPerson = 5;
nPerson = 40;
bTest = 1;
% ������Լ���
display('������Լ���...');
[imgRow,imgCol,TestFace,testLabel] = ReadFaces(nFacesPerPerson, nPerson, bTest);
display('..............................');

% �������ѵ�����
display('����ѵ������...');

    load('Mat/PCA.mat');
    load('Mat/scaling.mat');
    load('Mat/trainData.mat');
    load('Mat/multiAdaboostTrain.mat');
    display('..............................');

    % PCA��ά
    display('PCA��ά����...');
    [m n] = size(TestFace);
    TestFace = (TestFace-repmat(meanVec, m, 1))*V; % ����pca�任��ά
    TestFace = scaling(TestFace,1,A0,B0);
    display('..............................');
    
     % ���� AdaBoost ����
    display('���Լ�ʶ����...');
    classes = multiAdaboostClassify(TestFace);
    display('..............................');
    
    % ����ʶ����
    nError = sum(classes ~= testLabel);
    accuracy = 1 - nError/length(testLabel);
    display(['PCA+Adaboost���ڲ��Լ�200������������ʶ����Ϊ', num2str(accuracy*100), '%']);
