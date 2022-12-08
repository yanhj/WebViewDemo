
#include <QtWidgets/QApplication>
#include <QtWidgets/QWidget>
#include <QtCore/QString>
#include <QtGui/QWindow>
#include "MyProjectWidget.h"
#include "mainwindow.h"
int main(int argc, char **argv)
{
    QApplication app(argc, argv);
    MainWindow w(nullptr);
    w.show();

    return app.exec();
}
