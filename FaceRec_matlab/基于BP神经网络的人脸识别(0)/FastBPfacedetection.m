function FastBPfacedetection
%% 第一步，读入数据
global imgRow;
global imgCol;
global net

display(' ');
display(' ');
display('训练开始...');

nPerson=40;
nFacesPerPerson = 5;
display('读入人脸数据...');
[imgRow,imgCol,FaceContainer,faceLabel]=ReadFaces(nFacesPerPerson,nPerson);


nFaces=size(FaceContainer,1);%样本（人脸）数目

display('PCA降维...');
k=49;
[pcaFaces, W] = fastPCA(FaceContainer, k); % 主成分分析PCA
% pcaFaces是200*20的矩阵, 每一行代表一张主成分脸(共40人，每人5张)，每个脸20个维特征
% W是分离变换矩阵, 10304*20 的矩阵
%visualize_pc(W);%显示主成分脸


X = pcaFaces;

display('归一化开始...');
display('.........');
[X,A0,B0] = scaling(X);
save('Mat/scaling.mat', 'A0', 'B0');
% 保存 scaling 后的训练数据至 trainData.mat
TrainData = X;
trainLabel = faceLabel;
save('Mat/trainData.mat', 'TrainData', 'trainLabel');
display('归一化完成...');

%% 第二步，创建并训练BP神经网络

%生成训练BP神经网络的输入 P 
P=TrainData;
%生成目标输出矢量 T
T=zeros(200,40);
 for i=1:40
    for j=1:5
      T((i-1)*5+j,i)=1;
  end
 end
 
%打乱训练样本顺序
gx2(:,1:k)=P;
gx2(:,(k+1):(k+40))=T;
xd=gx2(randperm(numel(gx2)/(k+40)),:);
gx=xd(:,1:k);d=xd(:,(k+1):(k+40));
P=gx';
T=d';

%创建BP神经网络
[R,Q]=size(P);
[S2,Q]=size(T);
net=newff(minmax(P),T,[fix(sqrt(R*S2))],{'purelin','purelin'},'traingdx');

%训练BP神经网络
net.trainparam.epochs=5000;    %训练步数
net.trainparam.goal=0.0001;    %训练目标误差
net.divideFcn = '';            %所有的样本都用于训练
[net,tr]=train(net,P,T);       

%仿真BP神经网络
Y=sim(net,P);

%% 第三步，测试BP神经网络并计算其识别率
display('测试开始...');
%测试BP神经网络
s=0;
    load('Mat/PCA.mat');
    load('Mat/scaling.mat');
    load('Mat/trainData.mat');
%     load('Mat/multiSVMTrain.mat');
    display('..............................');
for i=1:40
    for j=6:10                              %读入40x5副测试图像
         a=imread(strcat('C:\Users\Master\Documents\MATLAB\基于BP神经网络的人脸识别\orl_faces\s',num2str(i),'\',num2str(j),'.pgm'));
         b=a(1:10304);
         b=double(b);
         TestFace=b;
         [m n] = size(TestFace);
         TestFace = (TestFace-repmat(meanVec, m, 1))*V; % 经过pca变换降维
         TestFace = scaling(TestFace,1,A0,B0);
         X = TestFace;
         Z=sim(net,X');
         [zi,index2]=max(Z);
         if index2==i   
             s=s+1;
         else
             i;                             %输出识别出错的那个人 i
             j;                            %输出识别出错的那张图片 j
             index2;                         %输出误识别成的那个人
         end
     end
end

%计算识别率
accuracy=s/Q


