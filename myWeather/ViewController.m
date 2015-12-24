//
//  ViewController.m
//  myWeather
//
//  Created by peters on 15/12/23.
//  Copyright © 2015年 peters. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworkReachabilityManager.h"

@interface ViewController ()<UIWebViewDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forwardButton;
@property (weak, nonatomic) UIWebView *webView;
@property (nonatomic, weak) UIActivityIndicatorView *loadingView;
@property (nonatomic,strong) UIAlertView *alert;
- (IBAction)back;

- (IBAction)forward;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //监听网络
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {

        //弹窗提示网络
        if (status == 0) {
            _alert = [[UIAlertView alloc] initWithTitle:@"一个错误" message:@"请确认有网络" delegate:self cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
            [_alert show];
        }
        
    }];
    
    
    UIWebView *webView = [[UIWebView alloc] init];
    webView.frame = self.view.frame;
    webView.delegate = self;
    webView.scrollView.hidden = YES; //webview 加载完再显示
    webView.scalesPageToFit = YES;
    [self.view addSubview:webView];
    self.webView = webView;
    
    [self getData];
    
    //菊花
    UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [loadingView startAnimating];
    loadingView.center = CGPointMake(KscreenWight/2, KscreenHeight/2);
    [self.view addSubview:loadingView];
    self.loadingView = loadingView;
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getData{
    NSURL *url = [NSURL URLWithString:WEATHERURL];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [_webView loadRequest:request];
    
}


- (IBAction)back{
    [self.webView goBack];
}

- (IBAction)forward{
    [self.webView goForward];
    
}

#pragma webView - delegate
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    if ([self.webView canGoBack]) {
        self.backButton.enabled = YES;
    }
    if ([self.webView canGoForward]) {
        self.forwardButton.enabled = YES;
    }
    

    self.webView.scrollView.hidden = NO;
    [self.loadingView removeFromSuperview];
    
    
    
    
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
   

    
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSMutableString *js = [NSMutableString string];
    //webView去除广告和多余选项
    [js appendString:@"$('.footer').remove();"];
    [js appendString:@"$('.apostertop').remove();"];
    [js appendString:@"$('.nav').remove();"];
    [js appendString:@"$('.pre').remove();"];
    [js appendString:@"$('.life').remove();"];
    [js appendString:@"$('.ad').remove();"];
    [js appendString:@"$('.zs').remove();"];
    [js appendString:@"$('.news').remove();"];
    [js appendString:@"$('.logo').remove();"];
    [js appendString:@"$('.yj').remove();"];
    
    [self.webView stringByEvaluatingJavaScriptFromString:js];
    
    return YES;
}











@end
