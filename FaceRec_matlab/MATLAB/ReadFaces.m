function [imgRow,imgCol,FaceContainer,faceLabel]=ReadFaces(nFacesPerPerson, nPerson, bTest)
% 读入ORL人脸库的指定数目的人脸前前五张(训练)
%
% 输入：nFacesPerPerson --- 每个人需要读入的样本数，默认值为 5
%       nPerson --- 需要读入的人数，默认为全部 40 个人
%       bTest --- bool型的参数。默认为0，表示读入训练样本（前5张）；如果为1，表示读入测试样本（后5张）
%
% 输出：FaceContainer --- 向量化人脸容器，nPerson（200） * 10304 的 2 维矩阵，每行对应一个人脸向量

if nargin==0 %default value
    nFacesPerPerson=5;%前5张用于训练
    nPerson=40;%要读入的人数（每人共10张，前5张用于训练）
    bTest = 0;
elseif nargin < 3
    bTest = 0;
end

img=imread('D:\PatternRecognition\FacRec_matlab\MATLAB\Data\sample\S1\1.pgm');%为计算尺寸先读入一张
[imgRow,imgCol]=size(img);

%构建40人*前5张共200行，imgRow*imgCol列的全零矩阵
FaceContainer = zeros(nFacesPerPerson*nPerson, imgRow*imgCol);
%构建200行，一列全零矩阵
faceLabel = zeros(nFacesPerPerson*nPerson, 1);

% 读入训练数据
for i=1:nPerson    %40人
    i1=mod(i,10); % 个位，%该函数用于进行取模（取余）运算
    i0=char(i/10);% 将数转成字符串
%2018.11.29_FB
% num2str()是将数转成文字，eg. num2str(43)得到的将是'43'，是两个字符
% char是按照ascii码表将数字映射成字符，char(43)得到的将是‘+’，（加号的ascii码是43）
   if bTest == 0 % 读入训练数据   %bTest为导入训练样本还是测试样本的flag
        strPath='Data/sample/S';
   else
        strPath='Data/test/S';
   end
    if( i0~=0 )  %组建图片的文件名！
        strPath=strcat(strPath,'0'+i0);
    end
    strPath=strcat(strPath,'0'+i1);
    strPath=strcat(strPath,'/');
    tempStrPath=strPath;
    for j=1:nFacesPerPerson   %训练数据集的五张图片nFacesPerPerson = 5
        strPath=tempStrPath;
        
        if bTest == 0 % 读入训练数据
            strPath = strcat(strPath, '0'+j);
        else
            % 读入测试数据，这里把数字5改为nFacePerPreson维护性更好2018.11.29_FB
            strPath = strcat(strPath, num2str(5+j));
        end
        
        strPath=strcat(strPath,'.pgm');
        img=imread(strPath);%具体读入单张图片
       
        %把读入的图像按列存储为行向量放入向量化人脸容器faceContainer的对应行中2018.11.29_FB
        FaceContainer((i-1)*nFacesPerPerson+j, :) = img(:)';
        %类别标签111112222233333...(五个为一个类别，40个类别)
        faceLabel((i-1)*nFacesPerPerson+j) = i;
    end % j
end % i

% 保存人脸样本矩阵FaceMat（200*10304）每一行为一个样本
save('Mat/FaceMat.mat', 'FaceContainer')




