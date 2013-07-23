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

@property (nonatomic, strong) NSString *    name;
@property (nonatomic, strong) NSString *    path;
@property (nonatomic, strong) NSDate *      ctime;
@property (nonatomic, strong) NSDate *      mtime;

@property (nonatomic, assign) long long     size;
@property (nonatomic, strong) ASDir *       fatherDir;


- (id)initWithPath:(NSString *)path;

@end

@interface ASFile : NSObject <ASFile>
{
    NSString *      _name;
    NSString *      _path;
    NSString *      _typeIdentifier;
    NSDate *        _ctime;
    NSDate *        _mtime;
    long long       _size;
    
    ASDir *         _fatherDir;
}

@property (nonatomic, strong) NSString *    name;
@property (nonatomic, strong) NSString *    path;
@property (nonatomic, strong) NSString *    typeIdentifier;
@property (nonatomic, strong) NSDate *      ctime;
@property (nonatomic, strong) NSDate *      mtime;


@property (nonatomic, assign) long long     size;
@property (nonatomic, strong) ASDir *       fatherDir;


@end
