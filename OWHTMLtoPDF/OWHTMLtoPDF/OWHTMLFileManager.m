//
//  OWHTMLFileManager.m
//  HTMLtoPDF-Demo
//
//  Created by Owen Chen on 2017/11/9.
//  Copyright © 2017年 Nurves. All rights reserved.
//

#import "OWHTMLFileManager.h"

@implementation OWHTMLFileManager

/*
 filledStrsDic的格式如下：
 NSDictionary *dic = @{@"8":@{@"BigTitle":@"PROPERTY TAX COMPUTATION"},
                       @"9":@{@"SmallTitle":@"2016/17(Final)"},
                       @"11":@{@"Assessable_value":@"13,145"},
                       @"12":@{@"AllowanceAndOutgoings_Value":@"22,111"},
                       @"13":@{@"Net_Assessable":@"81,000"},
                       @"14":@{@"Tax_Payable_Value":@"88,888"},
                       };
 解释：如第一个元素，@"8"表示需要改变的行数，html源码第8行（从0开始）；@"BigTitle"表示需要替换的字段；@"PROPERTY TAX COMPUTATION"表示替换后的字段。
 */
+ (NSString *)fillHTMLFile:(NSString *)htmlFilePath withDeleteStrings:(NSArray *)deleteStrStrsArr filledStringsDic:(NSDictionary *)filledStrsDic
{
    NSString *htmlstring=[[NSString alloc] initWithContentsOfFile:htmlFilePath encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"html:%@",htmlstring);
    NSMutableArray *centencesArr = [NSMutableArray array];
    [htmlstring enumerateSubstringsInRange:NSMakeRange(0, htmlstring.length) options:NSStringEnumerationBySentences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        [centencesArr addObject:substring];
    }];
    if (filledStrsDic) {
        NSArray *keysArr = [filledStrsDic allKeys];
        for (NSString *keyStr in keysArr) {
            NSDictionary *valueDic = filledStrsDic[keyStr];
            NSInteger needChangeIndex = [keyStr integerValue] + 1;//+1是因为通过enumerateSubstringsInRange方法得到的数组，会把<!DOCTYPE html>分成两行
            NSMutableString *mutStr = [(NSMutableString *)centencesArr[needChangeIndex] mutableCopy];
            
            NSArray *subKeysArr = [valueDic allKeys];
            for (NSString *subKeyStr in subKeysArr) {
                NSRange range = [mutStr rangeOfString:subKeyStr];
                if (range.location != NSNotFound) {
                    [mutStr replaceCharactersInRange:range withString:valueDic[subKeyStr]];
                    [centencesArr replaceObjectAtIndex:needChangeIndex withObject:(NSString *)mutStr];
                }
            }
        }
    }
    
    if (deleteStrStrsArr) {
        for (NSString *deleteStr in deleteStrStrsArr) {
            NSInteger deleteIndex = [deleteStr integerValue] + 1;//+1是因为通过enumerateSubstringsInRange方法得到的数组，会把<!DOCTYPE html>分成两行
            [centencesArr removeObjectAtIndex:deleteIndex];
        }
    }
    
    NSString *finalStr = [centencesArr componentsJoinedByString:@""];
    NSLog(@"string haha :%@",finalStr);
    return finalStr;
}

@end
