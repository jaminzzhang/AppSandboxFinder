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

- (NSString *)description
{
    return [NSString stringWithFormat:@"<ASDBColumn> %p, cid:%d name:%@ isNotNull:%d isPK:%d type:%@",
            self, _cid, _name, _isNotNull, _isPK, _type];
}


#if ! __has_feature(objc_arc)
- (void)dealloc {
    ASRelease(_name);
    ASRelease(_type);
    [super dealloc];
}
#endif

@end
