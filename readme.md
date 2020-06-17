##  readme

两年前的模式识别课程设计代码.


### 1. FaceRec_vs

-  运行配置：	Win7+vs2013（x64-Debug）+opencv330（带Cmake编译的opencv-contrib部分）+QT5.5.1

- 程序执行： \FaceRec_vs\FaceRec\FaceRec.sln –> F5.程序样本采用ORL数据集，分别通过索引文件train_200.txt、test2_200.txt索引。需要注意的是，程序运行时，需要将样本以同样的命名方式放到同样的路径下面，程序才能索引到样本。程序包含算法加界面设计，详情见FaceRec_vs.avi演示视频。

###  2. FaceRec_matlab

- 运行配置：Win7+Matlab2016b

- 程序执行：	\FacRec_matlab\运行faceRecognition.m文件，注意需要将当前文件夹添加到matlab的运行路径，否则无法调用其他***.m文件函数。样本采用ORL数据集。程序包含算法设计加界面设计，详情见FaceRec_matlab.avi演示视频。

###  3. FaceRec_py运行说明

-  运行配置：windows7 + Anaconda3-4.2.0-Windows-x86_64 + Python3.5.2 + pycharm2018社区版 + opencv-python + opencv-contrib-python + cuda8.0 + cudnn5.1 + TensorFlow1.0.0-GPU
- 显卡：GeForce GTX 750 Ti (2G运行内存)
- 程序执行：	\FaceRec_py\运行detection.py文件，同样，运行时需要将文件路径设置为pycharm的执行路径，否则无法调用其他.py文件。人脸检测+识别代码，检测部分使用Dlib，识别部分使用卷积神经网络。文件夹my_faces里为自己头像采集所得数据集包含10000张图片，采集过程耗时三个多小时。Other_faces为[大众人脸数据集LFW](http://vis-www.cs.umass.edu/lfw/)包含13000张左右图片。


###  4.Github 上传日志

```
remote: warning: GH001: Large files detected. You may want to try Git Large File Storage - https://git-lfs.github.com.
remote: warning: See http://git.io/iEPt8g for more information.
remote: warning: File FaceRec_vs/EigenFaceModel.xml is 55.42 MB; this is larger than GitHub's recommended maximum file size of 50.00 MB
remote: warning: File FaceRec_vs/HogSvmModel.xml is 63.56 MB; this is larger than GitHub's recommended maximum file size of 50.00 MB
To github.com:Quitino/PatternRecognition-FaceRecog.git
 * [new branch]      master -> master
Branch 'master' set up to track remote branch 'master' from 'origin'.
```

又出了个`Git LFS`保存大文件？上传失败的两个文件，随处可下载就不折腾了。