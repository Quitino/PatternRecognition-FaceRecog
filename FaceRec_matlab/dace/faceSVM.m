functionPCASVMfacedetection()
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


nFaces=size(FaceContainer,1);%样本（人脸）数目（40*5=200个人脸）

display('PCA降维...');
k=49;   %前 k 个本征值和本征向量
[pcaFaces, W] = fastPCA(FaceContainer, k); % 主成分分析PCA
% pcaFaces是200*49的矩阵, 每一行代表一张主成分脸(共40人，每人5张)，每个脸49维特征
% W是分离变换矩阵, 10304*49 的矩阵
visualize_pc(W);%显示主成分脸


X = pcaFaces;

display('归一化开始...');
display('.........');

[X,A0,B0] = scaling(X);
save('Mat/scaling.mat', 'A0', 'B0');
% 保存 scaling 后的训练数据至 trainData.mat
TrainData = X;
trainLabel = faceLabel;   %在ReadFaces.m里面定义，人脸类别标签200*1（期望输出）
save('Mat/trainData.mat', 'TrainData', 'trainLabel');
display('归一化完成...');





%%

disp('SVM样本训练...')  
disp('.................................................')  
gamma=0.0078;  
c=128;  
multiSVMstruct=multiSVMtrain( scaledface,npersons,gamma,c);  
  
disp('读取测试数据...')  
disp('.................................................')  
[testface,realclass]=ReadFace(npersons,1);  
  
disp('测试数据特征降维...')  
disp('.................................................')  
m=size(testface,1);  
for i=1:m  
    testface(i,:)=testface(i,:)-mA;  
end  
pcatestface=testface*V;  
  
disp('测试特征数据规范化...')  
disp('.................................................')  
scaledtestface = scaling( pcatestface,lowvec,upvec);  
  
disp('SVM样本分类...')  
disp('.................................................')  
class= multiSVM(scaledtestface,multiSVMstruct,npersons);  
  
accuracy=sum(class==realclass)/length(class);  
display(['正确率：',num2str(accuracy)])  