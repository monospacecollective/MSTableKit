//
//  MSExampleTableViewController.m
//  MSPlainTableView Example
//
//  Created by Eric Horacek on 12/11/12.
//  Copyright (c) 2012 Monospace Ltd. All rights reserved.
//

#import "MSExamplePlainTableViewController.h"
#import "MSTableKit.h"
#import "KGNoise.h"
#import "MSCollectionViewTableLayout.h"
#import "MSTableCellEtch.h"

NSString * const MSCellReuseIdentifier = @"CellReuseIdentifier";
NSString * const MSRightDetailCellReuseIdentifier = @"RightDetailCellReuseIdentifier";
NSString * const MSSubtitleDetailCellReuseIdentifier = @"SubtitleDetailCellReuseIdentifier";

NSString * const MSHeaderReuseIdentifier = @"HeaderReuseIdentifier";
NSString * const MSFooterReuseIdentifier = @"FooterReuseIdentifier";

@interface MSExamplePlainTableViewController ()

@property (nonatomic, strong) MSPlainTableView *tableView;

@property (nonatomic, strong) NSArray *cellClasses;
@property (nonatomic, strong) NSArray *cellClassReuseIdentifiers;
@property (nonatomic, strong) NSArray *cellClassNames;
@property (nonatomic, strong) NSArray *cellClassDescriptions;

@end

@implementation MSExamplePlainTableViewController

- (id)init
{
    MSCollectionViewTableLayout *collectionViewFlowLayout = [[MSCollectionViewTableLayout alloc] init];
    collectionViewFlowLayout.minimumLineSpacing = 0.0;
    collectionViewFlowLayout.sectionInset = UIEdgeInsetsZero;
    self = [super initWithCollectionViewLayout:collectionViewFlowLayout];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor darkGrayColor];

    self.cellClasses = @[
        MSPlainTableViewCell.class,
        MSSubtitleDetailPlainTableViewCell.class,
        MSRightDetailPlainTableViewCell.class,
    ];
    self.cellClassReuseIdentifiers = @[
        MSCellReuseIdentifier,
        MSSubtitleDetailCellReuseIdentifier,
        MSRightDetailCellReuseIdentifier,
    ];
    self.cellClassNames = @[
        @"Plain Cell",
        @"Subtitle Detail Cell",
        @"Right Detail Cell",
        @"Multiline Cell",
        @"Button Cell"
    ];
    self.cellClassDescriptions = @[
        @"A cell that displays a title label, as well as a right-aligned accessory view",
        @"A cell that displays a title label with a detail label underneath, as well as a right-aligned accessory view",
        @"A cell that displays a title label with a detail to the right of it, as well as a right-aligned accessory view",
    ];
    
    // Cell Registration
    for (Class cellClass in self.cellClasses) {
        [self.collectionView registerClass:cellClass forCellWithReuseIdentifier:self.cellClassReuseIdentifiers[[self.cellClasses indexOfObject:cellClass]]];
    }
    
    [self.collectionView.collectionViewLayout registerClass:MSTableCellEtch.class forDecorationViewOfKind:MSCollectionElementKindCellEtch];
    
    [self.collectionView registerClass:MSPlainTableViewHeaderView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MSHeaderReuseIdentifier];
}

#pragma mark - MSExampleGroupedTableViewController

- (NSString *)collectionView:(UICollectionView *)collectionView titleForSupplementaryElementOfKind:(NSString *)kind inSection:(NSInteger)section
{
    if (kind == UICollectionElementKindSectionHeader) {
        return self.cellClassNames[section];
    }
    else if (kind == UICollectionElementKindSectionFooter) {
        return self.cellClassDescriptions[section];
    } else {
        return nil;
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.cellClasses.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.cellClasses[section] == MSPlainTableViewCell.class) {
        return 3;
    } else {
        return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.cellClassNames[section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MSTableCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:self.cellClassReuseIdentifiers[indexPath.section] forIndexPath:indexPath];
    
    if (self.cellClasses[indexPath.section] == MSPlainTableViewCell.class) {
        if ((indexPath.row % 3) == 0) {
            cell.title.text = @"No Accessory";
            cell.accessoryType = UITableViewCellAccessoryNone;
        } else if ((indexPath.row % 3) == 1) {
            cell.title.text = @"Disclosure Indicator";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else if ((indexPath.row % 3) == 2) {
            cell.title.text = @"Checkmark";
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    else if (self.cellClasses[indexPath.section] == MSSubtitleDetailPlainTableViewCell.class) {
        cell.title.text = @"Title Text";
        cell.detail.text = @"Detail text";
    }
    else if (self.cellClasses[indexPath.section] == MSRightDetailPlainTableViewCell.class) {
        cell.title.text = @"Title Text";
        cell.detail.text = @"Detail text";
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        MSPlainTableViewHeaderView *headerView = [self.collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:MSHeaderReuseIdentifier forIndexPath:indexPath];
        headerView.title.text = [self collectionView:collectionView titleForSupplementaryElementOfKind:kind inSection:indexPath.section];
        return headerView;
    }
    return nil;
}

#pragma mark - UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = UIInterfaceOrientationIsPortrait(self.interfaceOrientation) ? CGRectGetWidth(self.view.frame) : CGRectGetHeight(self.view.frame);
    CGFloat height = [MSPlainTableViewCell cellHeight];
    return CGSizeMake(width, height);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGFloat width = UIInterfaceOrientationIsPortrait(self.interfaceOrientation) ? CGRectGetWidth(self.view.frame) : CGRectGetHeight(self.view.frame);
    CGFloat height = [MSPlainTableViewHeaderView heightForText:[self collectionView:collectionView titleForSupplementaryElementOfKind:UICollectionElementKindSectionHeader inSection:section] forWidth:width];
    return CGSizeMake(width, height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
