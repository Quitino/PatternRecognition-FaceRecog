/*****************************************************************************
* @FileName: facerec.h
* @Author: FengBo
* @Mail: fengzinan23@gmail.com
* @CreatTime: 2018/12/25 10:55
* @Descriptions: opencv334x64debug�汾����Ҫʹ��Cmake����opencv334��
*				��opencv334-contrib���֡����ֺ���������opencv-contrib���ݡ�
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
#include <qfiledialog.h>                //getopenfilename ������
#include<QGraphicsScene>  
#include<QGraphicsView>                   //graphicsview��
#include <qlabel.h>                     //label��
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
#include <opencv2/face.hpp>  // opencv_contrib���������

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
	* @brief: �ļ���ȡ����
	* @author: FengBo
	* @date: 2018/12/25 10:59
	* @inparam: �����ļ�·�����ļ���
	* @outparam: ͼƬ��������ǩ���ָ���
	*****************************************************************************/
	bool read_csv(const string& filename, vector<cv::Mat>& images,
		vector<int>& labels, char separator);

	//bool displayEigen(const  Ptr<face::EigenFaceRecognizer> model);
	/*****************************************************************************
	* @brief: ѵ��HOG+SVM������ģ��
	* @author: FengBo
	* @date: 2018/12/25 11:01
	* @inparam: 
	* @outparam: 
	*****************************************************************************/
	bool createHogSvm();

	/*****************************************************************************
	* @brief: ����HOG+SVMģ��
	* @author: FengBo
	* @date: 2018/12/25 11:01
	* @inparam: 
	* @outparam: 
	*****************************************************************************/
	bool createHogSvmTest();

	//bool run();
	/*****************************************************************************
	* @brief:ģ��ѵ������
	* @author: FengBo
	* @date: 2018/12/25 11:03
	* @inparam: 
	* @outparam: 
	*****************************************************************************/
	bool train();

	/*****************************************************************************
	* @brief: ģ�Ͳ��Ժ���
	* @author: FengBo
	* @date: 2018/12/25 11:03
	* @inparam: 
	* @outparam: 
	*****************************************************************************/
	bool test(const  Ptr<face::FaceRecognizer> model, const int flag);

	/*****************************************************************************
	* @brief: SVMѵ������
	* @author: FengBo
	* @date: 2018/12/25 11:04
	* @inparam: 
	* @outparam: 
	*****************************************************************************/
	void svmTrain();

	/*****************************************************************************
	* @brief: SVMԤ�⺯��
	* @author: FengBo
	* @date: 2018/12/25 11:04
	* @inparam: 
	* @outparam: 
	*****************************************************************************/
	void svmPredict();

	/*****************************************************************************
	* @brief: SVMѵ��ͼƬ��ȡ��������ʹ�÷���������������һ�����ú����޷����أ�Ҳ�п��������Լ���û��ʵ�����ء�
	* @author: FengBo
	* @date: 2018/12/25 11:05
	* @inparam: 
	* @outparam: 
	*****************************************************************************/
	bool Svmread_csv(const string& csvPath, vector<string>& trainPath,
		vector<int>& label, char separator = ',');

	/*****************************************************************************
	* @brief: ����ת����
	* @author: FengBo
	* @date: 2018/12/25 11:06
	* @inparam: 
	* @outparam: 
	* @@return:   
	*****************************************************************************/
	template<typename _Tp>
	cv::Mat convertVector2Mat(vector<_Tp> v, int channels, int rows);

	/*****************************************************************************
	* @brief: QT��������ʹ�õ���ʱ����
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

	//HOG���������������HOG�����ӵ�
	int DescriptorDim;//HOG�����ӵ�ά������ͼƬ��С����ⴰ�ڴ�С�����С��ϸ����Ԫ��ֱ��ͼbin��������
	Mat sampleFeatureMat;//����ѵ������������������ɵľ��������������������ĸ�������������HOG������ά��
	Mat sampleLabelMat;//ѵ����������������������������������ĸ�������������1��1��ʾ���ˣ�-1��ʾ����

	//HOGDescriptor hog(Size(64, 128), Size(16, 16), Size(8, 8), Size(8, 8), 9);

	Ptr<face::FaceRecognizer> EigenFaceModel = EigenFaceRecognizer::create();

	Ptr<face::FaceRecognizer> FisherFaceModel = FisherFaceRecognizer::create();

	Ptr<face::FaceRecognizer> LBPHFaceModel = LBPHFaceRecognizer::create();

	Ptr<ml::SVM> HogSvmModel = ml::SVM::create(); //����Ԥ�������HOG

private:
	Ui::FaceRecClass ui;
	QPalette   pal;
	QLabel *img1label;
	QLabel *img2label;
		
private slots:
	/*****************************************************************************
	* @brief: QT�źŲۺ���
	* @author: FengBo
	* @date: 2018/12/25 11:07
	* @inparam: 
	* @outparam: 
	* @@return:   
	*****************************************************************************/
	bool EigenFace();	
	/*****************************************************************************
	* @brief: QT�źŲۺ���
	* @author: FengBo
	* @date: 2018/12/25 11:08
	* @inparam: 
	* @outparam: 
	* @@return:   
	*****************************************************************************/
	bool LBPHFace();
	/*****************************************************************************
	* @brief: QT�źŲۺ���
	* @author: FengBo
	* @date: 2018/12/25 11:08
	* @inparam: 
	* @outparam: 
	* @@return:   
	*****************************************************************************/
	bool FisherFace();
	/*****************************************************************************
	* @brief: QT�źŲۺ���
	* @author: FengBo
	* @date: 2018/12/25 11:08
	* @inparam: 
	* @outparam: 
	* @@return:   
	*****************************************************************************/
	bool HogSvmFace();
	/*****************************************************************************
	* @brief: QT�źŲۺ���
	* @author: FengBo
	* @date: 2018/12/25 11:08
	* @inparam: 
	* @outparam: 
	* @@return:   
	*****************************************************************************/
	bool trian();

	/*****************************************************************************
	* @brief: QT�źŲۺ���
	* @author: FengBo
	* @date: 2018/12/25 11:24
	* @inparam: 
	* @outparam: 
	* @@return:   
	*****************************************************************************/
	void QTexit();

};

#endif // FACEREC_H
