%分类精度计算
function [accuracy,xp,r,pre_label]=computaccuracy(trainsample,classnum,train_label,testsample,test_label)
test_tol=size(testsample,2);%返回列数
train_tol=size(trainsample,2);
pre_label=zeros(1,test_tol);
h = waitbar(0,'Doing SRC,Please wait...');
for i=1:test_tol
    xp = SolveHomotopy_CBM_std(trainsample, testsample(:,i),'lambda', 0.01);%求解L1范数最小化问题
    for j=1:classnum
        mmu=zeros(train_tol,1);
        ind=(j==train_label);
        mmu(ind)=xp(ind);
        r(j)=norm(testsample(:,i)-trainsample*mmu);
    end
    [temp,index]=min(r);
    pre_label(i)=index;
    % computations take place here
    per = i / test_tol;
    waitbar(per, h ,sprintf('%2.0f%%',per*100))
end

close(h)
accuracy=sum(pre_label==test_label)/test_tol;%计算误差
fprintf('错误分类样本：\n');
for i=1:test_tol
    if pre_label(i)~=test_label(i)
        fprintf('将第%d张样本属于第%d类，错误分到第%d类\n',i,test_label(i),pre_label(i));
    end
end