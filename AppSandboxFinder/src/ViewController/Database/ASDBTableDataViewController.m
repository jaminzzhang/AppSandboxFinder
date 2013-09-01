//
//  ASDBTableDataViewController.m
//  AppSandboxFinder
//
//  Created by Jamin on 8/18/13.
//  Copyright (c) 2013 Jaminz. All rights reserved.
//

#import "ASConstants.h"

#import "ASDBTableDataViewController.h"
#import "ASDBTableRowDataViewController.h"

static CGFloat const kCellTextFontSize = 16.0f;


@interface ASDBTableDataViewController ()


@property (nonatomic, strong) ASSqliteHandle *              dbHandle;
@property (nonatomic, strong) ASDBTable *                   dbTable;
@property (nonatomic, strong) NSArray *                     columnList;         // ASDBColumn Info
@property (nonatomic, strong) NSArray *                     allRowList;         // All table data
@property (nonatomic, strong) NSArray *                     resultRowList;      // the showed data after sorted or filter

@property (nonatomic, strong) UISearchBar *                 searchBar;

@property (nonatomic, assign) NSInteger                     columnCount;
@property (nonatomic, assign) CGFloat                       columnWidth;
@property (nonatomic, strong) NSMutableArray *              columnButtons;

@end

@implementation ASDBTableDataViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _columnButtons = [[NSMutableArray alloc] init];

    }
    return self;
}


- (id)initWithDBHandle:(ASSqliteHandle *)dbHandle withDBTable:(ASDBTable *)table
{
    self = [self initWithNibName:nil bundle:nil];
    if (nil != self) {
        _dbHandle = ASReturnRetained(dbHandle);
        _dbTable = ASReturnRetained(table);
        _columnList = ASReturnRetained([_dbHandle columnsOfTable:table.name]);
        NSArray * rowList = [_dbHandle queryTableRows:table.name orderByColumn:nil inOrder:NSOrderedAscending withLimit:-1];
        _allRowList = ASReturnRetained(rowList);
        _resultRowList = ASReturnRetained(_allRowList);
    }

    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.dbTable.name;

    UITableView * tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.dataTableView = tableView;
    ASRelease(tableView);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#if ! __has_feature(objc_arc)
- (void)dealloc
{
    ASRelease(_tableName);
    ASRelease(_dbHandle);
    ASRelease(_columnList);
    ASRelease(_allRowList);
    ASRelease(_allRowList);
    ASRelease(_resultRowList);
    
    ASRelease(_searchBar);
    ASRelease(_dataTableView);
    ASRelease(_columnPickerView);
    [super dealloc];
}
#endif

#pragma mark - Override
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.dataTableView deselectRowAtIndexPath:[self.dataTableView indexPathForSelectedRow] animated:YES];
}

#pragma mark - Databse table data
- (id)valueOfColumn:(NSString *)column atRow:(NSInteger)rowIndex
{
    NSAssert((rowIndex < self.resultRowList.count), @"the index of row is bigger than self.resultRowList.count.");
    NSDictionary * rowData = [self.resultRowList objectAtIndex:rowIndex];
    id value = [rowData objectForKey:column];
    return value;
}

- (NSString *)rowDataString:(NSInteger)row
{
    NSString * rowStr = @"";
    for (ASDBColumn * dbColumn in self.columnList) {
        NSString * columnName = [dbColumn name];
        id value = [self valueOfColumn:columnName atRow:row];
        if (nil != value) {
            NSString * valueStr = [NSString stringWithFormat:@"%@ | ", value];
            rowStr = [rowStr stringByAppendingString:valueStr];
        }
    }
    return rowStr;
}


#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultRowList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ASDBTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (nil == cell) {
        UITableViewCell *aCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell = ASReturnAutoreleased(aCell);
        cell.clipsToBounds = YES;
        cell.textLabel.font = [UIFont systemFontOfSize:kCellTextFontSize];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.lineBreakMode = NSLineBreakByCharWrapping;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    cell.textLabel.text = [self rowDataString:indexPath.row];
    return cell;
}


#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * rowStr = [self rowDataString:indexPath.row];
    CGSize size = [rowStr sizeWithFont:[UIFont systemFontOfSize:kCellTextFontSize]
                     constrainedToSize:CGSizeMake(tableView.frame.size.width - 40, 320)
                         lineBreakMode:NSLineBreakByCharWrapping];
    return size.height + 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * rowData = self.resultRowList[indexPath.row];
    ASDBTableRowDataViewController * viewController =
        [[ASDBTableRowDataViewController alloc] initWithRowData:rowData withColumnList:self.columnList];
    [self.navigationController pushViewController:viewController animated:YES];
    ASRelease(viewController);

}


@end
