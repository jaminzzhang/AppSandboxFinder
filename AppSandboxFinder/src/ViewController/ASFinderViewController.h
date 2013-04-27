//
//  ASFinderViewController.h
//  AppSandboxFinder
//
//  Created by Jamin on 13-4-6.
//  Copyright (c) 2013年 Jaminz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASDir.h"

@interface ASFinderViewController : UITableViewController
{
    ASDir *                 _currentDir;
//    NSString *              _currentPath;
    NSMutableArray *        _localFileList;
//    UITableView *           _fileTableView;
}


@property (nonatomic, strong) ASDir *               currentDir;
@property (nonatomic, readonly) NSString *          currentPath;
@property (nonatomic, strong) NSMutableArray *      localFileList;
//@property (nonatomic, strong) UITableView *         fileTableview;

- (id)initWithDir:(ASDir *)dir;
- (id)initWithPath:(NSString *)path;


@end
