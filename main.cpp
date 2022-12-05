
#include <QtWidgets/QApplication>
#include <QtWidgets/QWidget>
#include <QtCore/QString>
#include <QtGui/QWindow>
#include "MyProjectWidget.h"

int main(int argc, char **argv)
{
    QApplication app(argc, argv);
    MyProjectWidget w(nullptr);
    w.show();

    return app.exec();
}
