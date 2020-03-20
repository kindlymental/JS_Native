//
//  UIWebView_JSCore_Controller.m
//  JS_Native
//
//  Created by 刘怡兰 on 2020/3/20.
//  Copyright © 2020 lyl. All rights reserved.
//

#import "UIWebView_JSCore_Controller.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface UIWebView_JSCore_Controller () <UIWebViewDelegate>

@property (nonatomic,strong) UIWebView *webView;

@end

@implementation UIWebView_JSCore_Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    self.webView.delegate = self;
//    NSURL *url = [NSURL URLWithString: WebViewURL];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"js_native" ofType:@"html"];
    NSURL* url = [NSURL fileURLWithPath:path];
    
    if ([WebViewURL hasPrefix:@"http"]) {
        url = [NSURL URLWithString: WebViewURL];
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 如果不想要webView 的回弹效果
    self.webView.scrollView.bounces = NO;
    // UIWebView 滚动的比较慢，这里设置为正常速度
    self.webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    /* OC调用JS */
    // 第一种方式：evaluateScript
    [context evaluateScript:@"OCToJS('evaluateScript')"];
    // 第二种方式：callWithArguments
    [context[@"OCToJS"] callWithArguments:@[@"callWithArguments"]];
    
    /* JS调用OC */
    context[@"JavaScriptCoreJSToOC"] = ^() {
        NSArray *args = [JSContext currentArguments];
        for (id obj in args) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self modal:[obj toString]];
            });
        }
    };
}

- (void)modal: (NSString *)msg {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"提示" delegate:nil cancelButtonTitle:msg destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    [actionSheet showInView:self.view];
}

@end
