//
//  MSExampleTableViewController.m
//  MSGroupedTableView Example
//
//  Created by Eric Horacek on 12/11/12.
//  Copyright (c) 2012 Monospace Ltd. All rights reserved.
//

#import "MSExamplePlainTableViewController.h"
#import "MSPlainTableView.h"
#import "KGNoise.h"

NSString * const MSExampleCellReuseIdentifier = @"CellReuseIdentifier";
NSString * const MSExampleRightDetailCellReuseIdentifier = @"RightDetailCellReuseIdentifier";
NSString * const MSExampleSubtitleDetailCellReuseIdentifier = @"SubtitleDetailCellReuseIdentifier";

NSString * const MSExampleHeaderReuseIdentifier = @"HeaderReuseIdentifier";

@interface MSExamplePlainTableViewController ()

@property (nonatomic, strong) MSPlainTableView *tableView;

@property (nonatomic, strong) NSArray *cellClasses;
@property (nonatomic, strong) NSArray *cellClassNames;
@property (nonatomic, strong) NSArray *cellClassReuseIdentifiers;

@end

@implementation MSExamplePlainTableViewController

- (void)loadView
{
    self.tableView = [[MSPlainTableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.cellClasses = @[
        MSPlainTableViewCell.class,
        MSSubtitleDetailPlainTableViewCell.class,
        MSRightDetailPlainTableViewCell.class
    ];
    self.cellClassReuseIdentifiers = @[
        MSExampleCellReuseIdentifier,
        MSExampleSubtitleDetailCellReuseIdentifier,
        MSExampleRightDetailCellReuseIdentifier,
    ];
    self.cellClassNames = @[
        @"Plain Cell",
        @"Subtitle Detail Cell",
        @"Right Detail Cell",
    ];
    
    // Cell Registration
    for (Class cellClass in self.cellClasses) {
        [self.tableView registerClass:cellClass forCellReuseIdentifier:self.cellClassReuseIdentifiers[[self.cellClasses indexOfObject:cellClass]]];
    }
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_6_0
    [self.tableView registerClass:MSPlainTableViewHeaderView.class forHeaderFooterViewReuseIdentifier:MSExampleHeaderReuseIdentifier];
#endif
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.cellClasses.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.cellClassNames[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:self.cellClassReuseIdentifiers[indexPath.section]];
    
    if ((indexPath.row % 3) == 0) {
        cell.textLabel.text = @"No Accessory";
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else if ((indexPath.row % 3) == 1) {
        cell.textLabel.text = @"Disclosure Indicator";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if ((indexPath.row % 3) == 2) {
        cell.textLabel.text = @"Checkmark";
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    cell.detailTextLabel.text = @"Detail text";
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_6_0
    MSPlainTableViewHeaderView *headerView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:MSExampleHeaderReuseIdentifier];
#else
    MSPlainTableViewHeaderView *headerView = [[MSPlainTableViewHeaderView alloc] init];
    headerView.textLabel.text = [self tableView:tableView titleForHeaderInSection:section];
#endif
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat width = UIInterfaceOrientationIsPortrait(self.interfaceOrientation) ? CGRectGetWidth(self.view.frame) : CGRectGetHeight(self.view.frame);
    return [MSPlainTableViewHeaderView heightForText:[self tableView:tableView titleForHeaderInSection:section] forWidth:width];
}

@end
