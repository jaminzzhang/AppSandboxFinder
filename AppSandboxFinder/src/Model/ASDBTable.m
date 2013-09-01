//
//  ASDBTable.m
//  AppSandboxFinder
//
//  Created by Jamin on 9/1/13.
//  Copyright (c) 2013 Jaminz. All rights reserved.
//

#import "ASDBTable.h"

@implementation ASDBTable

- (NSString *)description
{
    return [NSString stringWithFormat:@"<ASDBColumn> %p, name:%@ tbl_name:%@ rootpage:%d sql:%@",
            self, _name, _tbl_name, _rootpage, _sql];
}


#if ! __has_feature(objc_arc)
- (void)dealloc {
    ASRelease(_name);
    ASRelease(_tbl_name);
    ASRelease(_sql);
    [super dealloc];
}
#endif


@end
