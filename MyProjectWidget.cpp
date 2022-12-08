//********************************************************
/// @brief 
/// @author y974183789@gmail.com
/// @date 2022/12/2
/// @note
/// @version 1.0.0
//********************************************************

#include "MyProjectWidget.h"
#include "ui_MyProjectWidget.h"
#include <QtCore/QSysInfo>
#include <QtCore/qglobal.h>
#include <QtCore/QJsonDocument>
#include <QtCore/QJsonObject>
#include <QtGui/QWindow>
#include <QtNetwork/QHostInfo>
#include "CustomOCWebView.h"
#include <QtWidgets/QMessageBox>

MyProjectWidget::MyProjectWidget(QWidget *parent)
: QDialog(parent)
, IMessageHandler()
, ui(new Ui::MyProjectWidget) {
    ui->setupUi(this);
    auto appDir = qApp->applicationDirPath();
    CustomOCWebView * webView = [[CustomOCWebView alloc] init];
    if(nil != webView) {
        [webView setUrl: appDir.append("/index.html").toNSString()];
        [webView setMessageHandler: MessageHandlerService::instance()];
        [webView loadUrl];
        QWidget* widget  = QWidget::createWindowContainer(QWindow::fromWinId(WId(webView->pWebView)));
        if(nullptr != widget){
            ui->vLayMain->addWidget(widget);
        }
    }
    connect(ui->btnToJs, &QPushButton::clicked, this, [=] {
        [webView sendMessage: QString("recvMessageFromObjectiveC").toNSString() msg:QString("msg from Qt/Oc").toNSString()];
    });
}

MyProjectWidget::~MyProjectWidget() {
    delete ui;
}

void MyProjectWidget::doHandle(const QString& json) {
    Q_UNUSED(json);
    qDebug() << "MyProjectWidget" << json;
    QJsonDocument jsonDoc =  QJsonDocument::fromJson(json.toUtf8());
    if(jsonDoc.isObject()){
        QJsonObject jsObj = jsonDoc.object();
        if(!jsObj.isEmpty()){
            if(0 == jsObj.value("category").toString().compare("myProject", Qt::CaseInsensitive)) {
                auto type = jsObj.value("type").toString();
                if(0 == type.compare("tip", Qt::CaseInsensitive)) {
                    QMessageBox::information(this, "tip", jsObj.value("body").toString());
                }
            }
        }
    }

}
