//
//  ASDBTable.h
//  AppSandboxFinder
//
//  Created by Jamin on 9/1/13.
//  Copyright (c) 2013 Jaminz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASDBTable : NSObject

@property (nonatomic, strong) NSString *    name;
@property (nonatomic, strong) NSString *    tbl_name;
@property (nonatomic, assign) NSInteger     rootpage;
@property (nonatomic, strong) NSString *    sql;


@end
