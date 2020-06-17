#include"read.h"

template<typename _Tp>
cv::Mat convertVector2Mat(vector<_Tp> v, int channels, int rows)
{
	cv::Mat mat = cv::Mat(v);//将vector变成单列的mat
	cv::Mat dest = mat.reshape(channels, rows).clone();//PS：必须clone()一份，否则返回出错
	return dest;
}

bool IPSG::CfaceRec::read_csv(const string& filename, vector<Mat>& images,
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

bool IPSG::CfaceRec::createHogSvm()
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
	cout << "train_200.create HogSvmModel finish!" << endl;
	return true;
}

bool IPSG::CfaceRec::createHogSvmTest()
{
	coutnum = 0;
	HOGDescriptor hog(Size(64, 128), Size(16, 16), Size(8, 8), Size(8, 8), 9);
	//read_csv(trainCsvFile, trainImages, trainLabels, ',');
	vector<float> descriptors;//HOG描述子向量
	descriptors.reserve(4000);
	Ptr<SVM> svm = SVM::create();
	HogSvmModel = SVM::load("HogSvmModel.xml");
	cout<< endl << "HogSvmFace 错误分类：" << endl;
	for (int i = 0; i < 200; i++)
	{
		Mat test = testImages.at(i);//读取图片
		cv::resize(test, test, cv::Size(64, 128));
		hog.compute(test, descriptors, Size(16, 16));//计算HOG描述子，检测窗口移动步长(8,8)

		int predictedLabel = HogSvmModel->predict(descriptors);
		string result_message = format("Predicted class = %d / Actual class = %d.", predictedLabel, testLabels.at(i));
		if (predictedLabel != testLabels.at(i))
		{
			coutnum++;
			cout << result_message << endl;
		}
	}
	acc = (200.0 - coutnum) / 200.0;
	cout << "HogSvmFace acc:  " << acc << endl;
	return true;
}

bool IPSG::CfaceRec::train()
{
	read_csv(trainCsvFile, trainImages, trainLabels, ','); 
	
	if (trainImages.size() <= 1)
	{
		string errMsg = "THis demo needs at least 2 trainImages to work.please add trainImages!";
		CV_Error(CV_StsError, errMsg);
	}
	cout << "train_200 load success!" << endl;
	
	EigenFaceModel->train(trainImages, trainLabels); //训练  
	EigenFaceModel->save("EigenFaceModel.xml"); //将训练模型保存
	cout << "train_200.create EigenFaceModel finish!" << endl;	
	
	FisherFaceModel->train(trainImages, trainLabels);
	FisherFaceModel->save("FisherFaceModel.xml");
	cout << "train_200.create FisherFaceModel finish!" << endl;
	
	LBPHFaceModel->train(trainImages, trainLabels);
	LBPHFaceModel->save("LBPHFaceModel.xml");
	cout << "train_200.create LBPHFaceModel finish!" << endl;

	
	return true;
}

bool IPSG::CfaceRec::test(const  Ptr<face::FaceRecognizer> model,const int flag)
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
	
	cout << "test_200 load success!" << endl;
	switch (flag)
	{
	case EigenFace:cout << endl<<  "EigenFace 错误分类："  << endl; break;
	case FisherFace:cout << endl<< "FisherFace 错误分类："  << endl; break;
	case LBPHFace:cout << endl<< "LBPHFace 错误分类： "  << endl; break;
	default:break;
	}	
	// predictedLabel是预测标签结果
	for (int i = 0; i < 200; i++)
	{
		predictedLabel = model->predict(testImages.at(i));
		result_message = format("Predicted class = %d / Actual class = %d.", predictedLabel, testLabels.at(i));
		if (predictedLabel != testLabels.at(i))
		{
			coutnum++;
			cout << result_message << endl;
		}
	}
	acc = (200.0 - coutnum) / 200.0;
	switch (flag)
	{
	case EigenFace:cout << "EigenFace acc:  " << acc << endl; break;
	case FisherFace:cout << "FisherFace acc:  " << acc << endl; break;
	case LBPHFace:cout << "LBPHFace acc :   " << acc << endl; break;
	default:break;
	}
	return true;
}

bool IPSG::CfaceRec::run()
{
	train();
	createHogSvm();
	test(EigenFaceModel, EigenFace);
	test(FisherFaceModel, FisherFace);
	test(LBPHFaceModel, LBPHFace);
	createHogSvmTest();
	return true;
}