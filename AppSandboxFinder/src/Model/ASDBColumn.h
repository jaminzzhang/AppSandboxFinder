//
//  ASDBColumn.h
//  AppSandboxFinder
//
//  Created by Jamin on 8/18/13.
//  Copyright (c) 2013 Jaminz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASDBColumn : NSObject

@property (nonatomic, assign) NSUInteger    cid;
@property (nonatomic, strong) NSString *    name;
@property (nonatomic, assign) BOOL          isNotNull;
@property (nonatomic, assign) BOOL          isPK;
@property (nonatomic, strong) NSString *    type;

@end
