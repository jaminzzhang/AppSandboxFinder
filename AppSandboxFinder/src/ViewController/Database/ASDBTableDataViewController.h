//
//  ASDBTableDataViewController.h
//  AppSandboxFinder
//  Zh-Hans 使用列表的方式展示数据表的数据
//  En Show data of table in database
//  Created by Jamin on 8/18/13.
//  Copyright (c) 2013 Jaminz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASSqliteHandle.h"


@interface ASDBTableDataViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>


@property (nonatomic, strong) UIPickerView *    columnPickerView;
@property (nonatomic, strong) UITableView *     dataTableView;


- (id)initWithDBHandle:(ASSqliteHandle *)dbHandle withDBTable:(ASDBTable *)table;


@end
