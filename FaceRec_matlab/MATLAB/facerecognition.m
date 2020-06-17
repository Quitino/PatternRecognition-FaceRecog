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

%����fisher�ص�����
function fisher_Callback(hObject, eventdata, handles)
%%%%%%%%��ѵ��������ת����200x10304�ľ���ÿһ�д���һ������
disp('******ѡ��ѵ�������ļ���******')
TrainImagePath = uigetdir(strcat(matlabroot,'\work'), 'ѡ��ѵ������·�� ' );%��ȡ·��
TrainSample=zeros(150,112*92);
for i=1:150        
    str = int2str(i);
    str = strcat('\',str,'.BMP');
    str = strcat(TrainImagePath,str);
    img = imread(str);
    TrainSample(i,:)=img(:)';
end
TrainSample=double(TrainSample);  

%%%%%%%%�����Լ�����ת����200x10304�ľ���ÿһ�д���һ������
disp('******ѡ����������ļ���******')
TestImagePath = uigetdir(strcat(matlabroot,'\work'), 'Please select the TestSampleFisherImage Path');%��ȡ·��
TestSample=zeros(150,112*92);
for i=1:150        
    str = int2str(i);
    str = strcat('\',str,'.BMP');
    str = strcat(TestImagePath,str);
    img = imread(str);
    TestSample(i,:)=img(:)';
end
TestSample=double(TestSample);  

%%%%%%%%������ע������200x1��-����������ǩ
disp('******������ע����******')
Label=ones(5,1);        
for i=1:29
    LabelTemp=(i+1)*ones(5,1);
    Label=[Label ; LabelTemp];
    Label=double(Label);
end

%%%%%%%%PCA��ά
disp('******PCA��ά******')
[TrainSampleRow,TrainSampleCloumn] = size(TrainSample);
classLabel = unique(Label);%ȥ���ظ�--(30x1)
LenthClassLabel = length(classLabel);

if  TrainSampleCloumn > (TrainSampleRow - LenthClassLabel)
    [dataset_coef,TrainSample_score,dataset_latent,dataset_t2] = princomp(TrainSample);   %���ɱ任����
    TestSample_score= bsxfun(@minus,TestSample,mean(TrainSample,1))*dataset_coef;         %�Ѳ�������ת�䵽�µ�����ϵ
    
    TrainSample=TrainSample_score(:,1:TrainSampleRow-LenthClassLabel);
    TestSample=TestSample_score(:,1:TrainSampleRow-LenthClassLabel);
   
    [TrainSampleRow,TrainSampleCloumn] = size(TrainSample);   
end

%%%%%%%%%%%%%Fisher����
disp('******Fisher����******')
sampleMean = mean(TrainSample);

Sb = zeros(TrainSampleCloumn, TrainSampleCloumn);        %�����ɢ�Ⱦ���
Sw = zeros(TrainSampleCloumn, TrainSampleCloumn);        %������ɢ�Ⱦ���
for i = 1:LenthClassLabel
    index = find(Label==classLabel(i));
    classMean = mean(TrainSample(index, :));
    %�����ɢ�Ⱦ���
    Sb = Sb + (length(index)/TrainSampleRow)*(sampleMean-classMean)'*(sampleMean-classMean);
    Xclass=TrainSample(index,:);
    tempSw=zeros(TrainSampleCloumn,TrainSampleCloumn);
    
    for j=1:length(index)
        tempSw=tempSw+(Xclass(j,:)-classMean)'*(Xclass(j,:)-classMean);
    end
    %������ɢ�Ⱦ���
    Sw=Sw + (length(index)/TrainSampleRow)*tempSw;
end

%���������ռ�
[eigvector, eigvalue] = eigs((Sw\Sb),LenthClassLabel,'LR');
%ͶӰ
TrainSampleFisher= TrainSample * eigvector;         %��150x29)
TestSampleFisher = TestSample * eigvector;          %(150x29)

%%%%%%%%%%%%%%%%%%%%%%%   K����Ѱ��
disp('******K����Ѱ��******')
K=3;
[rowTeFisher,colTeFisher]=size(TestSampleFisher);   %N=150,M=29
L=size(TrainSampleFisher,1);                        %L=N=150
idx = zeros(rowTeFisher,K);                         %(150x3)���D�е���Ӧ������
D = idx;                                            %(150x3)����������������֮��ľ���
for k=1:rowTeFisher                                 %N=150
    d=zeros(L,1);                                   %(150x1)--��ž���
    for t=1:colTeFisher                             %M=29
        d=d+(TrainSampleFisher(:,t)-TestSampleFisher(k,t)).^2;    %d--����(150x1)
    end
    [s,t]=sort(d);                                  %������������s--������150x1�������룻�������Ľ����t--������150x1��������
    idx(k,:)=t(1:K);                                %��ǰ����������ֵ����idx��ÿһ��
    D(k,:)=s(1:K);                                  %��ǰ�����������ֵ��ֵ��D��ÿһ��
end
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   ʹ��K�����б�
disp('******ʹ��K�����б�******')
classLabel = unique(Label);         %ȥ���ظ�
nClass = length(classLabel);        %nClass=30
kNum=3;
right=0;

for i=1 :rowTeFisher                %rowTeFisher=150
    class3Idx=idx(i,:);             %��������1x3)����ŵ���ѵ���������Լ�����̾��������������
    classIdx=zeros(1,kNum);         %������(1x3)
    for j=1 :kNum                   %kNum=3
        temp=class3Idx(j);
        
        classIdx(j)=Label(temp);    %Label--(50x1),classIdx--ѵ�������е������ı��
    end
    for k= 1: kNum
        result=zeros(1,nClass);     %��������1x10��
        classNum=classIdx(k);       %��Ӧ����̾�������������ı��
        dist=(norm(TestSampleFisher(i,:)-TrainSampleFisher(class3Idx(k),:)))^2;%norm-�����������Լ���ѵ������ѵ���������Լ���������̾��룩�ľ���
        result(classNum)=result(classNum)+1/dist;
        dist=0;
    end
    [C,I]=max(result);              %C--��֮ǰ������������̵ľ�������ͨ����������������̵ģ�I--��Ӧ������������
    testlabel(i)=I;
    if (I==Label(i))
        right=right+1;
    end   
end

for i=1:150
    disp(['ʵ�ʷ��� ',num2str(Label(i)) ,'           ','ʶ�����',num2str(testlabel(i))]);
    if Label(i)~=testlabel(i)
       disp('******����һ���������****** ');
    end
end

accurcy=right/rowTeFisher;
accurcy=strcat(num2str(accurcy*100),'%');
display(accurcy);

% ---SVM�����㷨
function SVM_Callback(hObject, eventdata, handles)
% hObject    handle to SVM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

npersons=40;      %ѡȡ200������ 
imgrow=112;   
imgcol=92;  

%%%%%%%%%%%%%   ��ȡѵ��������
disp('******��ȡѵ��������******') 
TrainImagePath = uigetdir(strcat(matlabroot,'\work'), 'Please select the TrainSampleFisherImage Path ' );%��ȡ·��
TrainImage=zeros(200,112*92);
for i=1:200        
    str = int2str(i);
    str = strcat('\',str,'.BMP');
    str = strcat(TrainImagePath,str);
    img = imread(str);
    TrainImage(i,:)=img(:)';
end
TrainImage=double(TrainImage); 

%%%%%%%%%%%%%   PCA��ά
disp('******PCA��ά******')  
meanTrain=mean(TrainImage); %�������ֵ--��1x10304��
k=70;                       %��ά��70ά  
m=size(TrainImage,1);       %m=40x5
TrainSample=(TrainImage-repmat(meanTrain,m,1));  %repmat--���ƺ�ƽ�̾���;Z--��200x10304��ȥ��ֵ����
T=TrainSample*TrainSample';                      %I�Ĵ�СΪ��200��200��
[V,D]=eigs(T,k);                                 %D--����ֵ�Խ���V��������Ϊ��Ӧ��������,V(200xk)��
EigenFace=TrainSample'*V;                        %Э���������������� ������Z(200,10304)֮����ȡת������Ϊÿ��Ϊһ������ ,EigenFace--(10304xk)
for i=1:k                                        %����������λ��   
    l=norm(EigenFace(:,i));                      %����������2����,��ƽ���Ϳ�����
    EigenFace(:,i)=EigenFace(:,i)/l;             %��������
end  
PcaFace=TrainSample*EigenFace;                   %���Ա任������kά��pcaA--��200xk��

%%%%%%%%%%%%%   ��ʾ������
disp('******��ʾ������******')  
figure();  
Img=zeros(imgrow,imgcol);  
for i=1:70 
    Img(:)=EigenFace(:,i);  
    subplot(7,10,i);          %��figure�ָ�
    imshow(Img,[]); 
end

%%%%%%%%%%%%%   ���ݹ淶��
disp('******ѵ���������ݹ淶��******')  %���ݹ�񻯣�ȥ�����ݵ�λ���ضԷ�����ɵ�Ӱ�죩
MinPca=min(PcaFace);          %��������Сֵ��lowvecΪһ������
MaxPca=max(PcaFace);  
Max=1;  
Min=-1;  
[m,n]=size(PcaFace);          %faceMat(200,20)
NormFace=zeros(m,n);  
for i=1:m  
    NormFace(i,:)=Min+(PcaFace(i,:)-MinPca)./(MaxPca-MinPca)*(Max-Min);  
end  

%%%%%%%%%%%%% SVM����ѵ�� 
disp('******SVM����ѵ��******')  
sigma=0.005;  
c=128;  
for i=1:npersons-1  
    for j=i+1:npersons  
        X=[NormFace(5*(i-1)+1:5*i,:);NormFace(5*(j-1)+1:5*j,:)]; %X(10,10) --ѵ������
        Y=[ones(5,1);zeros(5,1)];                                %Y(10,1)--ѵ����ǩ
        multiSVMstruct{i}{j}=svmtrain(X,Y,'Kernel_Function',@(X,Y) kfun_rbf(X,Y,sigma),'boxconstraint',c);   %Kernel_Function--�˺���
    end  
end  

%%%%%%%%%%%%% ��ȡ��������
disp('******��ȡ��������******')    
TestImagePath = uigetdir(strcat(matlabroot,'\work'), 'Please select the TestSampleFisherImage Path');%��ȡ·��
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

%%%%%%%%%%%%% ��������������ά
disp('******��������������ά******')  
m=size(testface,1);  
for i=1:m  
    testface(i,:)=testface(i,:)-meanTrain;  
end  
PcaTestFace=testface*EigenFace;  

%%%%%%%%%%%%% �������ݹ淶��
disp('******�����������ݹ淶��******')  
MinPca=min(PcaTestFace);  %��������Сֵ��lowvecΪһ������
MaxPca=max(PcaTestFace);  
Max=1;  
Min=-1;  
[m,n]=size(PcaTestFace);  %faceMat(200,20)
NormTestFace=zeros(m,n);  
for i=1:m  
    NormTestFace(i,:)=Min+(PcaTestFace(i,:)-MinPca)./(MaxPca-MinPca)*(Max-Min);  
end  
testface=NormTestFace;
  
%%%%%%%%%%%%% SVM������������
disp('******SVM��������******')  
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
    disp(['ʵ�ʷ��� ',num2str(realclass(i)) ,'           ','ʶ�����',num2str(class(i))]);
    if realclass(i)~=class(i)
       disp('******����һ���������****** ');
    end
end

%%%%%%%%%%%%%% ������ȷ��
disp('******������ȷ��******')
accuracy=sum(class==realclass)/length(class);  
display(['��ȷ�ʣ�',num2str(accuracy)])  

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

database=[pwd '\ORL1'];%ʹ�õ�������
train_samplesize=5;%ÿ��ѵ��������
address=[database '\s'];
rows=112;
cols=92;
ClassNum=40;
tol_num=10;
image_fmt='.bmp';

%------------------------PCA��ά-----------------------------------------
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
    %PCA��ά
    [Pro_Matrix,Mean_Image]=my_pca(train_sample,pro_dim);
    train_project=Pro_Matrix'*train_sample;
    test_project=Pro_Matrix'*test_sample;
    
    %��λ��
    train_norm=normc(train_project);
    test_norm=normc(test_project);
    
    [accuracy,xp,r,pre_label]=computaccuracy(train_norm,ClassNum,train_label,test_norm,test_label);
    fprintf('ͶӰά��Ϊ��%d\n',pro_dim);
    fprintf('ÿ��ѵ����������Ϊ��%d\n',train_samplesize);
    fprintf(2,'ʶ����Ϊ��%3.2f%%\n\n',accuracy*100);
    toc;
end


%�����ı��༭��ؼ�,������δʹ�á�
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
