//
//  ASFileDetailViewController.m
//  AppSandboxFinder
//
//  Created by Jamin on 13-5-23.
//  Copyright (c) 2013年 Jaminz. All rights reserved.
//

#import "ASFileDetailViewController.h"
#import "ASFileUtils.h"


typedef enum ASFileSection : NSUInteger {
    kASFileSectionBaseInfo,
    kASFileSectionAttribute,
    kASFileSectionTime,
    kASFileSectionMax,
    
} ASFileDetailSection;


//基础信息
typedef enum ASFileBaseInfoRow : NSUInteger {
    kASFileBaseInfoRowName,
    kASFileBaseInfoRowPath,
    kASFileBaseInfoRowOpenIn,
    kASFileBaseInfoRowMax,
    
} ASFileBaseInfoRow;

//属性
typedef enum ASFileAttributeRow : NSUInteger {
    kASFileAttributeRowType,
    kASFileAttributeRowSize,
    kASFileAttributeRowMIMEType,
    kASFileAttributeRowMd5,
    kASFileAttributeRowMax
} ASFileAttributeRow;


//属性
typedef enum ASFileTimeRow : NSUInteger {
    kASFileTimeRowCreateTime,
    kASFileTimeRowModifyTime,
    kASFileTimeRowMax,
} ASFileTimeRow;




@interface ASFileDetailViewController () <UIDocumentInteractionControllerDelegate>

@property (nonatomic, strong) UIDocumentInteractionController *     documentInteractionController;

@end

@implementation ASFileDetailViewController




#pragma mark - Init

- (id)initWithFile:(id<ASFile>)file
{
    self = [self initWithStyle:UITableViewStyleGrouped];
    if (nil != self) {
        _currentItem = ASReturnRetained(file);
    }
    
    return self;
}

- (id)initWithPath:(NSString *)path
{
    self = [self initWithStyle:UITableViewStyleGrouped];
    if (nil != self) {
        if ([ASFileUtils isDirAtPath:path]) {
            _currentItem = [[ASDir alloc] initWithPath:path];
        } else {
            _currentItem = [[ASFile alloc] initWithPath:path];
        }
    }
    
    return self;
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

- (void)viewDidLoad
{
    [super viewDidLoad];

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
- (void)dealloc {
    ASRelease(_documentInteractionController);
    [super dealloc];
}
#endif

#pragma mark - Table view data source

- (void)loadCell:(UITableViewCell *)cell ofIndexPath:(NSIndexPath *)indexPath
{
    NSAssert(nil != cell, @"The Nil cell can't be loaded.");
    switch (indexPath.section) {
        case kASFileSectionBaseInfo:
        {
            switch (indexPath.row) {
                case kASFileBaseInfoRowName:
                {
                    cell.textLabel.text = NSLocalizedString(@"名称", @"名称");
                    cell.detailTextLabel.text = self.currentItem.name;
//                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.detailTextLabel.numberOfLines = 2;
                }
                    break;
                    
                case kASFileBaseInfoRowPath:
                {
                    cell.textLabel.text = NSLocalizedString(@"路径", @"路径");
                    cell.detailTextLabel.text = [self.currentItem.path stringByDeletingLastPathComponent];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.detailTextLabel.numberOfLines = 2;
                }
                    break;
                    
                case kASFileBaseInfoRowOpenIn:
                {
                    cell.textLabel.text = NSLocalizedString(@"打开方式 ...", @"打开方式...");
                    if ([self.currentItem isKindOfClass:[ASDir class]]) {
                        cell.textLabel.textColor = [UIColor grayColor];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
            
        case kASFileSectionAttribute:
        {
            switch (indexPath.row) {
                case kASFileAttributeRowType:
                {
                    cell.textLabel.text = NSLocalizedString(@"类型", @"类型");
                    cell.detailTextLabel.text = self.currentItem.name;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                    break;
                    
                case kASFileAttributeRowSize:
                {
                    cell.textLabel.text = NSLocalizedString(@"大小", @"大小");
                    cell.detailTextLabel.text = [ASFileUtils formatFileSize:self.currentItem.size];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                    break;
                    
                case kASFileAttributeRowMIMEType:
                {
                    cell.textLabel.text = NSLocalizedString(@"MIME类型", @"MIME类型");
                    cell.detailTextLabel.text = ((ASFile *)(self.currentItem)).typeIdentifier;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;

                }
                    break;
                    
                    
                case kASFileAttributeRowMd5:
                {
                    cell.textLabel.text = NSLocalizedString(@"MD5", @"MD5");
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                    break;

                    
                default:
                    break;
            }
        }
            break;
            
            
        case kASFileSectionTime:
        {
            switch (indexPath.row) {
                case kASFileTimeRowCreateTime:
                {
                    cell.textLabel.text = NSLocalizedString(@"创建时间", @"创建时间");
                    cell.detailTextLabel.text = [self.currentItem.ctime description];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                    break;
                    
                case kASFileTimeRowModifyTime:
                {
                    cell.textLabel.text = NSLocalizedString(@"修改时间", @"修改时间");
                    cell.detailTextLabel.text = [self.currentItem.mtime description];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                    break;                    
                    
                default:
                    break;
            }

        }
            break;
            
        default:
            break;
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return kASFileSectionMax;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case kASFileSectionBaseInfo:
            return kASFileBaseInfoRowMax;
            break;
            
            
        case kASFileSectionAttribute:
            return kASFileAttributeRowMax;
            break;
            
            
        case kASFileSectionTime:
            return kASFileTimeRowMax;
            break;
            
        default:
            break;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ASFileDetailCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (nil == cell) {
        UITableViewCell *aCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell = ASReturnAutoreleased(aCell);
        cell.textLabel.font = [UIFont systemFontOfSize:17.0f];
    }
    [self loadCell:cell ofIndexPath:indexPath];
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
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([self.currentItem isMemberOfClass:[ASFile class]] && indexPath.section == kASFileSectionBaseInfo && kASFileBaseInfoRowOpenIn == indexPath.row) {
        
        [self.documentInteractionController dismissMenuAnimated:NO];
        NSURL * fileURL = [NSURL fileURLWithPath:self.currentItem.path];
        self.documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
        self.documentInteractionController.delegate = self;
        [self.documentInteractionController presentOptionsMenuFromRect:cell.bounds inView:cell animated:YES];
    }
}


#pragma mark - UIDocumentInteractionControllerDelegate
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return self.navigationController;
}


@end
