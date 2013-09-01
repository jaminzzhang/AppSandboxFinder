//
//  ASDBTableRowDataViewController.m
//  AppSandboxFinder
//
//  Created by Jamin on 9/1/13.
//  Copyright (c) 2013 Jaminz. All rights reserved.
//

#import "ASConstants.h"

#import "ASDBTableRowDataViewController.h"
#import "ASDBColumn.h"

@interface ASDBTableRowDataViewController ()

@end

@implementation ASDBTableRowDataViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (id)initWithRowData:(NSDictionary *)dataDict withColumnList:(NSArray *)columnList
{
    self = [self initWithStyle:UITableViewStylePlain];
    if (self) {
        _rowDataDict = ASReturnRetained(dataDict);
        _columnList = ASReturnRetained(columnList);
    }

    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = YES;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#if ! __has_feature(objc_arc)
- (void)dealloc
{
    ASRelease(_rowDataDict);
    ASRelease(_columnList);
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
    return self.columnList.count;
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
        cell.detailTextLabel.numberOfLines = 3;

    }


    ASDBColumn * cloumn = self.columnList[indexPath.row];
    cell.textLabel.text = cloumn.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", self.rowDataDict[cloumn.name]];
    return cell;
}



#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ASDBColumn * cloumn = self.columnList[indexPath.row];
    NSString * detailStr = [NSString stringWithFormat:@"%@", self.rowDataDict[cloumn.name]];
    CGSize size = [detailStr sizeWithFont:[UIFont systemFontOfSize:17.0]
                        constrainedToSize:CGSizeMake(tableView.frame.size.width - 100, 320)
                            lineBreakMode:NSLineBreakByCharWrapping];
    return MAX(size.height + 20, 44);
}


@end
