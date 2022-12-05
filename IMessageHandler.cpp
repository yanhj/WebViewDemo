//********************************************************
/// @brief 
/// @author y974183789@gmail.com
/// @date 2022/12/5
/// @note
/// @version 1.0.0
//********************************************************

#include "IMessageHandler.h"

IMessageHandler::IMessageHandler() {
    MessageHandlerService::instance()->addListener(this);
}

IMessageHandler::~IMessageHandler() {
    MessageHandlerService::instance()->removeListener(this);
}

MessageHandlerService::MessageHandlerService(){

}

MessageHandlerService::~MessageHandlerService() {

}

MessageHandlerService* MessageHandlerService::instance() {
    static MessageHandlerService sInstance;
    return &sInstance;
}

void MessageHandlerService::addListener(IMessageHandler* l) {
    std::lock_guard<std::mutex> lockGuard(m_mtLock);
    m_listener.push_back(l);
}

void MessageHandlerService::removeListener(IMessageHandler* l) {
    std::lock_guard<std::mutex> lockGuard(m_mtLock);
    auto itr = std::find(m_listener.begin(), m_listener.end(), l);
    if(itr != m_listener.end()) {
        m_listener.erase(itr);
    }
}

void MessageHandlerService::doHandle(const QString& json) {
    std::list<IMessageHandler*> listener;
    {
        std::lock_guard<std::mutex> lockGuard(m_mtLock);
        listener = m_listener;
    }
    for(auto l : listener) {
        l->doHandle(json);
    }
}