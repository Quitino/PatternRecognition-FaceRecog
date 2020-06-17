/*****************************************************************************
* @FileName: facerec.h
* @Author: FengBo
* @Mail: fengzinan23@gmail.com
* @CreatTime: 2018/12/25 10:55
* @Descriptions: opencv334x64debug版本，需要使用Cmake编译opencv334以
*				及opencv334-contrib部分。部分函数调用了opencv-contrib内容。
* @Version: ver 1.0
* @Copyright(C),2018-2021,Southwest University of Science and Technology.
*****************************************************************************/
#ifndef FACEREC_H
#define FACEREC_H

#include <QtWidgets/QMainWindow>
#include "ui_facerec.h"
#include < QTime>
#include "QMessageBox"
#include "QFileDialog"
#include <qfiledialog.h>                //getopenfilename 类申明
#include<QGraphicsScene>  
#include<QGraphicsView>                   //graphicsview类
#include <qlabel.h>                     //label类
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
#include <io.h> 
#include <opencv2/face.hpp>  // opencv_contrib里面的内容

using namespace      std;
using namespace       cv;
using namespace cv::face;
using namespace   cv::ml;

const int  nEigenFace = 1;
const int nFisherFace = 2;
const int   nLBPHFace = 3;
const int nHogSvmFace = 4;


class FaceRec : public QMainWindow
{
	Q_OBJECT

public:
	FaceRec(QWidget *parent = 0);
	~FaceRec();

	/*****************************************************************************
	* @brief: 文件读取函数
	* @author: FengBo
	* @date: 2018/12/25 10:59
	* @inparam: 索引文件路径加文件名
	* @outparam: 图片向量，标签，分隔符
	*****************************************************************************/
	bool read_csv(const string& filename, vector<cv::Mat>& images,
		vector<int>& labels, char separator);

	//bool displayEigen(const  Ptr<face::EigenFaceRecognizer> model);
	/*****************************************************************************
	* @brief: 训练HOG+SVM并保存模型
	* @author: FengBo
	* @date: 2018/12/25 11:01
	* @inparam: 
	* @outparam: 
	*****************************************************************************/
	bool createHogSvm();

	/*****************************************************************************
	* @brief: 测试HOG+SVM模型
	* @author: FengBo
	* @date: 2018/12/25 11:01
	* @inparam: 
	* @outparam: 
	*****************************************************************************/
	bool createHogSvmTest();

	//bool run();
	/*****************************************************************************
	* @brief:模型训练函数
	* @author: FengBo
	* @date: 2018/12/25 11:03
	* @inparam: 
	* @outparam: 
	*****************************************************************************/
	bool train();

	/*****************************************************************************
	* @brief: 模型测试函数
	* @author: FengBo
	* @date: 2018/12/25 11:03
	* @inparam: 
	* @outparam: 
	*****************************************************************************/
	bool test(const  Ptr<face::FaceRecognizer> model, const int flag);

	/*****************************************************************************
	* @brief: SVM训练函数
	* @author: FengBo
	* @date: 2018/12/25 11:04
	* @inparam: 
	* @outparam: 
	*****************************************************************************/
	void svmTrain();

	/*****************************************************************************
	* @brief: SVM预测函数
	* @author: FengBo
	* @date: 2018/12/25 11:04
	* @inparam: 
	* @outparam: 
	*****************************************************************************/
	void svmPredict();

	/*****************************************************************************
	* @brief: SVM训练图片读取函数，因使用方法和其他方法不一样，该函数无法重载，也有可能是我自己还没能实现重载。
	* @author: FengBo
	* @date: 2018/12/25 11:05
	* @inparam: 
	* @outparam: 
	*****************************************************************************/
	bool Svmread_csv(const string& csvPath, vector<string>& trainPath,
		vector<int>& label, char separator = ',');

	/*****************************************************************************
	* @brief: 向量转矩阵
	* @author: FengBo
	* @date: 2018/12/25 11:06
	* @inparam: 
	* @outparam: 
	* @@return:   
	*****************************************************************************/
	template<typename _Tp>
	cv::Mat convertVector2Mat(vector<_Tp> v, int channels, int rows);

	/*****************************************************************************
	* @brief: QT界面里面使用的延时函数
	* @author: FengBo
	* @date: 2018/12/25 11:06
	* @inparam: 
	* @outparam: 
	* @@return:   
	*****************************************************************************/
	void delay(unsigned int msec);

public:
	string trainCsvFile = "D:\\PatternRecognition\\FaceRec_vs\\data\\train_200.csv";
	vector<cv::Mat> trainImages;
	vector<int> trainLabels;

	string testCsvFile = "D:\\PatternRecognition\\FaceRec_vs\\data\\test2_200.csv";
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

private:
	Ui::FaceRecClass ui;
	QPalette   pal;
	QLabel *img1label;
	QLabel *img2label;
		
private slots:
	/*****************************************************************************
	* @brief: QT信号槽函数
	* @author: FengBo
	* @date: 2018/12/25 11:07
	* @inparam: 
	* @outparam: 
	* @@return:   
	*****************************************************************************/
	bool EigenFace();	
	/*****************************************************************************
	* @brief: QT信号槽函数
	* @author: FengBo
	* @date: 2018/12/25 11:08
	* @inparam: 
	* @outparam: 
	* @@return:   
	*****************************************************************************/
	bool LBPHFace();
	/*****************************************************************************
	* @brief: QT信号槽函数
	* @author: FengBo
	* @date: 2018/12/25 11:08
	* @inparam: 
	* @outparam: 
	* @@return:   
	*****************************************************************************/
	bool FisherFace();
	/*****************************************************************************
	* @brief: QT信号槽函数
	* @author: FengBo
	* @date: 2018/12/25 11:08
	* @inparam: 
	* @outparam: 
	* @@return:   
	*****************************************************************************/
	bool HogSvmFace();
	/*****************************************************************************
	* @brief: QT信号槽函数
	* @author: FengBo
	* @date: 2018/12/25 11:08
	* @inparam: 
	* @outparam: 
	* @@return:   
	*****************************************************************************/
	bool trian();

	/*****************************************************************************
	* @brief: QT信号槽函数
	* @author: FengBo
	* @date: 2018/12/25 11:24
	* @inparam: 
	* @outparam: 
	* @@return:   
	*****************************************************************************/
	void QTexit();

};

#endif // FACEREC_H
