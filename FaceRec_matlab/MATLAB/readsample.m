function [sample,label]=readsample(address,ClassNum,data,rows,cols,image_fmt)
%读取样本。
%输入：
%address：要读取的样本的路径
%ClassNum：代表要读入样本的类别数
%data：样本索引
%rows：样本行数
%cols：样本列数
%image_fmt：图片格式



%输出：
%sample：样本矩阵，每列为一个样本，每行为一类特征
%label：样本标签

allsamples=[];
label=[];
ImageSize=rows*cols;

for i=1:ClassNum
    for j=data
        a=double(imread(strcat(address,num2str(i),'_',num2str(j),image_fmt)));  
%         SP=[-1 -1; -1 0; -1 1; 0 -1; -0 1; 1 -1; 1 0; 1 1];
%         a=double(LBP(a,SP,0,'nh')); %LBP code image using sampling points in SP
%                             %and no mapping.
%        a=double(LBP(a));
        a=imresize(a,[rows cols]);
        b=reshape(a,ImageSize,1);
        allsamples=[allsamples,b];
        label=[label,i];
    end
end
sample=allsamples;