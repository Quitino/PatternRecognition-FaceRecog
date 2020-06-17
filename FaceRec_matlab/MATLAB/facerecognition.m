function varargout = faceRecognition(varargin)
% FACEGNITION MATLAB code for facegnition.fig
% Last Modified by GUIDE v2.5 24-Dec-2018 19:00:09
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @facerecognition_OpeningFcn, ...
                   'gui_OutputFcn',  @facerecognition_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before facegnition is made visible.
function facerecognition_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to facegnition (see VARARGIN)

% javaFrame = get(hObject, 'JavaFrame');
% javaFrame.setFigureIcon(javax.swing.ImageIcon('SWUST.jpg'));

% Choose default command line output for facegnition
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = facerecognition_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%——fisher回调函数
function fisher_Callback(hObject, eventdata, handles)
%%%%%%%%将训练集样本转换成200x10304的矩阵，每一行代表一个样本
disp('******选择训练样本文件夹******')
TrainImagePath = uigetdir(strcat(matlabroot,'\work'), '选择训练样本路径 ' );%读取路径
TrainSample=zeros(150,112*92);
for i=1:150        
    str = int2str(i);
    str = strcat('\',str,'.BMP');
    str = strcat(TrainImagePath,str);
    img = imread(str);
    TrainSample(i,:)=img(:)';
end
TrainSample=double(TrainSample);  

%%%%%%%%将测试集样本转换成200x10304的矩阵，每一行代表一个样本
disp('******选择测试样本文件夹******')
TestImagePath = uigetdir(strcat(matlabroot,'\work'), 'Please select the TestSampleFisherImage Path');%读取路径
TestSample=zeros(150,112*92);
for i=1:150        
    str = int2str(i);
    str = strcat('\',str,'.BMP');
    str = strcat(TestImagePath,str);
    img = imread(str);
    TestSample(i,:)=img(:)';
end
TestSample=double(TestSample);  

%%%%%%%%创建标注向量（200x1）-给样本贴标签
disp('******创建标注向量******')
Label=ones(5,1);        
for i=1:29
    LabelTemp=(i+1)*ones(5,1);
    Label=[Label ; LabelTemp];
    Label=double(Label);
end

%%%%%%%%PCA降维
disp('******PCA降维******')
[TrainSampleRow,TrainSampleCloumn] = size(TrainSample);
classLabel = unique(Label);%去除重复--(30x1)
LenthClassLabel = length(classLabel);

if  TrainSampleCloumn > (TrainSampleRow - LenthClassLabel)
    [dataset_coef,TrainSample_score,dataset_latent,dataset_t2] = princomp(TrainSample);   %生成变换矩阵
    TestSample_score= bsxfun(@minus,TestSample,mean(TrainSample,1))*dataset_coef;         %把测试数据转变到新的坐标系
    
    TrainSample=TrainSample_score(:,1:TrainSampleRow-LenthClassLabel);
    TestSample=TestSample_score(:,1:TrainSampleRow-LenthClassLabel);
   
    [TrainSampleRow,TrainSampleCloumn] = size(TrainSample);   
end

%%%%%%%%%%%%%Fisher分类
disp('******Fisher分类******')
sampleMean = mean(TrainSample);

Sb = zeros(TrainSampleCloumn, TrainSampleCloumn);        %类间离散度矩阵
Sw = zeros(TrainSampleCloumn, TrainSampleCloumn);        %类内离散度矩阵
for i = 1:LenthClassLabel
    index = find(Label==classLabel(i));
    classMean = mean(TrainSample(index, :));
    %类间离散度矩阵
    Sb = Sb + (length(index)/TrainSampleRow)*(sampleMean-classMean)'*(sampleMean-classMean);
    Xclass=TrainSample(index,:);
    tempSw=zeros(TrainSampleCloumn,TrainSampleCloumn);
    
    for j=1:length(index)
        tempSw=tempSw+(Xclass(j,:)-classMean)'*(Xclass(j,:)-classMean);
    end
    %类内离散度矩阵
    Sw=Sw + (length(index)/TrainSampleRow)*tempSw;
end

%生成特征空间
[eigvector, eigvalue] = eigs((Sw\Sb),LenthClassLabel,'LR');
%投影
TrainSampleFisher= TrainSample * eigvector;         %（150x29)
TestSampleFisher = TestSample * eigvector;          %(150x29)

%%%%%%%%%%%%%%%%%%%%%%%   K近邻寻找
disp('******K近邻寻找******')
K=3;
[rowTeFisher,colTeFisher]=size(TestSampleFisher);   %N=150,M=29
L=size(TrainSampleFisher,1);                        %L=N=150
idx = zeros(rowTeFisher,K);                         %(150x3)存放D中的相应的索引
D = idx;                                            %(150x3)存放最近的三个样本之间的距离
for k=1:rowTeFisher                                 %N=150
    d=zeros(L,1);                                   %(150x1)--存放距离
    for t=1:colTeFisher                             %M=29
        d=d+(TrainSampleFisher(:,t)-TestSampleFisher(k,t)).^2;    %d--距离(150x1)
    end
    [s,t]=sort(d);                                  %按列升序排序，s--向量（150x1），距离；排序完后的结果，t--向量（150x1），索引
    idx(k,:)=t(1:K);                                %将前三个索引的值赋给idx的每一行
    D(k,:)=s(1:K);                                  %将前三个排序过的值赋值给D的每一行
end
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   使用K近邻判别
disp('******使用K近邻判别******')
classLabel = unique(Label);         %去除重复
nClass = length(classLabel);        %nClass=30
kNum=3;
right=0;

for i=1 :rowTeFisher                %rowTeFisher=150
    class3Idx=idx(i,:);             %行向量（1x3)，存放的是训练集到测试集的最短距离的样本的索引
    classIdx=zeros(1,kNum);         %行向量(1x3)
    for j=1 :kNum                   %kNum=3
        temp=class3Idx(j);
        
        classIdx(j)=Label(temp);    %Label--(50x1),classIdx--训练集当中的样本的编号
    end
    for k= 1: kNum
        result=zeros(1,nClass);     %行向量（1x10）
        classNum=classIdx(k);       %相应的最短距离的三个样本的编号
        dist=(norm(TestSampleFisher(i,:)-TrainSampleFisher(class3Idx(k),:)))^2;%norm-矩阵范数，测试集到训练集（训练集到测试集的三个最短距离）的距离
        result(classNum)=result(classNum)+1/dist;
        dist=0;
    end
    [C,I]=max(result);              %C--从之前的三个距离最短的距离中再通过运算计算出距离最短的，I--相应的样本的索引
    testlabel(i)=I;
    if (I==Label(i))
        right=right+1;
    end   
end

for i=1:150
    disp(['实际分类 ',num2str(Label(i)) ,'           ','识别分类',num2str(testlabel(i))]);
    if Label(i)~=testlabel(i)
       disp('******上面一个分类错误****** ');
    end
end

accurcy=right/rowTeFisher;
accurcy=strcat(num2str(accurcy*100),'%');
display(accurcy);

% ---SVM分类算法
function SVM_Callback(hObject, eventdata, handles)
% hObject    handle to SVM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

npersons=40;      %选取200个样本 
imgrow=112;   
imgcol=92;  

%%%%%%%%%%%%%   读取训练集样本
disp('******读取训练集样本******') 
TrainImagePath = uigetdir(strcat(matlabroot,'\work'), 'Please select the TrainSampleFisherImage Path ' );%读取路径
TrainImage=zeros(200,112*92);
for i=1:200        
    str = int2str(i);
    str = strcat('\',str,'.BMP');
    str = strcat(TrainImagePath,str);
    img = imread(str);
    TrainImage(i,:)=img(:)';
end
TrainImage=double(TrainImage); 

%%%%%%%%%%%%%   PCA降维
disp('******PCA降维******')  
meanTrain=mean(TrainImage); %按列求均值--（1x10304）
k=70;                       %降维至70维  
m=size(TrainImage,1);       %m=40x5
TrainSample=(TrainImage-repmat(meanTrain,m,1));  %repmat--复制和平铺矩阵;Z--（200x10304）去均值样本
T=TrainSample*TrainSample';                      %I的大小为（200，200）
[V,D]=eigs(T,k);                                 %D--特征值对角阵，V的列向量为对应特征向量,V(200xk)。
EigenFace=TrainSample'*V;                        %协方差矩阵的特征向量 ，其中Z(200,10304)之所以取转置是因为每行为一个样本 ,EigenFace--(10304xk)
for i=1:k                                        %特征向量单位化   
    l=norm(EigenFace(:,i));                      %返回向量的2范数,即平方和开根号
    EigenFace(:,i)=EigenFace(:,i)/l;             %本征向量
end  
PcaFace=TrainSample*EigenFace;                   %线性变换，降至k维，pcaA--（200xk）

%%%%%%%%%%%%%   显示本征脸
disp('******显示本征脸******')  
figure();  
Img=zeros(imgrow,imgcol);  
for i=1:70 
    Img(:)=EigenFace(:,i);  
    subplot(7,10,i);          %将figure分割
    imshow(Img,[]); 
end

%%%%%%%%%%%%%   数据规范化
disp('******训练特征数据规范化******')  %数据规格化（去除数据单位因素对分类造成的影响）
MinPca=min(PcaFace);          %按列求最小值，lowvec为一个向量
MaxPca=max(PcaFace);  
Max=1;  
Min=-1;  
[m,n]=size(PcaFace);          %faceMat(200,20)
NormFace=zeros(m,n);  
for i=1:m  
    NormFace(i,:)=Min+(PcaFace(i,:)-MinPca)./(MaxPca-MinPca)*(Max-Min);  
end  

%%%%%%%%%%%%% SVM样本训练 
disp('******SVM样本训练******')  
sigma=0.005;  
c=128;  
for i=1:npersons-1  
    for j=i+1:npersons  
        X=[NormFace(5*(i-1)+1:5*i,:);NormFace(5*(j-1)+1:5*j,:)]; %X(10,10) --训练矩阵
        Y=[ones(5,1);zeros(5,1)];                                %Y(10,1)--训练标签
        multiSVMstruct{i}{j}=svmtrain(X,Y,'Kernel_Function',@(X,Y) kfun_rbf(X,Y,sigma),'boxconstraint',c);   %Kernel_Function--核函数
    end  
end  

%%%%%%%%%%%%% 读取测试数据
disp('******读取测试数据******')    
TestImagePath = uigetdir(strcat(matlabroot,'\work'), 'Please select the TestSampleFisherImage Path');%读取路径
testface=zeros(200,112*92);
realclass=zeros(npersons*5,1);
for j=1:40
    for i=1:5
        realclass((j-1)*5+i)=j;
    end
end
for i=1:200        
    str = int2str(i);
    str = strcat('\',str,'.BMP');
    str = strcat(TestImagePath,str);
    img = imread(str);
    testface(i,:)=img(:)';
end
testface=double(testface); 

%%%%%%%%%%%%% 测试数据特征降维
disp('******测试数据特征降维******')  
m=size(testface,1);  
for i=1:m  
    testface(i,:)=testface(i,:)-meanTrain;  
end  
PcaTestFace=testface*EigenFace;  

%%%%%%%%%%%%% 测试数据规范化
disp('******测试特征数据规范化******')  
MinPca=min(PcaTestFace);  %按列求最小值，lowvec为一个向量
MaxPca=max(PcaTestFace);  
Max=1;  
Min=-1;  
[m,n]=size(PcaTestFace);  %faceMat(200,20)
NormTestFace=zeros(m,n);  
for i=1:m  
    NormTestFace(i,:)=Min+(PcaTestFace(i,:)-MinPca)./(MaxPca-MinPca)*(Max-Min);  
end  
testface=NormTestFace;
  
%%%%%%%%%%%%% SVM测试样本分类
disp('******SVM样本分类******')  
m=size(testface,1);  
voting=zeros(m,npersons);  
for i=1:npersons-1  
    for j=i+1:npersons  
        class=svmclassify(multiSVMstruct{i}{j},testface);  
        voting(:,i)=voting(:,i)+(class==1);  
        voting(:,j)=voting(:,j)+(class==0);  
    end  
end  
[~,class]=max(voting,[],2); 

for i=1:40
    for j=1:5
        index(i,j)=class(i)+5*(i-1)+j-1;
    end
end
for i=1:200
    disp(['实际分类 ',num2str(realclass(i)) ,'           ','识别分类',num2str(class(i))]);
    if realclass(i)~=class(i)
       disp('******上面一个分类错误****** ');
    end
end

%%%%%%%%%%%%%% 计算正确率
disp('******计算正确率******')
accuracy=sum(class==realclass)/length(class);  
display(['正确率：',num2str(accuracy)])  

% --- Executes on button press in ANN.
function ANN_Callback(hObject, eventdata, handles)
FastBPfacedetection();

% hObject    handle to ANN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% ---SRC+LBP+PCA.
function SRC_LBP_Callback(hObject, eventdata, handles)
% hObject    handle to SRC_LBP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear all
clc
close all

database=[pwd '\ORL1'];%使用的人脸库
train_samplesize=5;%每类训练样本数
address=[database '\s'];
rows=112;
cols=92;
ClassNum=40;
tol_num=10;
image_fmt='.bmp';

%------------------------PCA降维-----------------------------------------
train=1:train_samplesize;
test=train_samplesize+1:tol_num;

train_num=length(train);
test_num=length(test);

train_tol=train_num*ClassNum;
test_tol=test_num*ClassNum;

[train_sample,train_label]=readsample(address,ClassNum,train,rows,cols,image_fmt);
[test_sample,test_label]=readsample(address,ClassNum,test,rows,cols,image_fmt);

for pro_dim=50:20:90
    tic;
    %PCA降维
    [Pro_Matrix,Mean_Image]=my_pca(train_sample,pro_dim);
    train_project=Pro_Matrix'*train_sample;
    test_project=Pro_Matrix'*test_sample;
    
    %单位化
    train_norm=normc(train_project);
    test_norm=normc(test_project);
    
    [accuracy,xp,r,pre_label]=computaccuracy(train_norm,ClassNum,train_label,test_norm,test_label);
    fprintf('投影维数为：%d\n',pro_dim);
    fprintf('每类训练样本个数为：%d\n',train_samplesize);
    fprintf(2,'识别率为：%3.2f%%\n\n',accuracy*100);
    toc;
end


%创建文本编辑框控件,本工程未使用。
function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double

% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over listbox1.
function listbox1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
