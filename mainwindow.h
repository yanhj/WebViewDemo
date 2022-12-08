//********************************************************
/// @brief 
/// @author yanhuajian
/// @date 2022/12/8
/// @note
/// @version 1.0.0
//********************************************************

#pragma once

#include <QWidget>


QT_BEGIN_NAMESPACE
namespace Ui { class MainWindow; }
QT_END_NAMESPACE

class MainWindow : public QWidget {
Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = nullptr);

    ~MainWindow() override;

private:
    Ui::MainWindow *ui;
};
