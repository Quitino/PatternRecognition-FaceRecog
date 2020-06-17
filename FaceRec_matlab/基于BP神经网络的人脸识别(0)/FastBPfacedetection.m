function FastBPfacedetection
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


nFaces=size(FaceContainer,1);%��������������Ŀ

display('PCA��ά...');
k=49;
[pcaFaces, W] = fastPCA(FaceContainer, k); % ���ɷַ���PCA
% pcaFaces��200*20�ľ���, ÿһ�д���һ�����ɷ���(��40�ˣ�ÿ��5��)��ÿ����20��ά����
% W�Ƿ���任����, 10304*20 �ľ���
%visualize_pc(W);%��ʾ���ɷ���


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

%% �ڶ�����������ѵ��BP������

%����ѵ��BP����������� P 
P=TrainData;
%����Ŀ�����ʸ�� T
T=zeros(200,40);
 for i=1:40
    for j=1:5
      T((i-1)*5+j,i)=1;
  end
 end
 
%����ѵ������˳��
gx2(:,1:k)=P;
gx2(:,(k+1):(k+40))=T;
xd=gx2(randperm(numel(gx2)/(k+40)),:);
gx=xd(:,1:k);d=xd(:,(k+1):(k+40));
P=gx';
T=d';

%����BP������
[R,Q]=size(P);
[S2,Q]=size(T);
net=newff(minmax(P),T,[fix(sqrt(R*S2))],{'purelin','purelin'},'traingdx');

%ѵ��BP������
net.trainparam.epochs=5000;    %ѵ������
net.trainparam.goal=0.0001;    %ѵ��Ŀ�����
net.divideFcn = '';            %���е�����������ѵ��
[net,tr]=train(net,P,T);       

%����BP������
Y=sim(net,P);

%% ������������BP�����粢������ʶ����
display('���Կ�ʼ...');
%����BP������
s=0;
    load('Mat/PCA.mat');
    load('Mat/scaling.mat');
    load('Mat/trainData.mat');
%     load('Mat/multiSVMTrain.mat');
    display('..............................');
for i=1:40
    for j=6:10                              %����40x5������ͼ��
         a=imread(strcat('C:\Users\Master\Documents\MATLAB\����BP�����������ʶ��\orl_faces\s',num2str(i),'\',num2str(j),'.pgm'));
         b=a(1:10304);
         b=double(b);
         TestFace=b;
         [m n] = size(TestFace);
         TestFace = (TestFace-repmat(meanVec, m, 1))*V; % ����pca�任��ά
         TestFace = scaling(TestFace,1,A0,B0);
         X = TestFace;
         Z=sim(net,X');
         [zi,index2]=max(Z);
         if index2==i   
             s=s+1;
         else
             i;                             %���ʶ�������Ǹ��� i
             j;                            %���ʶ����������ͼƬ j
             index2;                         %�����ʶ��ɵ��Ǹ���
         end
     end
end

%����ʶ����
accuracy=s/Q


