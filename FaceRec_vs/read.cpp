#include"read.h"

template<typename _Tp>
cv::Mat convertVector2Mat(vector<_Tp> v, int channels, int rows)
{
	cv::Mat mat = cv::Mat(v);//��vector��ɵ��е�mat
	cv::Mat dest = mat.reshape(channels, rows).clone();//PS������clone()һ�ݣ����򷵻س���
	return dest;
}

bool IPSG::CfaceRec::read_csv(const string& filename, vector<Mat>& images,
	vector<int>& labels, char separator = ',') 
{
	// ��inģʽ����ȡ�ļ�ģʽ�����ļ� ,ʵ���ǽ�filename�ļ������� ��file
	std::ifstream file(filename.c_str(), ifstream::in);
	if (!file) 
	{
		string error_message = "No valid input file was given, please check the given filename.";
		CV_Error(Error::StsBadArg, error_message);
	}
	string line, path, classlabel;
	//��ȡfile�ļ��е�һ���ַ����� line
	while (getline(file, line)) 
	{
		//��line�����ַ�����ȡ��lines(��)��
		//����->lines��������ȡ�ַ�ʱ��ָ���������������line��string���̶��ģ������еĶ�ȡÿ�ζ��Ǵ�lineͷ��ʼ
		stringstream liness(line);
		//��ȡ�ļ��е�·���ͱ�ǩ
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
	//��ⴰ��(64,128),��ߴ�(16,16),�鲽��(8,8),cell�ߴ�(8,8),ֱ��ͼbin����9
	HOGDescriptor hog(Size(64, 128), Size(16, 16), Size(8, 8), Size(8, 8), 9);
	//read_csv(trainCsvFile, trainImages, trainLabels, ',');
	vector<float> descriptors;//HOG����������
	descriptors.reserve(4000);
	for (int num = 0; num < 200; num++)
	{
		Mat src = trainImages.at(num);//��ȡͼƬ

		cv::resize(src, src, cv::Size(64, 128));
		hog.compute(src, descriptors, cv::Size(16, 16));//����HOG�����ӣ���ⴰ���ƶ�����
		//�����һ������ʱ��ʼ�����������������������Ϊֻ��֪��������������ά�����ܳ�ʼ��������������
		if (0 == num)
		{
			DescriptorDim = descriptors.size();
			//��ʼ������ѵ������������������ɵľ��������������������ĸ�������������HOG������ά��sampleFeatureMat
			sampleFeatureMat = Mat::zeros(200, DescriptorDim, CV_32FC1);
			//��ʼ��ѵ����������������������������������ĸ�������������1��1��ʾ���ˣ�0��ʾ����
			sampleLabelMat = Mat::zeros(200, 1, CV_32SC1);//sampleLabelMat���������ͱ���Ϊ�з���������
		}
		sampleLabelMat.at<int>(num, 0) = num / 5 + 1;//������ǩ��ÿ���һ�顣
		//������õ�HOG�����Ӹ��Ƶ�������������sampleFeatureMat
		for (int i = 0; i < DescriptorDim; i++)
		{
			sampleFeatureMat.at<float>(num, i) = descriptors.at(i);//��num�����������������еĵ�i��Ԫ��
		}
	}//�ӵڶ���ͼƬ��ʼ�������ڴ�ָ����󣡣�

	//���������HOG�������������ļ�
	HogSvmModel->setType(SVM::C_SVC);
	HogSvmModel->setC(0.01);
	HogSvmModel->setKernel(SVM::LINEAR);
	HogSvmModel->setTermCriteria(TermCriteria(TermCriteria::MAX_ITER, 3000, 1e-6));
		
	HogSvmModel->train(sampleFeatureMat, ROW_SAMPLE, sampleLabelMat);//ѵ��������
	HogSvmModel->SVM::save("HogSvmModel.xml");
	cout << "train_200.create HogSvmModel finish!" << endl;
	return true;
}

bool IPSG::CfaceRec::createHogSvmTest()
{
	coutnum = 0;
	HOGDescriptor hog(Size(64, 128), Size(16, 16), Size(8, 8), Size(8, 8), 9);
	//read_csv(trainCsvFile, trainImages, trainLabels, ',');
	vector<float> descriptors;//HOG����������
	descriptors.reserve(4000);
	Ptr<SVM> svm = SVM::create();
	HogSvmModel = SVM::load("HogSvmModel.xml");
	cout<< endl << "HogSvmFace ������ࣺ" << endl;
	for (int i = 0; i < 200; i++)
	{
		Mat test = testImages.at(i);//��ȡͼƬ
		cv::resize(test, test, cv::Size(64, 128));
		hog.compute(test, descriptors, Size(16, 16));//����HOG�����ӣ���ⴰ���ƶ�����(8,8)

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
	
	EigenFaceModel->train(trainImages, trainLabels); //ѵ��  
	EigenFaceModel->save("EigenFaceModel.xml"); //��ѵ��ģ�ͱ���
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
	case EigenFace:cout << endl<<  "EigenFace ������ࣺ"  << endl; break;
	case FisherFace:cout << endl<< "FisherFace ������ࣺ"  << endl; break;
	case LBPHFace:cout << endl<< "LBPHFace ������ࣺ "  << endl; break;
	default:break;
	}	
	// predictedLabel��Ԥ���ǩ���
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