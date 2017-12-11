//
//  OWPDFViewController.m
//  OWHTMLtoPDF
//
//  Created by Owen Chen on 2017/11/9.
//  Copyright © 2017年 conpak. All rights reserved.
//

#import "OWPDFViewController.h"

@interface OWPDFViewController ()

@property (nonatomic, strong) NSString *pdfPath;
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation OWPDFViewController

- (instancetype)initWithPDFPath:(NSString *)pdfPath
{
    self = [super init];
    if (self) {
        _pdfPath = pdfPath;
        NSLog(@"1212:%@",_pdfPath);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setWebView];
}

- (void)setWebView
{
    NSURL *path = [NSURL fileURLWithPath:_pdfPath];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:path];
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 60.0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 60.0)];
    _webView.scalesPageToFit = YES;
    [self.view addSubview:_webView];
    [_webView loadRequest:urlRequest];
}

#pragma mark - button click
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
