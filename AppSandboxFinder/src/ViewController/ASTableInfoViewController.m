//
//  ASTableInfoViewController.m
//  AppSandboxFinder
//
//  Created by Jamin on 7/28/13.
//  Copyright (c) 2013 Jaminz. All rights reserved.
//

#import "ASTableInfoViewController.h"
#import "ASConstants.h"

@interface ASTableInfoViewController ()

@property(nonatomic, strong) ASSqliteHandle *           dbHandle;
@property(nonatomic, strong) NSString *                 tableName;

@property(nonatomic, strong) UISearchBar *              searchBar;
//@property(nonatomic, strong) 

@end

@implementation ASTableInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (id)initWithDBHandle:(ASSqliteHandle *)dbHandle withTableName:(NSString *)tableName
{
    self = [self initWithNibName:nil bundle:nil];
    if (nil != self) {
        _dbHandle = ASReturnRetained(dbHandle);
        _tableName = ASReturnRetained(tableName);
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#if ! __has_feature(objc_arc)
- (void)dealloc {
    ASRelease(_tableName);
    ASRelease(_dbHandle);
    [super dealloc];
}
#endif


@end
