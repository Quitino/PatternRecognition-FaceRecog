function nClass = classify(newFacePath)
% �������ࣨʶ�𣩹���
global SVM;
global Adaboost;

display(' ');
display(' ');
display('ʶ��ʼ...');

% �������ѵ�����
display('����ѵ������...');

    load('Mat/PCA.mat');
    load('Mat/scaling.mat');
    load('Mat/trainData.mat');
    load('Mat/multiAdaboostTrain.mat');
    display('..............................');
  
    xNewFace = ReadAFace(newFacePath); % ����һ����������
    xNewFace = double(xNewFace);
    xNewFace = (xNewFace-meanVec)*V;% ����pca�任��ά
    xNewFace = scaling(xNewFace,1,A0,B0);


    display('���ʶ����...');
    nClass = multiAdaboostClassify(xNewFace);
    display('..............................');
    display(['���ʶ����������Ϊ��' num2str(nClass), '��']);
