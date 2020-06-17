/*
函数:static void read_csv(const string& filename,vector<Mat>images, vector<int> labels,int CountMax,int CountMin, char separator=';')
功能：读取csv文件的图像路径和标签。主要使用stringstream和getline()
separator-分隔符，起控制读取的作用。可自定义为逗号空格等，（此程序中）默认为分号
返回值：空
*/
/*
备注：（函数内部涉及到的部分类和方法说明）
1. stringstream:字符串流。
功能：将内存中的对象与流绑定。

2. getline():
函数原型：istream &getline( ifstream &input,string &out,char dielm)
参数说明：Input--输入文件
out----输出字符串
dielm--读取到该字符停止（起到控制作用），默认是换行符‘\n’
功能： 读取文件Input中的字符串到out中。
返回值：返回Input，若是文件末尾会返回文件尾部标识eof

3. ifstream: 从硬盘打开文件（读取），从磁盘输入文件，读到内存中
ofstream: 从内存打开文件（读取），从内存输入文件，读到磁盘中）

opencv教程 https://docs.opencv.org/3.0.0/db/d7c/group__face.html
*/
#ifndef READ_H_
#define READ_H_

#include <iostream>
#include <fstream> 
#include <string.h>
#include <vector>
#include "cv.h" 
#include "highgui.h" 
#include <opencv2/opencv.hpp>
#include "opencv2/core.hpp"
#include "opencv2/highgui.hpp"
#include "opencv2/imgproc.hpp"
#include <opencv/ml.h>
#include <io.h> //查找文件相关函数
#include <opencv2/face.hpp>  // 包含FaceRecognizer，这个是opencv_contrib里面的内容

using namespace      std;
using namespace       cv;
using namespace cv::face;
using namespace   cv::ml;

const int  EigenFace = 1;
const int FisherFace = 2;
const int   LBPHFace = 3;
const int HogSvmFace = 4;

namespace IPSG
{
	class CfaceRec
	{
	public:
		/***********************************************
		*  @Name    :
		*  @Descrip : 构造函数
		*  @Para    : None
		*  @Return  : None
		*  @Notes   :
		***********************************************/
		CfaceRec(){};

		/***********************************************
		*  @Name    :
		*  @Descrip : 析构函数
		*  @Para    : None
		*  @Return  : None
		*  @Notes   : None
		***********************************************/
		~CfaceRec(){};

		bool read_csv(const string& filename, vector<cv::Mat>& images,
			vector<int>& labels,  char separator );

		//bool displayEigen(const  Ptr<face::EigenFaceRecognizer> model);
		bool createHogSvm();
		bool createHogSvmTest();

		bool run();
		bool train();
		bool test(const  Ptr<face::FaceRecognizer> model, const int flag);

		void IPSG::CfaceRec::svmTrain();
		void IPSG::CfaceRec::svmPredict();

		bool IPSG::CfaceRec::Svmread_csv(const string& csvPath, vector<string>& trainPath,
			vector<int>& label, char separator = ',');

		template<typename _Tp>
		cv::Mat convertVector2Mat(vector<_Tp> v, int channels, int rows);

	public:
		string trainCsvFile = "D://PatternRecognition//FaceRec_vs//data//train_200.csv";
		vector<cv::Mat> trainImages;
		vector<int> trainLabels;

		string testCsvFile = "D://PatternRecognition//FaceRec_vs//data//test2_200.csv";
		vector<cv::Mat> testImages;
		vector<int> testLabels;
	
	//private:
	public:

		int coutnum = 0;
		double acc = 0.0;
		
		int ImgWidht = 64;
		int ImgHeight = 64;

		unsigned long n;

		string line, path, label;

		//HOG检测器，用来计算HOG描述子的
		int DescriptorDim;//HOG描述子的维数，由图片大小、检测窗口大小、块大小、细胞单元中直方图bin个数决定
		Mat sampleFeatureMat;//所有训练样本的特征向量组成的矩阵，行数等于所有样本的个数，列数等于HOG描述子维数
		Mat sampleLabelMat;//训练样本的类别向量，行数等于所有样本的个数，列数等于1；1表示有人，-1表示无人

		//HOGDescriptor hog(Size(64, 128), Size(16, 16), Size(8, 8), Size(8, 8), 9);
				
		Ptr<face::FaceRecognizer> EigenFaceModel = EigenFaceRecognizer::create();

		Ptr<face::FaceRecognizer> FisherFaceModel = FisherFaceRecognizer::create();

		Ptr<face::FaceRecognizer> LBPHFaceModel = LBPHFaceRecognizer::create();

		Ptr<ml::SVM> HogSvmModel = ml::SVM::create(); //数据预处理采用HOG
		
	};

}
#endif READ_H_