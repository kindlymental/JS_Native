//
//  WebViewController.m
//  JS_Native
//
//  Created by 刘怡兰 on 2020/3/20.
//  Copyright © 2020 lyl. All rights reserved.
//

#import "WKWebViewController.h"
#import <WebKit/WebKit.h>

@interface WKWebViewController () <WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler>

@property (nonatomic,strong) WKWebView *webView;

@end

@implementation WKWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.view addSubview:self.webView];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"js_native" ofType:@"html"];
    NSURL* url = [NSURL fileURLWithPath:path];
    
    if ([WebViewURL hasPrefix:@"http"]) {
        url = [NSURL URLWithString: WebViewURL];
    }
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (WKWebView *)webView {
    if (!_webView) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        configuration.userContentController = [[WKUserContentController alloc]init];
        [configuration.userContentController addScriptMessageHandler:self name:@"jsCallOC_WKScriptMessageHandle"];
        
        WKPreferences *preferences = [WKPreferences new];
        preferences.javaScriptCanOpenWindowsAutomatically = YES;
        preferences.minimumFontSize = 40.0;
        configuration.preferences = preferences;
        
        _webView = [[WKWebView alloc]initWithFrame:self.view.frame configuration:configuration];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
    }
    return _webView;
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    // 方法名
    NSString *methods = [NSString stringWithFormat:@"%@:", message.name];
    SEL selector = NSSelectorFromString(methods);
    // 调用方法
    if ([self respondsToSelector:selector]) {
        [self performSelector:selector withObject:message.body];
    }
}

- (void)jsCallOC_WKScriptMessageHandle:(NSDictionary *)param {
    NSLog(@"执行jsCallOC %@ %@", param[@"name"],param[@"id"]);
    
    [self modal:param[@"name"]];
}


#pragma 代理
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self.webView evaluateJavaScript:@"OCToJS('OC发送了方法')"
                completionHandler:^(id _Nullable ret, NSError * _Nullable error) {
        [self modal:ret];
    }];
}

- (void)modal: (NSString *)msg {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"提示" delegate:nil cancelButtonTitle:msg destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    [actionSheet showInView:self.view];
}

@end
