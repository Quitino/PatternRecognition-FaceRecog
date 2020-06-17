/*****************************************************************************
* @FileName: facerec.cpp
* @Author: FengBo
* @Mail: fengzinan23@gmail.com
* @CreatTime: 2018/12/25 11:09
* @Descriptions:
* @Version: ver 1.0
* @Copyright(C),2018-2021,Southwest University of Science and Technology.
*****************************************************************************/
#pragma execution_character_set("utf-8")
#include "facerec.h"

FaceRec::FaceRec(QWidget *parent)
	: QMainWindow(parent)
{
	ui.setupUi(this);
	//this->setStyleSheet("background-color:rgb(128,128,128)");
	setWindowIcon(QIcon("E://SWUST.png"));
	//pal.setColor(QPalette::ButtonText, QColor(255, 0, 0));
	//EigenFaceCancel->setPalette(pal);
	//ui.EigenFace->setStyleSheet("background-color: rgb(0,255,0)");//没置背景色緑色
	this->setStyleSheet("background-color:rgb(220,220,220);");
	//ui.centralWidget->setStyleSheet("background-color:transparent;background-image:url(E:/SWUST.png)");
	//ui.centralWidget->hide();



	ui.FisherFace->setStyleSheet("color : rgb(0,0,255)");
	ui.LBPHFace->setStyleSheet("color : rgb(0,0,255)");
	ui.HogSvmFace->setStyleSheet("color : rgb(0,0,255)");
	ui.EigenFace->setStyleSheet("color : rgb(0,0,255)");
	ui.trian->setStyleSheet("color : rgb(0,0,255)");
	ui.QTexit->setStyleSheet("color : rgb(0,0,255)");
	connect(ui.EigenFace, SIGNAL(clicked()), this, SLOT(EigenFace()));
	connect(ui.FisherFace, SIGNAL(clicked()), this, SLOT(FisherFace()));
	connect(ui.LBPHFace, SIGNAL(clicked()), this, SLOT(LBPHFace()));
	connect(ui.HogSvmFace, SIGNAL(clicked()), this, SLOT(HogSvmFace()));
	connect(ui.trian, SIGNAL(clicked()), this, SLOT(trian()));
	connect(ui.QTexit, SIGNAL(clicked()), this, SLOT(QTexit()));
	
}

FaceRec::~FaceRec()
{

}

bool FaceRec::trian()
{
	ui.textedit->append("======welcome to FaceRec system !=========");
	delay(1);
	ui.textedit->append("=========Models Train Begin !============");
	delay(1);
	train();
	createHogSvm();
	ui.textedit->append("==========Models Train End !============");
	delay(1);
	ui.textedit->append("======Now,Please Press Test Button !=======");
	delay(1);
	return true;
}

bool FaceRec::EigenFace()
{
	ui.textedit->append("=========EigenFace Test Begin !===========");
	delay(1);
	test(EigenFaceModel, nEigenFace);
	return true;
}

bool  FaceRec::LBPHFace()
{
	ui.textedit->append("========LBPHFace Test Begin !=============");
	delay(1);
	test(LBPHFaceModel, nLBPHFace);	
	return true;
}

bool FaceRec::FisherFace()
{
	ui.textedit->append("=======FisherFace Test Begin !============");
	delay(1);
	test(FisherFaceModel, nFisherFace);
	return true;
}

bool FaceRec::HogSvmFace()
{

	ui.textedit->append("=======HogSvmFace Test Begin !============");
	delay(1);
	createHogSvmTest();
	ui.textedit->append("===Model Test End, Have a good day!=======");
	delay(1);
	return true;
}



template<typename _Tp>
cv::Mat convertVector2Mat(vector<_Tp> v, int channels, int rows)
{
	cv::Mat mat = cv::Mat(v);//将vector变成单列的mat
	cv::Mat dest = mat.reshape(channels, rows).clone();//PS：必须clone()一份，否则返回出错
	return dest;
}

bool FaceRec::read_csv(const string& filename, vector<Mat>& images,
	vector<int>& labels, char separator = ',')
{
	// 以in模式（读取文件模式）打开文件 ,实际是将filename文件关联给 流file
	std::ifstream file(filename.c_str(), ifstream::in);
	if (!file)
	{
		string error_message = "No valid input file was given, please check the given filename.";
		CV_Error(Error::StsBadArg, error_message);
	}
	string line, path, classlabel;
	//读取file文件中的一行字符串给 line
	while (getline(file, line))
	{
		//将line整行字符串读取到lines(流)中
		//区别->lines是流，读取字符时，指针会随流而动；而line是string，固定的，下文中的读取每次都是从line头开始
		stringstream liness(line);
		//读取文件中的路径和标签
		getline(liness, path, separator);
		getline(liness, classlabel);
		if (!path.empty() && !classlabel.empty())
		{
			images.push_back(imread(path, 0));
			labels.push_back(atoi(classlabel.c_str()));
		}
	}
	return true;
}

bool FaceRec::createHogSvm()
{
	//winsize(64,128),blocksize(16,16),blockstep(8,8),cellsize(8,8),bins9
	//检测窗口(64,128),块尺寸(16,16),块步长(8,8),cell尺寸(8,8),直方图bin个数9
	HOGDescriptor hog(Size(64, 128), Size(16, 16), Size(8, 8), Size(8, 8), 9);
	//read_csv(trainCsvFile, trainImages, trainLabels, ',');
	vector<float> descriptors;//HOG描述子向量
	descriptors.reserve(4000);
	for (int num = 0; num < 200; num++)
	{
		Mat src = trainImages.at(num);//读取图片

		cv::resize(src, src, cv::Size(64, 128));
		hog.compute(src, descriptors, cv::Size(16, 16));//计算HOG描述子，检测窗口移动步长
		//处理第一个样本时初始化特征向量矩阵和类别矩阵，因为只有知道了特征向量的维数才能初始化特征向量矩阵
		if (0 == num)
		{
			DescriptorDim = descriptors.size();
			//初始化所有训练样本的特征向量组成的矩阵，行数等于所有样本的个数，列数等于HOG描述子维数sampleFeatureMat
			sampleFeatureMat = Mat::zeros(200, DescriptorDim, CV_32FC1);
			//初始化训练样本的类别向量，行数等于所有样本的个数，列数等于1；1表示有人，0表示无人
			sampleLabelMat = Mat::zeros(200, 1, CV_32SC1);//sampleLabelMat的数据类型必须为有符号整数型
		}
		sampleLabelMat.at<int>(num, 0) = num / 5 + 1;//样本标签，每五个一组。
		//将计算好的HOG描述子复制到样本特征矩阵sampleFeatureMat
		for (int i = 0; i < DescriptorDim; i++)
		{
			sampleFeatureMat.at<float>(num, i) = descriptors.at(i);//第num个样本的特征向量中的第i个元素
		}
	}//从第二张图片开始，这里内存指针错误！！

	//输出样本的HOG特征向量矩阵到文件
	HogSvmModel->setType(SVM::C_SVC);
	HogSvmModel->setC(0.01);
	HogSvmModel->setKernel(SVM::LINEAR);
	HogSvmModel->setTermCriteria(TermCriteria(TermCriteria::MAX_ITER, 3000, 1e-6));

	HogSvmModel->train(sampleFeatureMat, ROW_SAMPLE, sampleLabelMat);//训练分类器
	HogSvmModel->SVM::save("HogSvmModel.xml");
	ui.textedit->append("train_200.create HogSvmModel finish!"); 
	delay(1);
	return true;
}

bool FaceRec::createHogSvmTest()
{
	coutnum = 0;
	HOGDescriptor hog(Size(64, 128), Size(16, 16), Size(8, 8), Size(8, 8), 9);
	//read_csv(trainCsvFile, trainImages, trainLabels, ',');
	vector<float> descriptors;//HOG描述子向量
	descriptors.reserve(4000);
	Ptr<SVM> svm = SVM::create();
	HogSvmModel = SVM::load("HogSvmModel.xml");
	ui.textedit->append("HogSvmFace 错误分类：");
	delay(1);
	for (int i = 0; i < 200; i++)
	{
		Mat test = testImages.at(i);//读取图片
		cv::resize(test, test, cv::Size(64, 128));
		hog.compute(test, descriptors, Size(16, 16));//计算HOG描述子，检测窗口移动步长(8,8)

		int predictedLabel = HogSvmModel->predict(descriptors);
		string result_message = format("Predicted class = %d || Actual class = %d.", predictedLabel, testLabels.at(i));
		QString PT1Str = QString("%1").arg(predictedLabel);
		QString PT2Str = QString("%1").arg(testLabels.at(i));

		QImage img = QImage((const unsigned char*)(testImages.at(i).data), testImages.at(i).cols,
			testImages.at(i).rows, testImages.at(i).cols*testImages.at(i).channels(), QImage::Format_Indexed8);
		cv::imshow("img", testImages.at(i));
		img1label = new QLabel();
		img1label->setWordWrap(true);
		img1label->setAlignment(Qt::AlignTop);
		QString s2 = "测试图片";
		img1label->setText(s2.split("", QString::SkipEmptyParts).join("\n"));
		img1label->setPixmap(QPixmap::fromImage(img).scaled(ui.imgshow1->size()));
		//img1label->resize(QSize(img.width(), img.height()));
		ui.imgshow1->setWidget(img1label);
		delay(10);
		img2label = new QLabel();
		img2label->setWordWrap(true);
		img2label->setAlignment(Qt::AlignTop);
		QString s1 = "分类图片";
		img2label->setText(s1.split("", QString::SkipEmptyParts).join("\n"));
		if (predictedLabel != testLabels.at(i))
		{
			QImage img = QImage((const unsigned char*)(testImages.at(predictedLabel).data),
				testImages.at(predictedLabel).cols, testImages.at(predictedLabel).rows,
				testImages.at(predictedLabel).cols*testImages.at(predictedLabel).channels(), QImage::Format_Indexed8);
			img2label->setPixmap(QPixmap::fromImage(img).scaled(ui.imgshow2->size()));
			img2label->resize(QSize(img.width(), img.height()));
			ui.imgshow2->setWidget(img2label);
			delay(2000);
			coutnum++;
			ui.textedit->append("Predicted class = "+ PT1Str + "||" + "Actual class =" + PT2Str +".");
			delay(1);
		}
		else
		{
			QImage img = QImage((const unsigned char*)(testImages.at(i).data),
				testImages.at(i).cols, testImages.at(i).rows,
				testImages.at(i).cols*testImages.at(i).channels(), QImage::Format_Indexed8);
			img2label->setPixmap(QPixmap::fromImage(img).scaled(ui.imgshow2->size()));
			img2label->resize(QSize(img.width(), img.height()));
			ui.imgshow2->setWidget(img2label);
			delay(10);
		}
	}
	acc = (200.0 - coutnum) / 200.0;
	QString PT6Str = QString("%1").arg(acc);
	ui.textedit->append("HogSvmFace acc: " + PT6Str +".");
	delay(1);
	//cout << "HogSvmFace acc:  " << acc << endl;
	return true;
}

bool FaceRec::train()
{
	read_csv(trainCsvFile, trainImages, trainLabels, ',');

	if (trainImages.size() <= 1)
	{
		string errMsg = "THis demo needs at least 2 trainImages to work.please add trainImages!";
		CV_Error(CV_StsError, errMsg);
	}
	ui.textedit->append("train_200 load success!" );
	delay(1);
	EigenFaceModel->train(trainImages, trainLabels); //训练  
	EigenFaceModel->save("EigenFaceModel.xml"); //将训练模型保存
	ui.textedit->append("train_200.create EigenFaceModel finish!");
	delay(1);
	FisherFaceModel->train(trainImages, trainLabels);
	FisherFaceModel->save("FisherFaceModel.xml");
	ui.textedit->append("train_200.create FisherFaceModel finish!" );
	delay(1);
	LBPHFaceModel->train(trainImages, trainLabels);
	LBPHFaceModel->save("LBPHFaceModel.xml");
	ui.textedit->append("train_200.create LBPHFaceModel finish!");
	delay(1);

	return true;
}

bool FaceRec::test(const  Ptr<face::FaceRecognizer> model, const int flag)
{
	int predictedLabel = 0;
	string result_message = "0";
	coutnum = 0;
	try
	{
		read_csv(testCsvFile, testImages, testLabels);
	}
	catch (cv::Exception& e)
	{
		cerr << "Error opening file \"" << testCsvFile << "\". Reason: " << e.msg << endl;
		// nothing more we can do
		exit(1);
	}
	// Quit if there are not enough testImages for this demo.
	if (testImages.size() <= 1) {
		string error_message = "This demo needs at least 2 testImages to work. Please add more testImages to your data set!";
		CV_Error(Error::StsError, error_message);
	}

	ui.textedit->append("test_200 load success!");
	delay(1);
	switch (flag)
	{
	//case nEigenFace:cout << endl << "EigenFace 错误分类：" << endl; break;
	//case nFisherFace:cout << endl << "FisherFace 错误分类：" << endl; break;
	//case nLBPHFace:cout << endl << "LBPHFace 错误分类： " << endl; break;
	case nEigenFace:ui.textedit->append("EigenFace 错误分类："); delay(1); break;
	case nFisherFace:ui.textedit->append("FisherFace 错误分类："); delay(1); break;
	case nLBPHFace:ui.textedit->append("LBPHFace 错误分类： "); delay(1); break;
		
	default:break;
	}
	// predictedLabel是预测标签结果
	for (int i = 0; i < 200; i++)
	{


		QImage img = QImage((const unsigned char*)(testImages.at(i).data), testImages.at(i).cols,
			testImages.at(i).rows, testImages.at(i).cols*testImages.at(i).channels(), QImage::Format_Indexed8);
		//cv::imshow("img",testImages.at(i));
		img1label = new QLabel();
		img1label->setWordWrap(true);
		img1label->setAlignment(Qt::AlignTop);
		QString s3 = "测试图片";
		img1label->setText(s3.split("", QString::SkipEmptyParts).join("\n"));
		img1label->setPixmap(QPixmap::fromImage(img).scaled(ui.imgshow1->size()));
		//img1label->resize(QSize(img.width(), img.height()));
		ui.imgshow1->setWidget(img1label);
		delay(10);
		img2label = new QLabel();
		img2label->setWordWrap(true);
		img2label->setAlignment(Qt::AlignTop);
		QString s4 = "分类图片";
		img2label->setText(s4.split("", QString::SkipEmptyParts).join("\n"));
		predictedLabel = model->predict(testImages.at(i));
		result_message = format("Predicted class = %d / Actual class = %d.", predictedLabel, testLabels.at(i));
		QString PT3Str = QString("%1").arg(predictedLabel);
		QString PT4Str = QString("%1").arg(testLabels.at(i));

		
		if (predictedLabel != testLabels.at(i))
		{
			//coutnum++;
			//cout << result_message << endl;
			QImage img = QImage((const unsigned char*)(testImages.at(predictedLabel).data), 
				testImages.at(predictedLabel).cols, testImages.at(predictedLabel).rows, 
				testImages.at(predictedLabel).cols*testImages.at(predictedLabel).channels(), QImage::Format_Indexed8);
			img2label->setPixmap(QPixmap::fromImage(img).scaled(ui.imgshow2->size()));
			img2label->resize(QSize(img.width(), img.height()));
			ui.imgshow2->setWidget(img2label);
			delay(2000);
			coutnum++;
			ui.textedit->append("Predicted class = " + PT3Str + "||" + "Actual class =" + PT4Str + ".");
			delay(1);
		}
		else
		{
			QImage img = QImage((const unsigned char*)(testImages.at(i).data),
				testImages.at(i).cols, testImages.at(i).rows, 
				testImages.at(i).cols*testImages.at(i).channels(), QImage::Format_Indexed8);
			img2label->setPixmap(QPixmap::fromImage(img).scaled(ui.imgshow2->size()));
			img2label->resize(QSize(img.width(), img.height()));
			ui.imgshow2->setWidget(img2label);
			delay(10);
		}
	}
	acc = (200.0 - coutnum) / 200.0;
	QString PT5Str = QString("%1").arg(acc);
	switch (flag)
	{
	case nEigenFace:ui.textedit->append("EigenFace acc:  " + PT5Str + "."); delay(1); break;
	case nFisherFace:ui.textedit->append("FisherFace acc:  " + PT5Str + "."); delay(1); break;
	case nLBPHFace:ui.textedit->append("LBPHFace acc :   " + PT5Str + "."); delay(1); break;
	default:break;
	}
	return true;
}


void FaceRec::delay(unsigned int msec)
{
	QTime dieTime = QTime::currentTime().addMSecs(msec);
	while (QTime::currentTime() < dieTime)
	QCoreApplication::processEvents(QEventLoop::AllEvents, 100);
}


void FaceRec::QTexit()
{
	QApplication* app;
	app->exit(0);
}