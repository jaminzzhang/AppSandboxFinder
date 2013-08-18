//
//  ASDBColumn.m
//  AppSandboxFinder
//
//  Created by Jamin on 8/18/13.
//  Copyright (c) 2013 Jaminz. All rights reserved.
//

#import "ASDBColumn.h"
#import "ASConstants.h"

@implementation ASDBColumn


#if ! __has_feature(objc_arc)
- (void)dealloc {
    ASRelease(_name);
    ASRelease(_type);
    [super dealloc];
}
#endif

@end
