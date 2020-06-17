function [imgRow,imgCol,FaceContainer,faceLabel]=ReadFaces(nFacesPerPerson, nPerson, bTest)
% ����ORL�������ָ����Ŀ������ǰǰ����(ѵ��)
%
% ���룺nFacesPerPerson --- ÿ������Ҫ�������������Ĭ��ֵΪ 5
%       nPerson --- ��Ҫ�����������Ĭ��Ϊȫ�� 40 ����
%       bTest --- bool�͵Ĳ�����Ĭ��Ϊ0����ʾ����ѵ��������ǰ5�ţ������Ϊ1����ʾ���������������5�ţ�
%
% �����FaceContainer --- ����������������nPerson��200�� * 10304 �� 2 ά����ÿ�ж�Ӧһ����������

if nargin==0 %default value
    nFacesPerPerson=5;%ǰ5������ѵ��
    nPerson=40;%Ҫ�����������ÿ�˹�10�ţ�ǰ5������ѵ����
    bTest = 0;
elseif nargin < 3
    bTest = 0;
end

img=imread('D:\PatternRecognition\FacRec_matlab\MATLAB\Data\sample\S1\1.pgm');%Ϊ����ߴ��ȶ���һ��
[imgRow,imgCol]=size(img);

%����40��*ǰ5�Ź�200�У�imgRow*imgCol�е�ȫ�����
FaceContainer = zeros(nFacesPerPerson*nPerson, imgRow*imgCol);
%����200�У�һ��ȫ�����
faceLabel = zeros(nFacesPerPerson*nPerson, 1);

% ����ѵ������
for i=1:nPerson    %40��
    i1=mod(i,10); % ��λ��%�ú������ڽ���ȡģ��ȡ�ࣩ����
    i0=char(i/10);% ����ת���ַ���
%2018.11.29_FB
% num2str()�ǽ���ת�����֣�eg. num2str(43)�õ��Ľ���'43'���������ַ�
% char�ǰ���ascii�������ӳ����ַ���char(43)�õ��Ľ��ǡ�+�������Ӻŵ�ascii����43��
   if bTest == 0 % ����ѵ������   %bTestΪ����ѵ���������ǲ���������flag
        strPath='Data/sample/S';
   else
        strPath='Data/test/S';
   end
    if( i0~=0 )  %�齨ͼƬ���ļ�����
        strPath=strcat(strPath,'0'+i0);
    end
    strPath=strcat(strPath,'0'+i1);
    strPath=strcat(strPath,'/');
    tempStrPath=strPath;
    for j=1:nFacesPerPerson   %ѵ�����ݼ�������ͼƬnFacesPerPerson = 5
        strPath=tempStrPath;
        
        if bTest == 0 % ����ѵ������
            strPath = strcat(strPath, '0'+j);
        else
            % ����������ݣ����������5��ΪnFacePerPresonά���Ը���2018.11.29_FB
            strPath = strcat(strPath, num2str(5+j));
        end
        
        strPath=strcat(strPath,'.pgm');
        img=imread(strPath);%������뵥��ͼƬ
       
        %�Ѷ����ͼ���д洢Ϊ������������������������faceContainer�Ķ�Ӧ����2018.11.29_FB
        FaceContainer((i-1)*nFacesPerPerson+j, :) = img(:)';
        %����ǩ111112222233333...(���Ϊһ�����40�����)
        faceLabel((i-1)*nFacesPerPerson+j) = i;
    end % j
end % i

% ����������������FaceMat��200*10304��ÿһ��Ϊһ������
save('Mat/FaceMat.mat', 'FaceContainer')




