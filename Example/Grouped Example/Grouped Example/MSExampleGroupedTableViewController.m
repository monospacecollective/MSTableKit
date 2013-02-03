//
//  MSExampleGroupedTableViewController.m
//  Grouped Example
//
//  Created by Eric Horacek on 12/26/12.
//  Copyright (c) 2012 Monospace Ltd. All rights reserved.
//

#import "MSExampleGroupedTableViewController.h"
#import "MSTableKit.h"

NSString * const MSCellReuseIdentifier = @"CellReuseIdentifier";
NSString * const MSRightDetailCellReuseIdentifier = @"RightDetailCellReuseIdentifier";
NSString * const MSSubtitleDetailCellReuseIdentifier = @"SubtitleDetailCellReuseIdentifier";
NSString * const MSButtonCellReuseIdentifier = @"ButtonCellReuseIdentifier";

NSString * const MSHeaderReuseIdentifier = @"HeaderReuseIdentifier";
NSString * const MSFooterReuseIdentifier = @"FooterReuseIdentifier";

@interface MSExampleGroupedTableViewController ()

@property (nonatomic, strong) NSArray *cellClasses;
@property (nonatomic, strong) NSArray *cellClassNames;
@property (nonatomic, strong) NSArray *cellClassReuseIdentifiers;

@end

@implementation MSExampleGroupedTableViewController

- (void)loadView
{
    self.tableView = [[MSGroupedTableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.cellClasses = @[
                         MSGroupedTableViewCell.class,
                         MSSubtitleDetailGroupedTableViewCell.class,
                         MSRightDetailGroupedTableViewCell.class
                         ];
    self.cellClassReuseIdentifiers = @[
                                       MSCellReuseIdentifier,
                                       MSSubtitleDetailCellReuseIdentifier,
                                       MSRightDetailCellReuseIdentifier
                                       ];
    self.cellClassNames = @[
                            @"Plain Cell",
                            @"Subtitle Detail Cell",
                            @"Right Detail Cell",
                            @"Button Cell"
                            ];
    
    [self.tableView registerClass:MSButtonGroupedTableViewCell.class forCellReuseIdentifier:MSButtonCellReuseIdentifier];
    
    // Cell Registration
    for (Class cellClass in self.cellClasses) {
        [self.tableView registerClass:cellClass forCellReuseIdentifier:self.cellClassReuseIdentifiers[[self.cellClasses indexOfObject:cellClass]]];
    }
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_6_0
    [self.tableView registerClass:MSGroupedTableViewHeaderView.class forHeaderFooterViewReuseIdentifier:MSHeaderReuseIdentifier];
    [self.tableView registerClass:MSGroupedTableViewFooterView.class forHeaderFooterViewReuseIdentifier:MSFooterReuseIdentifier];
#endif
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return (self.cellClasses.count + 1);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((section < self.cellClasses.count) ? 3 : 1);
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.cellClassNames[section];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if ((section % 3) == 0) {
        return nil;
    } else if ((section % 3) == 1) {
        return @"Fringilla Nibh Quam Euismod Ligula";
    } else if ((section % 3) == 2) {
        return @"Cras mattis consectetur purus sit amet fermentum. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.";
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < self.cellClasses.count) {
        
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
        
    } else {
        
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:MSButtonCellReuseIdentifier];
        cell.textLabel.text = @"Button Text";
        return cell;
        
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_6_0
    MSGroupedTableViewHeaderView *headerView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:MSHeaderReuseIdentifier];
#else
    MSGroupedTableViewHeaderView *headerView = [[MSGroupedTableViewHeaderView alloc] init];
    headerView.textLabel.text = [self tableView:tableView titleForHeaderInSection:section];
#endif
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_6_0
    MSGroupedTableViewFooterView *footerView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:MSFooterReuseIdentifier];
#else
    MSGroupedTableViewFooterView *footerView = [[MSGroupedTableViewFooterView alloc] init];
    footerView.textLabel.text = [self tableView:tableView titleForFooterInSection:section];
#endif
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat width = UIInterfaceOrientationIsPortrait(self.interfaceOrientation) ? CGRectGetWidth(self.view.frame) : CGRectGetHeight(self.view.frame);
    return [MSGroupedTableViewFooterView heightForText:[self tableView:tableView titleForFooterInSection:section] forWidth:width];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat width = UIInterfaceOrientationIsPortrait(self.interfaceOrientation) ? CGRectGetWidth(self.view.frame) : CGRectGetHeight(self.view.frame);
    return [MSGroupedTableViewHeaderView heightForText:[self tableView:tableView titleForHeaderInSection:section] forWidth:width];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
}

@end
