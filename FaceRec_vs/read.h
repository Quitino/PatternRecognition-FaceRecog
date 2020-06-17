/*
����:static void read_csv(const string& filename,vector<Mat>images, vector<int> labels,int CountMax,int CountMin, char separator=';')
���ܣ���ȡcsv�ļ���ͼ��·���ͱ�ǩ����Ҫʹ��stringstream��getline()
separator-�ָ���������ƶ�ȡ�����á����Զ���Ϊ���ſո�ȣ����˳����У�Ĭ��Ϊ�ֺ�
����ֵ����
*/
/*
��ע���������ڲ��漰���Ĳ�����ͷ���˵����
1. stringstream:�ַ�������
���ܣ����ڴ��еĶ��������󶨡�

2. getline():
����ԭ�ͣ�istream &getline( ifstream &input,string &out,char dielm)
����˵����Input--�����ļ�
out----����ַ���
dielm--��ȡ�����ַ�ֹͣ���𵽿������ã���Ĭ���ǻ��з���\n��
���ܣ� ��ȡ�ļ�Input�е��ַ�����out�С�
����ֵ������Input�������ļ�ĩβ�᷵���ļ�β����ʶeof

3. ifstream: ��Ӳ�̴��ļ�����ȡ�����Ӵ��������ļ��������ڴ���
ofstream: ���ڴ���ļ�����ȡ�������ڴ������ļ������������У�

opencv�̳� https://docs.opencv.org/3.0.0/db/d7c/group__face.html
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
#include <io.h> //�����ļ���غ���
#include <opencv2/face.hpp>  // ����FaceRecognizer�������opencv_contrib���������

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
		*  @Descrip : ���캯��
		*  @Para    : None
		*  @Return  : None
		*  @Notes   :
		***********************************************/
		CfaceRec(){};

		/***********************************************
		*  @Name    :
		*  @Descrip : ��������
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

		//HOG���������������HOG�����ӵ�
		int DescriptorDim;//HOG�����ӵ�ά������ͼƬ��С����ⴰ�ڴ�С�����С��ϸ����Ԫ��ֱ��ͼbin��������
		Mat sampleFeatureMat;//����ѵ������������������ɵľ��������������������ĸ�������������HOG������ά��
		Mat sampleLabelMat;//ѵ����������������������������������ĸ�������������1��1��ʾ���ˣ�-1��ʾ����

		//HOGDescriptor hog(Size(64, 128), Size(16, 16), Size(8, 8), Size(8, 8), 9);
				
		Ptr<face::FaceRecognizer> EigenFaceModel = EigenFaceRecognizer::create();

		Ptr<face::FaceRecognizer> FisherFaceModel = FisherFaceRecognizer::create();

		Ptr<face::FaceRecognizer> LBPHFaceModel = LBPHFaceRecognizer::create();

		Ptr<ml::SVM> HogSvmModel = ml::SVM::create(); //����Ԥ�������HOG
		
	};

}
#endif READ_H_