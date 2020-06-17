%%%这个函数什么意思？？？？
function [P R]=prew1(x,k)
Rxx=x*x';
[u,d,v]=svd(Rxx);%u v 为两个代表二个相互正交矩阵，而d代表一对角矩阵。
P=u(:,1:k);
R=d(1:k,1:k);

