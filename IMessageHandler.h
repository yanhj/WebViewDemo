//********************************************************
/// @brief 
/// @author y974183789@gmail.com
/// @date 2022/12/5
/// @note
/// @version 1.0.0
//********************************************************

#pragma once

#include <QtCore/QString>
#include <QtCore/QDebug>
#include <mutex>

class IMessageHandler {
public:
    explicit IMessageHandler();
    virtual ~IMessageHandler();

    virtual void doHandle(const QString& json) = 0;
};

class MessageHandlerService {
public:
    ~MessageHandlerService();

    static MessageHandlerService* instance();

    void addListener(IMessageHandler* l);
    void removeListener(IMessageHandler* l);

    void doHandle(const QString& json);

private:
    MessageHandlerService();

private:
    std::list<IMessageHandler*> m_listener;
    std::mutex m_mtLock;
};