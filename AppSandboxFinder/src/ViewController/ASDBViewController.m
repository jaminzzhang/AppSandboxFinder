//
//  ASDBViewController.m
//  AppSandboxFinder
//
//  Created by Jamin on 7/27/13.
//  Copyright (c) 2013 Jaminz. All rights reserved.
//

#import "ASDBViewController.h"
#import "ASConstants.h"
#import "ASSqliteHandle.h"

@interface ASDBViewController ()

@property (nonatomic, strong) ASSqliteHandle * dbHandle;

@end

@implementation ASDBViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (id)initWithDbPath:(NSString *)path
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _dbPath = ASReturnRetained(path);
        _dbHandle = [[ASSqliteHandle alloc] initWithDbPath:path];
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIWebView * webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    webView.scalesPageToFit = YES;
    self.dbWebView = webView;
    [self.view addSubview:webView];
    ASRelease(webView);

    NSArray * tables = [self.dbHandle getDbTableInfos];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#if ! __has_feature(objc_arc)
- (void)dealloc {
    ASRelease(_dbWebView);
    [super dealloc];
}
#endif





@end
