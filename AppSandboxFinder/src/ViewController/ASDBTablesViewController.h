//
//  ASDBTablesViewController.h
//  AppSandboxFinder
//
//  Created by Jamin on 7/28/13.
//  Copyright (c) 2013 Jaminz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASDBTablesViewController : UITableViewController


@property (nonatomic, strong) NSString * dbPath;



- (id)initWithDbPath:(NSString *)path;



@end
