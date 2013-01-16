//
//  MSExampleGroupedTableViewController.m
//  Grouped Example
//
//  Created by Eric Horacek on 12/26/12.
//  Copyright (c) 2012 Monospace Ltd. All rights reserved.
//

#import "MSExampleGroupedTableViewController.h"
#import "MSGroupedTableView.h"

NSString * const MSExampleCellReuseIdentifier = @"CellReuseIdentifier";
NSString * const MSExampleRightDetailCellReuseIdentifier = @"RightDetailCellReuseIdentifier";
NSString * const MSExampleSubtitleDetailCellReuseIdentifier = @"SubtitleDetailCellReuseIdentifier";
NSString * const MSExampleButtonCellReuseIdentifier = @"ButtonCellReuseIdentifier";

NSString * const MSExampleHeaderReuseIdentifier = @"HeaderReuseIdentifier";

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
                                       MSExampleCellReuseIdentifier,
                                       MSExampleSubtitleDetailCellReuseIdentifier,
                                       MSExampleRightDetailCellReuseIdentifier
                                       ];
    self.cellClassNames = @[
                            @"Plain Cell",
                            @"Subtitle Detail Cell",
                            @"Right Detail Cell",
                            @"Button Cell"
                            ];
    
    [self.tableView registerClass:MSButtonGroupedTableViewCell.class forCellReuseIdentifier:MSExampleButtonCellReuseIdentifier];
    
    // Cell Registration
    for (Class cellClass in self.cellClasses) {
        [self.tableView registerClass:cellClass forCellReuseIdentifier:self.cellClassReuseIdentifiers[[self.cellClasses indexOfObject:cellClass]]];
    }
    
    [self.tableView registerClass:MSGroupedTableViewHeaderView.class forHeaderFooterViewReuseIdentifier:MSExampleHeaderReuseIdentifier];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.cellClasses.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((section < self.cellClasses.count) ? 3 : 1);
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.cellClassNames[section];
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
        
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:MSExampleButtonCellReuseIdentifier];
        cell.textLabel.text = @"Button Text";
        return cell;
        
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MSGroupedTableViewHeaderView *headerView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:MSExampleHeaderReuseIdentifier];
    return headerView;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
}

@end
