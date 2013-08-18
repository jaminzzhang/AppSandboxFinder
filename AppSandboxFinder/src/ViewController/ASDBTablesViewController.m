//
//  ASDBTablesViewController.m
//  AppSandboxFinder
//
//  Created by Jamin on 7/28/13.
//  Copyright (c) 2013 Jaminz. All rights reserved.
//

#import "ASDBTablesViewController.h"
#import "ASTableDataViewController.h"

#import "ASSqliteHandle.h"
#import "ASConstants.h"

@interface ASDBTablesViewController ()

@property (nonatomic, strong) ASSqliteHandle *  dbHandle;
@property (nonatomic, strong) NSArray *         dbTables;


@end

@implementation ASDBTablesViewController


#pragma mark - Action
- (void)backAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UIViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}


- (id)initWithDbPath:(NSString *)path
{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        _dbPath = ASReturnRetained(path);
        _dbHandle = [[ASSqliteHandle alloc] initWithDbPath:path];
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"返回", @"返回")
                                                                      style:UIBarButtonItemStyleBordered
                                                                     target:self
                                                                     action:@selector(backAction:)];
    self.navigationItem.leftBarButtonItem = backBarButton;
    ASRelease(backBarButton);


    self.title = [self.dbPath lastPathComponent];
    self.dbTables = [self.dbHandle getDbTableInfos];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#if ! __has_feature(objc_arc)
- (void)dealloc {
    ASRelease(_dbPath);
    ASRelease(_dbHandle);
    ASRelease(_dbTables);
    [super dealloc];
}
#endif

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dbTables.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ASDBTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (nil == cell) {
        UITableViewCell *aCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell = ASReturnAutoreleased(aCell);
        cell.textLabel.font = [UIFont systemFontOfSize:17.0f];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    cell.textLabel.text = [self.dbTables objectAtIndex:indexPath.row];
    
    // Configure the cell...

    return cell;
}


#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * tableName = self.dbTables[indexPath.row];
    ASTableDataViewController * viewController = [[ASTableDataViewController alloc] initWithDBHandle:self.dbHandle
                                                                                       withTableName:tableName];
    [self.navigationController pushViewController:viewController animated:YES];
    ASRelease(viewController);
    
}


@end
