//********************************************************
/// @brief 
/// @author y974183789@gmail.com
/// @date 2022/12/2
/// @note
/// @version 1.0.0
//********************************************************

#pragma once

#include <QtWidgets/QDialog>
#include "CustomOCWebView.h"
#include "IMessageHandler.h"

QT_BEGIN_NAMESPACE
namespace Ui { class MyProjectWidget; }
QT_END_NAMESPACE

class MyProjectWidget : public QDialog, public IMessageHandler {
    Q_OBJECT

public:
    explicit MyProjectWidget(QWidget *parent = nullptr);
    ~MyProjectWidget() override;

    void doHandle(const QString& json) override;

private:
    Ui::MyProjectWidget *ui;
};
