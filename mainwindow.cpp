//********************************************************
/// @brief 
/// @author yanhuajian
/// @date 2022/12/8
/// @note
/// @version 1.0.0
//********************************************************

#include "mainwindow.h"
#include "ui_MainWindow.h"
#include "MyProjectWidget.h"
#include "MyWebView.h"
#include <QtWidgets/QVBoxLayout>
#include <QtGui/QWindow>

MainWindow::MainWindow(QWidget *parent)
        : QWidget(parent), ui(new Ui::MainWindow) {
    ui->setupUi(this);
    connect(ui->btnEmpty, &QPushButton::clicked, this, [this](){
        MyWebView * webView = [[MyWebView alloc] init];
        if(nil != webView) {
            QWidget* widget  = QWidget::createWindowContainer(QWindow::fromWinId(WId(webView->pWebView)));
            if(nullptr != widget){
                QDialog dlg(this);
                dlg.setFixedSize(500, 500);
                QVBoxLayout * vLay = new QVBoxLayout(&dlg);
                vLay->addWidget(widget);
                dlg.exec();
            }
        }
    });
    connect(ui->btnCommunication, &QPushButton::clicked, this, [this](){
        MyProjectWidget(nullptr).exec();
    });
}

MainWindow::~MainWindow() {
    delete ui;
}
