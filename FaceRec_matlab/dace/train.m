function train(C, gamma)
% ����ѵ�����̣���������ͼ��PCA��ά�Լ����� SVM ѵ���������׶εĴ������ֱ𱣴����ļ���
%   �� PCA �任���� W ������ Mat/PCA.mat
%   �� scaling �ĸ�ά�ϡ��½���Ϣ������ Mat/scaling.mat
%   �� PCA ��ά���� scaling ������ݱ����� Mat/trainData.mat

%   ������ Adaboost ��ѵ����Ϣ������ Mat/multiAdaboostTrain.mat

global imgRow;
global imgCol;
global SVM;
global Adaboost;

display(' ');
display(' ');
display('ѵ����ʼ...');

nPerson=40;
nFacesPerPerson = 5;
display('������������...');
[FaceContainer,faceLabel]=ReadFace(nFacesPerPerson,nPerson);
display('..............................');


nFaces=size(FaceContainer,1);%��������������Ŀ

display('PCA��ά...');
[pcaFaces, W] = fastPCA(FaceContainer, 20); % ���ɷַ���PCA
% pcaFaces��200*20�ľ���, ÿһ�д���һ�����ɷ���(��40�ˣ�ÿ��5��)��ÿ����20��ά����
% W�Ƿ���任����, 10304*20 �ľ���
%visualize_pc(W);%��ʾ���ɷ���
display('..............................');

X = pcaFaces;

display('��һ����ʼ...');
display('.........');
[X,A0,B0] = scaling(X);
save('Mat/scaling.mat', 'A0', 'B0');
% ���� scaling ���ѵ�������� trainData.mat
TrainData = X;
trainLabel = faceLabel;
save('Mat/trainData.mat', 'TrainData', 'trainLabel');
display('��һ�����...');

display('ѵ����������ʼ��������̿��ܻỨ�ϼ�����.........................');

    for iPerson = 1:nPerson
        nSplPerClass(iPerson) = sum( (trainLabel == iPerson) );
    end

    multiAdaboostStruct = multiAdaboostTrain(TrainData, nSplPerClass ,nPerson);
    display('���ڱ���Adaboostѵ�����...');
    save('Mat/multiAdaboostTrain.mat', 'multiAdaboostStruct');
display('..............................');
display('ѵ����ɡ�');