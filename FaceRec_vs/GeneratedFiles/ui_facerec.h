/********************************************************************************
** Form generated from reading UI file 'facerec.ui'
**
** Created by: Qt User Interface Compiler version 5.5.1
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_FACEREC_H
#define UI_FACEREC_H

#include <QtCore/QVariant>
#include <QtWidgets/QAction>
#include <QtWidgets/QApplication>
#include <QtWidgets/QButtonGroup>
#include <QtWidgets/QHeaderView>
#include <QtWidgets/QLabel>
#include <QtWidgets/QMainWindow>
#include <QtWidgets/QMenu>
#include <QtWidgets/QMenuBar>
#include <QtWidgets/QPushButton>
#include <QtWidgets/QScrollArea>
#include <QtWidgets/QStatusBar>
#include <QtWidgets/QTextBrowser>
#include <QtWidgets/QTextEdit>
#include <QtWidgets/QToolBar>
#include <QtWidgets/QWidget>

QT_BEGIN_NAMESPACE

class Ui_FaceRecClass
{
public:
    QAction *actionL;
    QWidget *centralWidget;
    QPushButton *EigenFace;
    QTextEdit *textedit;
    QPushButton *FisherFace;
    QPushButton *LBPHFace;
    QPushButton *HogSvmFace;
    QTextBrowser *textBrowser;
    QPushButton *trian;
    QTextBrowser *textBrowser_2;
    QPushButton *QTexit;
    QScrollArea *imgshow1;
    QWidget *scrollAreaWidgetContents;
    QScrollArea *imgshow2;
    QWidget *scrollAreaWidgetContents_2;
    QLabel *img1label;
    QLabel *img2label;
    QMenuBar *menuBar;
    QMenu *menu;
    QToolBar *mainToolBar;
    QStatusBar *statusBar;

    void setupUi(QMainWindow *FaceRecClass)
    {
        if (FaceRecClass->objectName().isEmpty())
            FaceRecClass->setObjectName(QStringLiteral("FaceRecClass"));
        FaceRecClass->resize(601, 766);
        QFont font;
        font.setFamily(QStringLiteral("Times New Roman"));
        font.setPointSize(12);
        FaceRecClass->setFont(font);
        actionL = new QAction(FaceRecClass);
        actionL->setObjectName(QStringLiteral("actionL"));
        centralWidget = new QWidget(FaceRecClass);
        centralWidget->setObjectName(QStringLiteral("centralWidget"));
        centralWidget->setEnabled(true);
        EigenFace = new QPushButton(centralWidget);
        EigenFace->setObjectName(QStringLiteral("EigenFace"));
        EigenFace->setGeometry(QRect(10, 480, 141, 41));
        textedit = new QTextEdit(centralWidget);
        textedit->setObjectName(QStringLiteral("textedit"));
        textedit->setGeometry(QRect(160, 460, 431, 241));
        textedit->setFont(font);
        textedit->setAutoFillBackground(false);
        textedit->setStyleSheet(QStringLiteral("color: rgb(76, 76, 76);"));
        textedit->setFrameShape(QFrame::WinPanel);
        textedit->setFrameShadow(QFrame::Sunken);
        textedit->setUndoRedoEnabled(false);
        FisherFace = new QPushButton(centralWidget);
        FisherFace->setObjectName(QStringLiteral("FisherFace"));
        FisherFace->setGeometry(QRect(10, 520, 141, 41));
        LBPHFace = new QPushButton(centralWidget);
        LBPHFace->setObjectName(QStringLiteral("LBPHFace"));
        LBPHFace->setGeometry(QRect(10, 560, 141, 41));
        HogSvmFace = new QPushButton(centralWidget);
        HogSvmFace->setObjectName(QStringLiteral("HogSvmFace"));
        HogSvmFace->setGeometry(QRect(10, 600, 141, 41));
        HogSvmFace->setFont(font);
        textBrowser = new QTextBrowser(centralWidget);
        textBrowser->setObjectName(QStringLiteral("textBrowser"));
        textBrowser->setGeometry(QRect(0, 10, 401, 371));
        textBrowser->setFrameShape(QFrame::WinPanel);
        trian = new QPushButton(centralWidget);
        trian->setObjectName(QStringLiteral("trian"));
        trian->setGeometry(QRect(10, 430, 141, 41));
        textBrowser_2 = new QTextBrowser(centralWidget);
        textBrowser_2->setObjectName(QStringLiteral("textBrowser_2"));
        textBrowser_2->setGeometry(QRect(160, 420, 431, 41));
        textBrowser_2->setFrameShape(QFrame::WinPanel);
        QTexit = new QPushButton(centralWidget);
        QTexit->setObjectName(QStringLiteral("QTexit"));
        QTexit->setGeometry(QRect(10, 650, 141, 41));
        imgshow1 = new QScrollArea(centralWidget);
        imgshow1->setObjectName(QStringLiteral("imgshow1"));
        imgshow1->setGeometry(QRect(400, 30, 171, 181));
        imgshow1->setWidgetResizable(true);
        scrollAreaWidgetContents = new QWidget();
        scrollAreaWidgetContents->setObjectName(QStringLiteral("scrollAreaWidgetContents"));
        scrollAreaWidgetContents->setGeometry(QRect(0, 0, 169, 179));
        imgshow1->setWidget(scrollAreaWidgetContents);
        imgshow2 = new QScrollArea(centralWidget);
        imgshow2->setObjectName(QStringLiteral("imgshow2"));
        imgshow2->setGeometry(QRect(400, 230, 171, 191));
        imgshow2->setWidgetResizable(true);
        scrollAreaWidgetContents_2 = new QWidget();
        scrollAreaWidgetContents_2->setObjectName(QStringLiteral("scrollAreaWidgetContents_2"));
        scrollAreaWidgetContents_2->setGeometry(QRect(0, 0, 169, 189));
        imgshow2->setWidget(scrollAreaWidgetContents_2);
        img1label = new QLabel(centralWidget);
        img1label->setObjectName(QStringLiteral("img1label"));
        img1label->setGeometry(QRect(450, 10, 71, 21));
        QFont font1;
        font1.setFamily(QStringLiteral("Times New Roman"));
        font1.setPointSize(12);
        font1.setBold(true);
        font1.setWeight(75);
        img1label->setFont(font1);
        img1label->setTextFormat(Qt::PlainText);
        img1label->setScaledContents(false);
        img2label = new QLabel(centralWidget);
        img2label->setObjectName(QStringLiteral("img2label"));
        img2label->setGeometry(QRect(450, 210, 71, 16));
        QFont font2;
        font2.setBold(true);
        font2.setWeight(75);
        img2label->setFont(font2);
        img2label->setTextFormat(Qt::PlainText);
        FaceRecClass->setCentralWidget(centralWidget);
        menuBar = new QMenuBar(FaceRecClass);
        menuBar->setObjectName(QStringLiteral("menuBar"));
        menuBar->setGeometry(QRect(0, 0, 601, 23));
        menu = new QMenu(menuBar);
        menu->setObjectName(QStringLiteral("menu"));
        FaceRecClass->setMenuBar(menuBar);
        mainToolBar = new QToolBar(FaceRecClass);
        mainToolBar->setObjectName(QStringLiteral("mainToolBar"));
        FaceRecClass->addToolBar(Qt::TopToolBarArea, mainToolBar);
        statusBar = new QStatusBar(FaceRecClass);
        statusBar->setObjectName(QStringLiteral("statusBar"));
        FaceRecClass->setStatusBar(statusBar);

        menuBar->addAction(menu->menuAction());
        menu->addAction(actionL);

        retranslateUi(FaceRecClass);

        QMetaObject::connectSlotsByName(FaceRecClass);
    } // setupUi

    void retranslateUi(QMainWindow *FaceRecClass)
    {
        FaceRecClass->setWindowTitle(QApplication::translate("FaceRecClass", "FaceRec", 0));
        actionL->setText(QApplication::translate("FaceRecClass", "l", 0));
        EigenFace->setText(QApplication::translate("FaceRecClass", "EigenFace", 0));
        textedit->setHtml(QApplication::translate("FaceRecClass", "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0//EN\" \"http://www.w3.org/TR/REC-html40/strict.dtd\">\n"
"<html><head><meta name=\"qrichtext\" content=\"1\" /><style type=\"text/css\">\n"
"p, li { white-space: pre-wrap; }\n"
"</style></head><body style=\" font-family:'Times New Roman'; font-size:12pt; font-weight:400; font-style:normal;\">\n"
"<p style=\"-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><br /></p></body></html>", 0));
        FisherFace->setText(QApplication::translate("FaceRecClass", "FisherFace", 0));
        LBPHFace->setText(QApplication::translate("FaceRecClass", "LBPHFace", 0));
        HogSvmFace->setText(QApplication::translate("FaceRecClass", "HogSvmFace", 0));
        textBrowser->setHtml(QApplication::translate("FaceRecClass", "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0//EN\" \"http://www.w3.org/TR/REC-html40/strict.dtd\">\n"
"<html><head><meta name=\"qrichtext\" content=\"1\" /><style type=\"text/css\">\n"
"p, li { white-space: pre-wrap; }\n"
"</style></head><body style=\" font-family:'Times New Roman'; font-size:12pt; font-weight:400; font-style:normal;\">\n"
"<p align=\"center\" style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-weight:600;\">\344\272\272\350\204\270\350\257\206\345\210\253\347\263\273\347\273\237</span></p>\n"
"<p align=\"center\" style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-weight:600;\">==================</span></p>\n"
"<p align=\"center\" style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">1\343\200\201EigenFace</p>\n"
"<p align=\"center\" style=\" margin-top:0px; ma"
                        "rgin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">2\343\200\201FisherFace</p>\n"
"<p align=\"center\" style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">3\343\200\201LBPHFace</p>\n"
"<p align=\"center\" style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">4\343\200\201HogSvm</p>\n"
"<p align=\"center\" style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">\350\256\255\347\273\203\346\240\267\346\234\254\357\274\232200\345\274\240\357\274\214\346\257\217\344\272\2725\345\274\240\343\200\202\351\200\232\350\277\207trian_200.txt\347\264\242\345\274\225</p>\n"
"<p align=\"center\" style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">\346\265\213\350\257\225\346\240\267\346\234\254\357\274\232200\345\274\240\357\274\214"
                        "\346\257\217\344\272\2725\345\274\240\343\200\202\351\200\232\350\277\207test_200.txt\347\264\242\345\274\225</p>\n"
"<p align=\"center\" style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">-----------------------------------------------------------</p>\n"
"<p align=\"center\" style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">readme\357\274\232</p>\n"
"<p align=\"center\" style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">\357\274\2100\357\274\211\346\234\254\347\225\214\351\235\242\344\270\255\350\256\255\347\273\203\344\270\272\345\220\214\346\227\266\344\270\200\350\265\267\350\256\255\347\273\203\347\204\266\345\220\216\344\277\235\345\255\230\346\250\241\345\236\213\357\274\214</p>\n"
"<p align=\"center\" style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-"
                        "indent:0px;\">\346\265\213\350\257\225\344\270\272\345\210\206\345\274\200\345\212\240\350\275\275\346\265\213\350\257\225\344\276\277\344\272\216\350\247\202\345\257\237\347\273\223\346\236\234\346\225\260\346\215\256\343\200\202</p>\n"
"<p align=\"center\" style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">\357\274\2101\357\274\211\346\265\213\350\257\225\350\277\207\347\250\213\344\270\255\346\234\211\344\270\200\345\256\232\347\232\204\345\273\266\346\227\266\344\273\245\344\276\277\344\272\216\350\247\202\346\265\213\347\250\213\345\272\217\350\277\220\350\241\214</p>\n"
"<p align=\"center\" style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">\346\227\266\345\233\276\347\211\207\345\256\236\346\227\266\345\210\206\347\261\273\347\232\204\346\203\205\345\206\265\357\274\214\345\205\266\344\270\255\351\224\231\345\210\206\347\261\273\346\227\266\345\273\266</p>\n"
"<p align=\""
                        "center\" style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">\346\227\266\346\227\266\351\227\264\350\276\203\351\225\277\344\270\2722s\343\200\202</p>\n"
"<p align=\"center\" style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">=======================================</p></body></html>", 0));
        trian->setText(QApplication::translate("FaceRecClass", "Trian", 0));
        textBrowser_2->setHtml(QApplication::translate("FaceRecClass", "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0//EN\" \"http://www.w3.org/TR/REC-html40/strict.dtd\">\n"
"<html><head><meta name=\"qrichtext\" content=\"1\" /><style type=\"text/css\">\n"
"p, li { white-space: pre-wrap; }\n"
"</style></head><body style=\" font-family:'Times New Roman'; font-size:12pt; font-weight:400; font-style:normal;\">\n"
"<p align=\"center\" style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-weight:600;\">Running Message\357\274\201</span></p></body></html>", 0));
        QTexit->setText(QApplication::translate("FaceRecClass", "QTexit", 0));
        img1label->setText(QApplication::translate("FaceRecClass", "\346\265\213\350\257\225\345\233\276\347\211\207", 0));
        img2label->setText(QApplication::translate("FaceRecClass", "\345\210\206\347\261\273\345\233\276\347\211\207", 0));
        menu->setTitle(QApplication::translate("FaceRecClass", "\344\272\272\350\204\270\350\257\206\345\210\253\347\263\273\347\273\237", 0));
    } // retranslateUi

};

namespace Ui {
    class FaceRecClass: public Ui_FaceRecClass {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_FACEREC_H
