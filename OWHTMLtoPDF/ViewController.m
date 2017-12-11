//
//  ViewController.m
//  OWHTMLtoPDF
//
//  Created by Owen Chen on 2017/11/9.
//  Copyright © 2017年 conpak. All rights reserved.
//

#import "ViewController.h"
#import "NDHTMLtoPDF.h"
#import "OWHTMLFileManager.h"
#import "OWPDFViewController.h"
#import "FFToast.h"

@interface ViewController ()<NDHTMLtoPDFDelegate>

@property (nonatomic, strong) NDHTMLtoPDF *PDFCreator;
@property (nonatomic, strong) NSString *HTMLPath;
@property(nonatomic,strong)FFToast *toast;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


#pragma mark - buttons click

- (IBAction)delegateCreatePDF:(id)sender {
    NSString *htmlPath;
    if (self.HTMLPath) {
        htmlPath = self.HTMLPath;
    }else{
//        htmlPath = [[NSBundle mainBundle] pathForResource:@"propertyHTML" ofType:@"html"];
        htmlPath = [[NSBundle mainBundle] pathForResource:@"propertyTaxModel" ofType:@"html"];
//        htmlPath = [[NSBundle mainBundle] pathForResource:@"personalAssessmentModel" ofType:@"html"];
        htmlPath = [[NSBundle mainBundle] pathForResource:@"salariesTaxModel" ofType:@"html"];
    }
    self.PDFCreator = [NDHTMLtoPDF createPDFWithURL:[NSURL fileURLWithPath:htmlPath]
                                         pathForPDF:[@"~/Documents/delegateDemo.pdf" stringByExpandingTildeInPath]
                                           delegate:self
                                           pageSize:kPaperSizeA4
                                            margins:UIEdgeInsetsMake(10, 15, 10, 15)];
}

- (IBAction)blockCreatePDF:(id)sender {
    NSString *htmlPath;
    if (self.HTMLPath) {
        htmlPath = self.HTMLPath;
    }else{
        htmlPath = [[NSBundle mainBundle] pathForResource:@"propertyTaxModel" ofType:@"html"];
    }
    self.PDFCreator = [NDHTMLtoPDF createPDFWithURL:[NSURL fileURLWithPath:htmlPath] pathForPDF:[@"~/Documents/blocksDemo.pdf" stringByExpandingTildeInPath] pageSize:kPaperSizeA4 margins:UIEdgeInsetsMake(10, 5, 10, 5) successBlock:^(NDHTMLtoPDF *htmlToPDF) {
        NSString *result = @"HTMLtoPDF did succeed";
        NSLog(@"%@",result);
        OWPDFViewController *vc = [[OWPDFViewController alloc] initWithPDFPath:htmlToPDF.PDFpath];
        [self presentViewController:vc animated:YES completion:nil];
    } errorBlock:^(NDHTMLtoPDF *htmlToPDF) {
        NSString *result = [NSString stringWithFormat:@"HTMLtoPDF did fail (%@)", htmlToPDF];
        NSLog(@"%@",result);
    }];
}

- (IBAction)createNewHTMLByHTMLModel:(id)sender {
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"propertyTaxModel" ofType:@"html"];
//    NSDictionary *dic = @{@"8":@{@"BigTitle":@"PROPERTY TAX COMPUTATION"},
//                          @"9":@{@"SmallTitle":@"2016/17(Final)"},
//                          @"11":@{@"Assessable_value":@"13,145"},
//                          @"12":@{@"AllowanceAndOutgoings_Value":@"22,111"},
//                          @"13":@{@"Net_Assessable":@"81,000"},
//                          @"14":@{@"Tax_Payable_Value":@"88,888"},
//                          };
    NSDictionary *dic = @{@"28":@{@"value":@"390,000"},
                          @"32":@{@"value":@"78,000"},
                          @"36":@{@"value":@"312,000"},
                          @"40":@{@"value":@"46,800"},
                          };
    NSString *htmlStr = [OWHTMLFileManager fillHTMLFile:htmlPath withDeleteStrings:nil filledStringsDic:dic];
    [self createHtmlFileWithHtmlString:htmlStr];
}

-(NSString *)dirDoc{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

//创建html文件
-(void)createHtmlFileWithHtmlString:(NSString *)htmlStr{
    
    NSString *documentsPath =[self dirDoc];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *testPath = [documentsPath stringByAppendingPathComponent:@"newHTML.html"];
    
    BOOL res=[fileManager createFileAtPath:testPath contents:nil attributes:nil];
    
    if (res) {
        NSLog(@"文件创建成功: %@" ,testPath);
    }else{
        NSLog(@"文件创建失败");
    }
    
    BOOL suc = [htmlStr writeToFile:testPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    if (suc) {
        NSLog(@"html文件写入成功!");
        self.HTMLPath = testPath;
    }else{
        NSLog(@"html文件写入失败!");
    }
    
}

#pragma mark NDHTMLtoPDFDelegate

- (void)HTMLtoPDFDidSucceed:(NDHTMLtoPDF*)htmlToPDF
{
    NSString *result = @"HTMLtoPDF did succeed (%@ / %@)";
    NSLog(@"%@",result);
    OWPDFViewController *vc = [[OWPDFViewController alloc] initWithPDFPath:htmlToPDF.PDFpath];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)HTMLtoPDFDidFail:(NDHTMLtoPDF*)htmlToPDF
{
    NSString *result = [NSString stringWithFormat:@"HTMLtoPDF did fail (%@)", htmlToPDF];
    NSLog(@"%@",result);
}

@end
