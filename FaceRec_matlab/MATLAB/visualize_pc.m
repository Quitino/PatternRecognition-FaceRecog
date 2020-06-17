function visualize_pc(E)
% ��ʾ���ɷַ��������ɷ��������任�ռ��еĻ�����������������������
% 
% ���룺E --- ����ÿһ����һ�����ɷַ���  U=[u1,u2,u3,u4,u5,u6,...]


[size1 size2] = size(E);%size1Ϊ������size2Ϊ����
global imgRow;
global imgCol;
row = imgRow;
col = imgCol;

if size2 ~= 49
   error('Can only display 20 principle components');
end;

c1 = zeros(row,col*5);
c2 = c1;
c3 = c1;
c4 = c1;
c1(:) = E(:,1:5);
c2(:) = E(:,6:10);
c3(:) = E(:,11:15);
c4(:) = E(:,16:20);
size(c1)

composite=zeros(row*4,col*5);
composite(:)=[c1;c2;c3;c4];



figure;
colormap(gray);
imagesc(composite);
axis image;
m=min(min(composite));
M =max(max(composite));
imwrite(uint8((composite-m)*(255/(M-m))),'composite.tiff');

% 
% function visualize_pc( B )  
% %��ʾ���������任�ռ��еĻ�����������λ����������  
% %���룺B����ÿ���Ǹ����ɷַ�������ʾ�ľ��ǵ�ά��ÿ������ɵ�ͼ��  
% %     k�������ɷֵ�ά��  
% global imgrow;  
% global imgcol;  
% figure  
% img=zeros(imgrow,imgcol);  
% for i=1:20  
%     img(:)=B(:,i);  
%     subplot(4,5,i);  
%     imshow(img,[])  
% end  
% end  






