//
//  ASContentViewController.m
//  AppSandboxFinder
//
//  Created by Jamin on 13-4-25.
//  Copyright (c) 2013年 Jaminz. All rights reserved.
//

#import "ASContentViewController.h"

@interface ASContentViewController ()

@end

@implementation ASContentViewController


#pragma mark - UIViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (id)initWithFile:(ASFile *)file
{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        self.currentFile = file;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.currentFile.name;
    self.webView = ASReturnAutoreleased([[UIWebView alloc] initWithFrame:self.view.bounds]);
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.webView.backgroundColor = [UIColor colorWithRed:(240.0f/255.0f) green:(240.0f/255.0f) blue:(240.0f/255.0f) alpha:1];
    self.webView.scalesPageToFit = YES;
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    [self loadFile:self.currentFile];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#if ! __has_feature(objc_arc)
- (void)dealloc {
    ASRelease(_webView);
    ASRelease(_currentFile);
    [super dealloc];
}
#endif


#pragma mark - Public
- (void)loadFile:(ASFile *)file
{
    [self loadFileAtPath:file.path];
}


- (void)loadFileAtPath:(NSString *)path
{
    NSURL *fileURL = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:fileURL];
    [self.webView loadRequest:request];
}



#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
//    NSLog(@"webViewDidStartLoad");
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//    NSLog(@"webViewDidFinishLoad");
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
//    NSLog(@"didFailLoadWithError:(%@)", error);
}



@end
