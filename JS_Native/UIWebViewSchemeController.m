//
//  UIWebViewSchemeController.m
//  JS_Native
//
//  Created by 刘怡兰 on 2020/3/20.
//  Copyright © 2020 lyl. All rights reserved.
//

#import "UIWebViewSchemeController.h"

@interface UIWebViewSchemeController () <UIWebViewDelegate>

@property (nonatomic,strong) UIWebView *webView;

@end

@implementation UIWebViewSchemeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"js_native" ofType:@"html"];
    NSURL* url = [NSURL fileURLWithPath:path];
    
    if ([WebViewURL hasPrefix:@"http"]) {
        url = [NSURL URLWithString: WebViewURL];
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *requestString = [[[request URL] absoluteString]stringByRemovingPercentEncoding];
    // 拦截url
    if ([requestString hasSuffix:@"js_native://jsToOC"]) {
        // oc调用js方法
        [webView stringByEvaluatingJavaScriptFromString:@"OCToJS('OC拦截到了我')"];
        return NO;
    }
    return YES;
}

@end
