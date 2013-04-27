//
//  ASContentViewController.h
//  AppSandboxFinder
//
//  Created by Jamin on 13-4-25.
//  Copyright (c) 2013年 Jaminz. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ASFile.h"

@interface ASContentViewController : UIViewController <UIWebViewDelegate>


@property (nonatomic, strong) UIWebView *   webView;
@property (nonatomic, strong) ASFile *      currentFile;


- (id)initWithFile:(ASFile *)file;

- (void)loadFile:(ASFile *)file;


- (void)loadFileAtPath:(NSString *)path;

@end
