//
//  ASFileUtils.h
//  AppSandboxFinder
//
//  Created by Jamin on 13-4-6.
//  Copyright (c) 2013年 Jaminz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASFile.h"
#import "ASDir.h"

@interface ASFileUtils : NSObject

+ (UIImage *)getFileIconOfName:(NSString *)fileName;
+ (UIImage *)getFileIcon:(id<ASFile>)file;

+ (BOOL)checkFileExists:(NSString *)path;
+ (BOOL)isDirAtPath:(NSString *)path;

+ (NSArray *)localFilesAtPath:(NSString *)path;
+ (NSArray *)localFilesInDir:(ASDir *)dir;


+ (BOOL)deleteFileAtPath:(NSString *)path;


+ (NSString *)formatFileSize:(long long)byteSize;

@end
