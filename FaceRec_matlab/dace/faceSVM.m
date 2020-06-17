functionPCASVMfacedetection()
%% ��һ������������
global imgRow;
global imgCol;
global net

display(' ');
display(' ');
display('ѵ����ʼ...');

nPerson=40;
nFacesPerPerson = 5;
display('������������...');
[imgRow,imgCol,FaceContainer,faceLabel]=ReadFaces(nFacesPerPerson,nPerson);


nFaces=size(FaceContainer,1);%��������������Ŀ��40*5=200��������

display('PCA��ά...');
k=49;   %ǰ k ������ֵ�ͱ�������
[pcaFaces, W] = fastPCA(FaceContainer, k); % ���ɷַ���PCA
% pcaFaces��200*49�ľ���, ÿһ�д���һ�����ɷ���(��40�ˣ�ÿ��5��)��ÿ����49ά����
% W�Ƿ���任����, 10304*49 �ľ���
visualize_pc(W);%��ʾ���ɷ���


X = pcaFaces;

display('��һ����ʼ...');
display('.........');

[X,A0,B0] = scaling(X);
save('Mat/scaling.mat', 'A0', 'B0');
% ���� scaling ���ѵ�������� trainData.mat
TrainData = X;
trainLabel = faceLabel;   %��ReadFaces.m���涨�壬��������ǩ200*1�����������
save('Mat/trainData.mat', 'TrainData', 'trainLabel');
display('��һ�����...');





%%

disp('SVM����ѵ��...')  
disp('.................................................')  
gamma=0.0078;  
c=128;  
multiSVMstruct=multiSVMtrain( scaledface,npersons,gamma,c);  
  
disp('��ȡ��������...')  
disp('.................................................')  
[testface,realclass]=ReadFace(npersons,1);  
  
disp('��������������ά...')  
disp('.................................................')  
m=size(testface,1);  
for i=1:m  
    testface(i,:)=testface(i,:)-mA;  
end  
pcatestface=testface*V;  
  
disp('�����������ݹ淶��...')  
disp('.................................................')  
scaledtestface = scaling( pcatestface,lowvec,upvec);  
  
disp('SVM��������...')  
disp('.................................................')  
class= multiSVM(scaledtestface,multiSVMstruct,npersons);  
  
accuracy=sum(class==realclass)/length(class);  
display(['��ȷ�ʣ�',num2str(accuracy)])  