#include "facerec.h"
#include <QtWidgets/QApplication>

int main(int argc, char *argv[])
{
	QApplication a(argc, argv);
	FaceRec w;
	w.show();
	return a.exec();
}
