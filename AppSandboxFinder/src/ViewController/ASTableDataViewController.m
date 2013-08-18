//
//  ASTableDataViewController.m
//  AppSandboxFinder
//
//  Created by Jamin on 8/18/13.
//  Copyright (c) 2013 Jaminz. All rights reserved.
//

#import "ASTableDataViewController.h"
#import "ASConstants.h"

@interface ASTableDataViewController ()


@property (nonatomic, strong) ASSqliteHandle *              dbHandle;
@property (nonatomic, strong) NSString *                    tableName;
@property (nonatomic, strong) NSArray *                     columnList;         // ASDBColumn Info
@property (nonatomic, strong) NSArray *                     allRowList;         // All table data
@property (nonatomic, strong) NSArray *                     resultRowList;      // the showed data after sorted or filter

@property (nonatomic, strong) UISearchBar *                 searchBar;

@property (nonatomic, assign) NSInteger                     columnCount;
@property (nonatomic, assign) CGFloat                       columnWidth;
@property (nonatomic, strong) NSMutableArray *              columnButtons;

@end

@implementation ASTableDataViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _columnButtons = [[NSMutableArray alloc] init];

    }
    return self;
}


- (id)initWithDBHandle:(ASSqliteHandle *)dbHandle withTableName:(NSString *)tableName
{
    self = [self initWithNibName:nil bundle:nil];
    if (nil != self) {
        _dbHandle = ASReturnRetained(dbHandle);
        _tableName = ASReturnRetained(tableName);
        _columnList = ASReturnRetained([_dbHandle columnsOfTable:_tableName]);
        NSArray * rowList = [_dbHandle queryTableRows:tableName orderByColumn:nil inOrder:NSOrderedAscending withLimit:-1];
        _allRowList = ASReturnRetained(rowList);
        _resultRowList = ASReturnRetained(_allRowList);
    }

    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

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
- (void)dealloc {
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

#pragma mark - Databse table data
- (id)valueOfColumn:(NSString *)column atRow:(NSInteger)rowIndex
{
    NSAssert((rowIndex < self.resultRowList.count), @"the index of row is bigger than self.resultRowList.count.");
    NSDictionary * rowData = [self.resultRowList objectAtIndex:rowIndex];
    id value = [rowData objectForKey:column];
    return value;
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
        cell.textLabel.font = [UIFont systemFontOfSize:17.0f];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    NSString * rowStr = @"";
    for (ASDBColumn * dbColumn in self.columnList) {
        NSString * columnName = [dbColumn name];
        id value = [self valueOfColumn:columnName atRow:indexPath.row];
        if (nil != value) {
            NSString * valueStr = [NSString stringWithFormat:@"%@ | ", value];
            rowStr = [rowStr stringByAppendingString:valueStr];
        }
    }
    cell.textLabel.text = rowStr;

    // Configure the cell...

    return cell;
}


#pragma mark - Table view delegate

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 50;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}


@end
