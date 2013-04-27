//
//  ASDir.m
//  AppSandboxFinder
//
//  Created by Jamin on 13-4-6.
//  Copyright (c) 2013年 Jaminz. All rights reserved.
//

#import "ASDir.h"

@implementation ASDir


- (id)init
{
    self = [super init];
    if (self) {
        _childrenCount = 0;
    }
    
    return self;
}



- (id)initWithPath:(NSString *)path
{
    self = [self init];
    if (self) {
        _path = ASReturnCopyed(path);
        _name = ASReturnCopyed([path lastPathComponent]);
    }
    
    return self;
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"%@<%p> name:%@ \n path:%@ \n childrenCount:%d", NSStringFromClass([self class]), self, self.name, self.path, self.childrenCount];
}


#if ! __has_feature(objc_arc)
- (void)dealloc {
    ASRelease(_name);
    ASRelease(_path);
    ASRelease(_fatherDir);
    [super dealloc];
}
#endif


@end
