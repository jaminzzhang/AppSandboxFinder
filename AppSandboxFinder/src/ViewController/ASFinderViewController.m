//
//  ASFinderViewController.m
//  AppSandboxFinder
//
//  Created by Jamin on 13-4-6.
//  Copyright (c) 2013年 Jaminz. All rights reserved.
//

#import "ASFinderViewController.h"
#import "ASFileDetailViewController.h"

#import "ASConstants.h"
#import "ASFileUtils.h"

@interface ASFinderViewController () <UIDocumentInteractionControllerDelegate>
{
    UIBarButtonItem *               _editBarButton;
    UIActivityIndicatorView *       _refreshIndicatorView;
}

@property (nonatomic, strong) UIRefreshControl *                    refreshControl;
@property (nonatomic, strong) UIDocumentInteractionController *     documentInteractionController;

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

#pragma mark - UIViewController Overide
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}


- (BOOL)shouldAutorotate
{
    return YES;
}

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
        cell = ASReturnAutoreleased([[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier]);
        cell.textLabel.font = [UIFont systemFontOfSize:17.0f];
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    id<ASFile> file = [self.localFileList objectAtIndex:indexPath.row];
    cell.textLabel.text = file.name;
    cell.imageView.image = [ASFileUtils getFileIcon:file];
    
    if ([file isKindOfClass:[ASDir class]]) {
        cell.detailTextLabel.text =  [NSString stringWithFormat:NSLocalizedString(@"%d Files", @"Files Count"), [(ASDir *)file childrenCount]];
    } else {
        cell.detailTextLabel.text =  [ASFileUtils formatFileSize:file.size];
    }
    
//    NSString * subtitle = nil;
//    if (nil != file.ctime) {
//        subtitle = [NSString stringWithFormat:@"%@  %@", file.ctime, [ASFileUtils formatFileSize:file.size]];
//    } else {
//        subtitle = [ASFileUtils formatFileSize:file.size];
//    }
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



#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<ASFile> file = [self.localFileList objectAtIndex:indexPath.row];
    if ([file isKindOfClass:[ASDir class]]) {
        ASFinderViewController *viewController = [[ASFinderViewController alloc] initWithDir:file];
        [self.navigationController pushViewController:viewController animated:YES];
        ASRelease(viewController);
        
    } else {
        NSURL * fileURL = [NSURL fileURLWithPath:file.path];
        [self.documentInteractionController dismissMenuAnimated:NO];
        self.documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
        self.documentInteractionController.delegate = self;
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [self.documentInteractionController presentOptionsMenuFromRect:cell.bounds inView:cell animated:YES];
//        [self.documentInteractionController dismissPreviewAnimated:NO];
//        
//        BOOL canBePreviewed = [self.documentInteractionController presentPreviewAnimated:YES];
//        if (!canBePreviewed) {
//            // TODO：加入tips
//            
//            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//            [self.documentInteractionController presentOptionsMenuFromRect:cell.bounds inView:cell animated:YES];
//        }
    }
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    ASFileDetailViewController * detailViewController = [[ASFileDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:detailViewController animated:YES];
    ASRelease(detailViewController);
}



#pragma mark - UIDocumentInteractionControllerDelegate
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return self.navigationController;
}


@end
