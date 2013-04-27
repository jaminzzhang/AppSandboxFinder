//
//  ASDir.h
//  AppSandboxFinder
//
//  Created by Jamin on 13-4-6.
//  Copyright (c) 2013年 Jaminz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASFile.h"

@interface ASDir : NSObject <ASFile>
{
    NSString *      _name;
    NSString *      _path;
    ASDir *         _fatherDir;
    NSInteger       _childrenCount;
}

@property (nonatomic, strong) NSString *    name;
@property (nonatomic, strong) NSString *    path;
@property (nonatomic, strong) ASDir *       fatherDir;
@property (nonatomic, assign) NSInteger     childrenCount;

- (id)initWithPath:(NSString *)path;




@end
