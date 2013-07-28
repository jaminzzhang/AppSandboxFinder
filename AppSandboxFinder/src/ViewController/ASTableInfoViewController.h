//
//  ASTableInfoViewController.h
//  AppSandboxFinder
//
//  Created by Jamin on 7/28/13.
//  Copyright (c) 2013 Jaminz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASSqliteHandle.h"

@interface ASTableInfoViewController : UIViewController

- (id)initWithDBHandle:(ASSqliteHandle *)dbHandle withTableName:(NSString *)tableName;

@end
