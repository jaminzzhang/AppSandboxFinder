//
//  ASFileDetailViewController.h
//  AppSandboxFinder
//
//  Created by Jamin on 13-5-23.
//  Copyright (c) 2013年 Jaminz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASFile.h"


@interface ASFileDetailViewController : UITableViewController

@property (nonatomic, strong) id<ASFile>    currentItem;

- (id)initWithFile:(id<ASFile>)file;

- (id)initWithPath:(NSString *)path;


@end
