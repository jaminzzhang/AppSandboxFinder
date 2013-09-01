//
//  ASDBTableInfoViewController.m
//  AppSandboxFinder
//
//  Created by Jamin on 7/28/13.
//  Copyright (c) 2013 Jaminz. All rights reserved.
//

#import "ASDBTableInfoViewController.h"
#import "ASConstants.h"
#import <objc/runtime.h>


typedef NS_ENUM(NSUInteger, ASDBTableInfoIndex)
{
    kASDBTableNameIndex = 0,
    kASDBTableTblNameIndex,
    kASDBTableRootpageIndex,
    kASDBTableSqlIndex
};

@interface ASDBTableInfoViewController ()


@end

@implementation ASDBTableInfoViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (id)initWithDBTable:(ASDBTable *)table
{
    self = [self initWithStyle:UITableViewStylePlain];
    if (self) {
        _dbTable = ASReturnRetained(table);
    }

    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#if ! __has_feature(objc_arc)
- (void)dealloc
{
    ASRelease(_tableView);
    [super dealloc];
}
#endif


#pragma mark ASDBTable Info
- (NSString *)propertyOfDBTableAtIndex:(ASDBTableInfoIndex)index
{
    NSString * infoName = nil;
    switch (index) {
        case kASDBTableNameIndex:
        {
            infoName = @"name";
        }
            break;

        case kASDBTableTblNameIndex:
        {
            infoName = @"tbl_name";
        }
            break;


        case kASDBTableRootpageIndex:
        {
            infoName = @"rootpage";
        }
            break;

        case kASDBTableSqlIndex:
        {
            infoName = @"sql";
        }
            break;
            
        default:
            break;
    }

    return infoName;
}


- (id)valueOfDBTableAtIndex:(ASDBTableInfoIndex)index
{
    id value = nil;
    switch (index) {
        case kASDBTableNameIndex:
        {
            value = self.dbTable.name;
        }
            break;

        case kASDBTableTblNameIndex:
        {
            value = self.dbTable.tbl_name;
        }
            break;


        case kASDBTableRootpageIndex:
        {
            value = @(self.dbTable.rootpage);
        }
            break;

        case kASDBTableSqlIndex:
        {
            value = self.dbTable.sql;
        }
            break;

        default:
            break;
    }
    
    return value;

}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return kASDBTableSqlIndex + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ASDBTableRowCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (nil == cell) {
        UITableViewCell *aCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell = ASReturnAutoreleased(aCell);
        cell.textLabel.font = [UIFont systemFontOfSize:17.0f];
        cell.accessoryType = UITableViewCellAccessoryNone;

        cell.detailTextLabel.font = [UIFont systemFontOfSize:17.0f];
        cell.detailTextLabel.lineBreakMode = NSLineBreakByCharWrapping;
        cell.detailTextLabel.numberOfLines = 0;
    }

    NSString * propertyName = [self propertyOfDBTableAtIndex:indexPath.row];
    cell.textLabel.text = propertyName;
    cell.detailTextLabel.text = [[self valueOfDBTableAtIndex:indexPath.row] description];
    return cell;
}


#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * detailStr = [[self valueOfDBTableAtIndex:indexPath.row] description];
    CGSize size = [detailStr sizeWithFont:[UIFont systemFontOfSize:17.0]
                        constrainedToSize:CGSizeMake(tableView.frame.size.width - 100, 640)
                            lineBreakMode:NSLineBreakByCharWrapping];
    return MAX(size.height + 20, 44);
}

@end
