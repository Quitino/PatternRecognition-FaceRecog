function [ pcaA,V] = fastPCA( A,k,mA)  
%����PCA�����ɷݷ���  
%���룺A-��������ÿ����һ������������������ά��  
%            k-����kά  
%           mA-ͼ�����f_matrixÿһ�еľ�ֵ�ų�һ������������mean(f_matrix)
%�����pacA-��ά��ѵ�������ڵ�ά�ռ��е�ϵ�������ʾ 
%            V-���ɷַ���������ά�ռ䵱�еĻ�  
%
m=size(A,1);  %mΪ��ȡͼƬ������
Z=(A-repmat(mA,m,1));  %���Ļ���������
%һ�������Ļ��ľ������ԭ����Ϊʲô����Ϊ�����ݼ��ľ�ֵ���㣨Ԥ��������Ҳ����ֻȡ���ݵ�ƫ���
T=Z*Z';  
[V1,D]=eigs(T,k);%����T������k������ֵ����������  
V=Z'*V1;         %Э����������������  
%��һ���ǹؼ����裬�ܿ��ܺܶ��ѧ���޷����⣺
%����������Э�������ļ��㹫ʽΪ�������������Ļ���Z�Ѿ��������
%V = (Z'*Z)./(size(Z,1)-1)���Ȳ��ܵ�λ����V=Z'*Z��(������һ��Ϊһ��������һ��Ϊһ��ά�������)
%Э���������N*N�ķ���ά��NӦ����ԭͼƬf_matrix��200*10304��ά�����
%f_matrix������200ΪͼƬ����������10304Ϊά��
%��Ϊʲô������T=Z*Z'������T��K���������ֵ����������V1������V=Z'*V1����Э����������������أ�
%��Ϊ���������V=Z'*Z���V����һ��10304*10304�ľ���MATLAB�����ˣ�̫����
%���ǿ���������P^-1*��Z*Z')*P=S�ȼ���P^-1*(Z')^-1*Z'*Z*Z'*P=S�ȼ���(Z'*P)^-1*(Z'*Z)*(Z'*P)=S
%ע��P^-1��P�������(Z')^-1ΪZ'����������ƣ�������д��ֽ��
%���һ��ʽ�ӿ��Կ���Z'*Z��������������ΪZ'*P����Z*Z'��������������ΪP����Ϊ�����е�V1
%����һ�ּ�㷽����Ϊ�ľ��Ǳ�����V=Z'*Z����ά��̫�ߵļ��㡣
%�ɲ鿴Cƪ���²���4
for i=1:k       %����������λ��  
    l=norm(V(:,i));  
    V(:,i)=V(:,i)/l;  
end  
%��λ�����V�����������ĵ�ά�ռ�Ļ�����Ҫ������������λ����������
%����ԭ��ο�Dƪ����
pcaA=Z*V;       %���Ա任������kά  �������Ļ��ľ���ͶӰ����ά�ռ�Ļ��У�V���ǵ�ά�ռ�Ļ�
%pcaAΪ��ά�ռ�������ʾ����һ��ͼ����ж�����
end 