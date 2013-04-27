//
//  ASFileManager.h
//  AppSandboxFinder
//
//  Created by Jamin on 13-4-6.
//  Copyright (c) 2013年 Jaminz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASFile.h"
#import "ASDir.h"

@interface ASFileManager : NSObject

+ (BOOL)checkFileExists:(NSString *)path;
+ (NSMutableArray *)localFilesAtPath:(NSString *)path;


+ (UIImage *)getFileIconOfName:(NSString *)fileName;


+ (UIImage *)getFileIcon:(id<ASFile>)file;


@end
