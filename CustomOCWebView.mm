//********************************************************
/// @brief OC和JavaScript交互的协议类
/// @author y974183789@gmail.com
/// @date 2022/12/2
/// @note
/// @version 1.0.0
//********************************************************

#include "CustomOCWebView.h"
#include "IMessageHandler.h"

typedef NS_ENUM(NSInteger, NetworkErrorErrorCode){
    Unknown,
    NotConnect,
    BadNetwork,
    RequestFailed,
    ServerBadResponse,
    ServerDecodeFailed,
    ConnectLost,
    DownloadFailed,
    IllegalURL,
    SSLError
};

@interface NetworkErrorCodeAnalysis : NSObject

+(NetworkErrorErrorCode) GetNetworkErrorCode:(NSInteger) errorCode;
+(NSString*) GetErrorStr:(NetworkErrorErrorCode) errorCode;
@end

@implementation NetworkErrorCodeAnalysis

+ (NetworkErrorErrorCode) GetNetworkErrorCode:(NSInteger)errorCode{
    switch (errorCode) {
        case NSURLErrorUnknown:
            return Unknown;
        case NSURLErrorCannotConnectToHost:
        case NSURLErrorCannotFindHost:
        case NSURLErrorNotConnectedToInternet:
            return NotConnect;
        case NSURLErrorTimedOut:
        case NSURLErrorCannotLoadFromNetwork:
            return BadNetwork;
        case NSURLErrorCancelled:
            return RequestFailed;
        case NSURLErrorBadServerResponse:
        case NSURLErrorResourceUnavailable:
            return ServerBadResponse;
        case NSURLErrorCannotDecodeRawData:
        case NSURLErrorCannotDecodeContentData:
            return ServerDecodeFailed;
        case NSURLErrorNetworkConnectionLost:
            return ConnectLost;
        case NSURLErrorDownloadDecodingFailedMidStream:
        case NSURLErrorDownloadDecodingFailedToComplete:
            return DownloadFailed;
        case NSURLErrorBadURL:
        case NSURLErrorUnsupportedURL:
            return IllegalURL;
        case NSURLErrorSecureConnectionFailed:
        case NSURLErrorServerCertificateHasBadDate:
        case NSURLErrorServerCertificateUntrusted:
        case NSURLErrorServerCertificateHasUnknownRoot:
        case NSURLErrorServerCertificateNotYetValid:
        case NSURLErrorClientCertificateRejected:
        case NSURLErrorClientCertificateRequired:
            return SSLError;
        default:
            break;

    }
    return Unknown;
}

+ (NSString*) GetErrorStr:(NetworkErrorErrorCode) errorCode{
    NSString * strError = [[NSString alloc] init];
    switch (errorCode) {
        case Unknown:
            strError = @"未知错误";
            break;
        case NotConnect:
            strError = @"网络未连接，请检查网络";
            break;
        case BadNetwork:
            strError = @"当前网络不佳，请稍后重试";
            break;
        case RequestFailed:
            strError = @"请求失败，请重试";
            break;
        case ServerBadResponse:
            strError = @"服务器错误";
            break;
        case ServerDecodeFailed:
            strError = @"服务器返回异常";
            break;
        case ConnectLost:
            strError = @"失去连接，请重试";
            break;
        case DownloadFailed:
            strError = @"下载失败";
            break;
        case IllegalURL:
            strError = @"非法url";
            break;
        case SSLError:
            strError = @"SSL 错误";
            break;
        default:
            break;

    }
    return strError;
}
@end

typedef NS_ENUM(NSInteger, NavigationErrorType) {
    ContentLoadError,
    NavigationError,
    TerminateError,
};

typedef struct stNavigationError {
    NavigationErrorType type;
    NSErrorDomain domain;
    NSInteger code;
} STNavigationError;

typedef void(^MyProjectNavigationDelegateCallback)(STNavigationError);
@interface MyProjectNavigationDelegate : NSObject<WKNavigationDelegate> {
    WKWebView* pWebView;
    MyProjectNavigationDelegateCallback pCallback;
}

-(id)initWithWebView: (WKWebView*) webView;
-(void)setCallback: (MyProjectNavigationDelegateCallback) callback;
@property (nonatomic, assign, setter=setMessageHandler: )MessageHandlerService* messageHandler;

@end

@implementation MyProjectNavigationDelegate
-(id)initWithWebView: (WKWebView*) webView {
    if(nil == webView) {
        return nil;
    }
    self = [super init];
    if (self) {
        pWebView = webView;
        return self;
    }
    return nil;
}

-(void) setMessageHandler:(MessageHandlerService*)messageHandler {
   _messageHandler = messageHandler;
}

-(void)setCallback: (MyProjectNavigationDelegateCallback) callback {
    pCallback = callback;
}

-(void)webView:(WKWebView *)webview decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if(webview != self->pWebView) {
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    if(webView != self->pWebView) {
        return;
    }
    /// disable the right-click menu
    [webView evaluateJavaScript:@"window.addEventListener('contextmenu', (event) => event.preventDefault());" completionHandler:nil];
    /// finished callback
    if(nil != self.messageHandler) {
        //TODO
    }
}

-(void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    if(webView != self->pWebView) {
        return;
    }
    if(nil != pCallback) {
        STNavigationError stError;
        stError.type = NavigationError;
        stError.domain = error.domain;
        stError.code = error.code;
        pCallback(stError);
    }
    if(nil != self.messageHandler) {
        //TODO
    }
}

-(void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    if(webView != self->pWebView) {
        return;
    }
    if(nil != pCallback) {
        STNavigationError stError;
        stError.type = TerminateError;
        stError.domain = @"TODO";
        stError.code = 0;
        pCallback(stError);
    }
    if(nil != self.messageHandler) {
        //TODO
    }
}

-(void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    if(webView != self->pWebView) {
        return;
    }
    if(nil != pCallback) {
        STNavigationError stError;
        stError.type = NavigationErrorType::ContentLoadError;
        stError.domain = error.domain;
        stError.code = error.code;
        pCallback(stError);
    }
    if(nil != self.messageHandler) {
        //TODO
    }
}

@end

@interface CustomOCWebView() {
@private
    MyProjectNavigationDelegate* pNavigationDelegate;
}

@property (nonatomic, assign, readwrite) NSString* strUrl;
@property (nonatomic, assign, setter=setMessageHandler:) MessageHandlerService* messageHandler;
///- 对象方法
-(void) loadUrl;
-(void) setNavigationDelegateCallback: (MyProjectNavigationDelegateCallback) callback;
///+ 类方法
+(void) clearCookie;

@end

@implementation CustomOCWebView
-(id) init {
    self = [super init];
    if (self) {
        _strUrl = nil;
        _messageHandler = nil;
        pWebView = [[WKWebView alloc] init];
        pNavigationDelegate = [[MyProjectNavigationDelegate alloc] initWithWebView:pWebView];
        [pNavigationDelegate setCallback:^(STNavigationError st){

            switch (st.type) {
                case ContentLoadError: {
                    NetworkErrorErrorCode errorCode = [NetworkErrorCodeAnalysis GetNetworkErrorCode:st.code];
                    NSLog(@"ContentLoadError %@",[NetworkErrorCodeAnalysis GetErrorStr:errorCode]);
                }
                    break;
                case NavigationError:{
                    NetworkErrorErrorCode errorCode = [NetworkErrorCodeAnalysis GetNetworkErrorCode:st.code];
                    NSLog(@"NavigationError %@",[NetworkErrorCodeAnalysis GetErrorStr:errorCode]);
                }
                    break;
                case TerminateError:{

                }
                    break;
                default:
                    break;
            }
        }];

        pWebView.navigationDelegate = pNavigationDelegate;
        self->pWebView.configuration.preferences.javaScriptEnabled = true;
        self->pWebView.allowsBackForwardNavigationGestures = false;
        self->pWebView.allowsMagnification = false;
        NSString *oriUA = [self->pWebView valueForKey: [NSString stringWithCString:"userAgent"]];
        self->pWebView.customUserAgent = [ [NSString alloc] initWithFormat:@"%@ %@",oriUA, QString("123TODO").toNSString()];
        [oriUA release];
        [self->pWebView.configuration.userContentController addScriptMessageHandler:self name:@"customMessageHandler"];
        [self->pWebView evaluateJavaScript:@"document.documentElement.style.webkitUserSelect='none';"  completionHandler:nil];
        [self->pWebView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';" completionHandler:nil];

        return self;
    }
    return nil;
}

-(void) dealloc {
    if(@available(iOS 11.0, *)) {
        [self->pWebView.configuration.userContentController removeAllScriptMessageHandlers];
    } else {
        [self->pWebView.configuration.userContentController removeScriptMessageHandlerForName:@"myProjectInterface"];
    }
    [super dealloc];
}

-(NSString*) getUrl {
    return self.strUrl;
}

-(void) setUrl: (NSString*) strUrl {
    self.strUrl = strUrl;
}
-(void) setMessageHandler: (MessageHandlerService*) messageHandler {
    _messageHandler = messageHandler;
    if(nil != pNavigationDelegate) {
        [pNavigationDelegate setMessageHandler:self.messageHandler];
    }
}

-(void) sendMessage: (NSString*) message {
    if(nil != message) {
        NSLog(message);
        [self->pWebView evaluateJavaScript:message  completionHandler:nil];
    }
}

-(void) setNavigationDelegateCallback: (MyProjectNavigationDelegateCallback) callback {
    if(nil != pNavigationDelegate) {
        [pNavigationDelegate setCallback:callback];
    }
}

+(void)clearCookie {
    NSArray* cookieArray = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for(NSHTTPCookie* cookie in cookieArray) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
}

-(void) loadUrl {
    if(nil == pWebView) {
        return;
    }
    if(nil == self.strUrl) {
        return;
    }
    //TODO 加载url
    //NSURL* url = [NSURL URLWithString:self.strUrl];
    //TODO 加载本地URL
    NSURL* url = [NSURL fileURLWithPath:self.strUrl];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [pWebView loadRequest:request];
}

//遵循WKScriptMessageHandler协议，必须实现如下方法，然后把方法向外传递
//通过接收JS传出消息的name进行捕捉的回调方法
-(void) userContentController:(WKUserContentController*) userContentController didReceiveScriptMessage:(WKScriptMessage*) message {
    if(nil == pWebView) {
        return;
    }
    if(nil == message) {
        return;
    }
    if(nil == message.body) {
        return;
    }
    if ( [[message name] compare:@"log"] == NSOrderedSame){
        NSLog(@"console.log(%@)",message.body);
    }
    if([[message name] compare:@"customMessageHandler"] == NSOrderedSame) {
        if(nil != self.messageHandler) {
            //处理消息
            QString json(QString::fromNSString(message.body));
            self.messageHandler->doHandle(json);
        }
    }
}
@end
