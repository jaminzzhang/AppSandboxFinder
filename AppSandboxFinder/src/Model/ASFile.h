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
- (ASDir *)fatherDir;

@end

@interface ASFile : NSObject <ASFile>
{
    NSString *      _name;
    NSString *      _path;
    long long       _size;
    ASDir *         _fatherDir;
}


@property (nonatomic, strong) NSString *    name;
@property (nonatomic, strong) NSString *    path;
@property (nonatomic, assign) long long     size;
@property (nonatomic, strong) ASDir *       fatherDir;

@end
