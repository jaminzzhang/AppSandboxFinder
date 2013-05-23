//
//  ASFile.m
//  AppSandboxFinder
//
//  Created by Jamin on 13-4-6.
//  Copyright (c) 2013年 Jaminz. All rights reserved.
//

#import "ASFile.h"
#import "ASDir.h"

@implementation ASFile

- (id)init
{
    self = [super init];
    if (self) {
        _size = 0ll;
    }
    
    return self;
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"%@<%p> name:%@ \n fatherDir:%@\n path:%@ \n size:%lld", NSStringFromClass([self class]), self, self.name, self.fatherDir, self.path, self.size];
}


#if ! __has_feature(objc_arc)
- (void)dealloc {
    ASRelease(_name);
    ASRelease(_path);
    ASRelease(_fatherDir);
    ASRelease(_ctime);
    ASRelease(_mtime);
    [super dealloc];
}
#endif


@end
