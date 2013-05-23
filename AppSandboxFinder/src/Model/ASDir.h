//
//  ASDir.h
//  AppSandboxFinder
//
//  Created by Jamin on 13-4-6.
//  Copyright (c) 2013年 Jaminz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASFile.h"

@interface ASDir : ASFile <ASFile>
{
    NSInteger       _childrenCount;
}

@property (nonatomic, assign) NSInteger     childrenCount;

- (id)initWithPath:(NSString *)path;




@end
