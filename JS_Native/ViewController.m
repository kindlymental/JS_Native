//
//  ViewController.m
//  JS_Native
//
//  Created by 刘怡兰 on 2020/3/19.
//  Copyright © 2020 lyl. All rights reserved.
//

#import "ViewController.h"
#import "WKWebViewController.h"
#import "UIWebView_JSCore_Controller.h"
#import "UIWebViewSchemeController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (IBAction)scheme:(id)sender {
    UIWebViewSchemeController *webView = [[UIWebViewSchemeController alloc]init];
    [self presentViewController:webView animated:true completion:^{

    }];
}
- (IBAction)javaScriptCore:(id)sender {
    UIWebView_JSCore_Controller *webView = [[UIWebView_JSCore_Controller alloc]init];
    [self presentViewController:webView animated:true completion:^{

    }];
}

- (IBAction)wkScriptMessageHandle:(id)sender {
    WKWebViewController *webView = [[WKWebViewController alloc]init];
    [self presentViewController:webView animated:true completion:^{

    }];
}


@end
