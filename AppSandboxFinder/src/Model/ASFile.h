//
//  ASFile.h
//  AppSandboxFinder
//
//  Created by Jamin on 13-4-6.
//  Copyright (c) 2013年 Jaminz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASConstants.h"



@class ASDir;

@protocol ASFile <NSObject>

- (NSString *)name;
- (NSString *)path;
- (long long)size;
- (NSDate *)ctime;
- (NSDate *)mtime;
- (ASDir *)fatherDir;

@end

@interface ASFile : NSObject <ASFile>
{
    NSString *      _name;
    NSString *      _path;
    NSDate *        _ctime;
    NSDate *        _mtime;
    long long       _size;
    
    
    ASDir *         _fatherDir;
}


@property (nonatomic, strong) NSString *    name;
@property (nonatomic, strong) NSString *    path;
@property (nonatomic, strong) NSDate *      ctime;
@property (nonatomic, strong) NSDate *      mtime;

@property (nonatomic, assign) long long     size;
@property (nonatomic, strong) ASDir *       fatherDir;

@end
