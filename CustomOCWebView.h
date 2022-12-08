//********************************************************
/// @brief OC和JavaScript交互的协议类
/// @author y974183789@gmail.com
/// @date 2022/12/2
/// @note
/// @version 1.0.0
//********************************************************

#pragma once

#import <WebKit/WebKit.h>
#import <Foundation/Foundation.h>
#include <WebKit/WKWebView.h>

class MessageHandlerService;

@interface CustomOCWebView : NSObject<WKUIDelegate, WKScriptMessageHandler> {
@public
    WKWebView *pWebView;
}

-(void)loadUrl;
-(void) setUrl: (NSString*)strUrl;
-(void) setMessageHandler: (MessageHandlerService*) messageHandler;
-(void) sendMessage: (NSString*) apiName msg:(NSString*) message;
@end

