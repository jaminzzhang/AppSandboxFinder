//
//  ASDBTableRowDataViewController.h
//  AppSandboxFinder
//
//  Created by Jamin on 9/1/13.
//  Copyright (c) 2013 Jaminz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASDBTableRowDataViewController : UITableViewController

@property (nonatomic, strong) NSDictionary *        rowDataDict;
@property (nonatomic, strong) NSArray *             columnList;

/*
 * 使用数据库的表中某一行初始化
 *  @param dataDic 行数据
 *  @param cloumnNames 数据列ASDBColumn列表
 *  @return 
 */
- (id)initWithRowData:(NSDictionary *)dataDict withColumnList:(NSArray *)columnList;

@end
