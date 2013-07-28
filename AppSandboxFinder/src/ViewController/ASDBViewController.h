//
//  ASDBViewController.h
//  AppSandboxFinder
//
//  Created by Jamin on 7/27/13.
//  Copyright (c) 2013 Jaminz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASDBViewController : UIViewController

@property (nonatomic, strong) NSString * dbPath;
@property (nonatomic, strong) UIWebView * dbWebView;


- (id)initWithDbPath:(NSString *)path;

@end
