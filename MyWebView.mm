#import "MyWebView.h"

@interface MyWebView () {
}
@end

@implementation MyWebView

-(id) init{
    if (self=[super init])
    {
        self->pWebView = [[WKWebView alloc] init];
        [self->pWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]]];
    }
    return self;
}


-(void)dealloc {
    [self->pWebView dealloc];
    [super dealloc];
}

@end