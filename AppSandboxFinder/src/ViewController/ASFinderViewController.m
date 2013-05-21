//
//  ASFinderViewController.m
//  AppSandboxFinder
//
//  Created by Jamin on 13-4-6.
//  Copyright (c) 2013年 Jaminz. All rights reserved.
//

#import "ASFinderViewController.h"
#import "ASContentViewController.h"

#import "ASConstants.h"
#import "ASFileUtils.h"

@interface ASFinderViewController ()
{
    UIBarButtonItem *               _editBarButton;
    UIActivityIndicatorView *       _refreshIndicatorView;
}

@property (nonatomic, retain) UIRefreshControl *        refreshControl;

@end

@implementation ASFinderViewController


#pragma mark - Private
- (void)beginRefreshs
{
    [self.refreshControl beginRefreshing];
}

- (void)endRefreshs
{
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}



#pragma mark - File Operation
- (void)deleteItem:(id<ASFile>)item
{
    [ASFileUtils deleteFileAtPath:item.path];
    [self.localFileList removeObject:item];
}



#pragma mark - Action
- (void)pullToRefresh:(id)sender
{
    [self beginRefreshs];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.localFileList = [NSMutableArray arrayWithArray:[ASFileUtils localFilesAtPath:self.currentPath]];
        [self performSelectorOnMainThread:@selector(endRefreshs) withObject:nil waitUntilDone:NO];
    });
    
}


#pragma mark - UIViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (id)initWithDir:(ASDir *)dir
{
    self = [self initWithStyle:UITableViewStylePlain];
    if (nil != self) {
        _currentDir = ASReturnRetained(dir);
    }
    
    return self;
}



- (id)initWithPath:(NSString *)path
{
    
    self = [self initWithStyle:UITableViewStylePlain];
    if (nil != self) {
        _currentDir = [[ASDir alloc] initWithPath:path];
        
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.currentDir.name;
    
    self.clearsSelectionOnViewWillAppear = YES;
    self.localFileList = [NSMutableArray arrayWithArray:[ASFileUtils localFilesAtPath:self.currentPath]];
    [self.tableView reloadData];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    if (NSClassFromString(@"UIRefreshControl")) {
        UIRefreshControl * aRefreshControl = [[UIRefreshControl alloc] init];
        [aRefreshControl addTarget:self action:@selector(pullToRefresh:) forControlEvents:UIControlEventValueChanged];
        self.refreshControl = aRefreshControl;
        ASRelease(aRefreshControl);
    } else {
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGSize)contentSizeForViewInPopover
{
    return CGSizeMake(320, 480);
}

#if ! __has_feature(objc_arc)
- (void)dealloc {
    ASRelease(_currentDir);
    ASRelease(_localFileList);
    ASRelease(_refreshIndicatorView);
    ASRelease(_refreshBarButton);
    ASRelease(_refreshControl);

    [super dealloc];
}
#endif


#pragma mark - Setter & Getter
- (NSString *)currentPath
{
    return self.currentDir.path;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.localFileList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"LocalFileCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (nil == cell) {
        cell = ASReturnAutoreleased([[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]);
    }
    id<ASFile> file = [self.localFileList objectAtIndex:indexPath.row];
    cell.textLabel.text = file.name;
    cell.imageView.image = [ASFileUtils getFileIcon:file];
    
    return cell;
}
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        id<ASFile> delItem = [self.localFileList objectAtIndex:indexPath.row];
        [self deleteItem:delItem];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}



/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<ASFile> file = [self.localFileList objectAtIndex:indexPath.row];
    if ([file isKindOfClass:[ASDir class]]) {
        ASFinderViewController *viewController = [[ASFinderViewController alloc] initWithDir:file];
        [self.navigationController pushViewController:viewController animated:YES];
        ASRelease(viewController);
        
    } else {
        ASContentViewController *contentViewController = [[ASContentViewController alloc] initWithFile:file];
        [self.navigationController pushViewController:contentViewController animated:YES];
        ASRelease(contentViewController);
    }
}


@end
