//
//  OWHTMLFileManager.h
//  HTMLtoPDF-Demo
//
//  Created by Owen Chen on 2017/11/9.
//  Copyright © 2017年 Nurves. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OWHTMLFileManager : NSObject

/**
 根据html模板来替换改变的词或句子

 @param htmlFilePath html文件模板
 @param deleteStrsArr 需要删除的行（数组元素为需要删除的行）
 @param filledStrsDic 需要改变的词或句子（字典,key是行数的index，value是一个字典（key是需要改变的字段，value是改变后的字段））
 @return 更改完成后的html文件（NSString类型）
 */
+ (NSString *)fillHTMLFile:(NSString *)htmlFilePath withDeleteStrings:(NSArray *)deleteStrsArr filledStringsDic:(NSDictionary *)filledStrsDic;

@end
