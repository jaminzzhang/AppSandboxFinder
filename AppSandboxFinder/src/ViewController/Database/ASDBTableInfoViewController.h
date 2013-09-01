//
//  ASDBTableInfoViewController.h
//  AppSandboxFinder
//
//  Created by Jamin on 7/28/13.
//  Copyright (c) 2013 Jaminz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASDBTable.h"

@interface ASDBTableInfoViewController : UITableViewController


@property (nonatomic, strong) ASDBTable *     dbTable;


/*
 * init with ASDBTable, Show the info of ASDBTable
 *  @param table the table
 *  @return 
 */
- (id)initWithDBTable:(ASDBTable *)table;


@end
