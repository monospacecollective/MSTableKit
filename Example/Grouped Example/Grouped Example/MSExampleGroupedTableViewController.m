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
NSString * const MSMultilineCellReuseIdentifier = @"MultilineCellReuseIdentifier";
NSString * const MSButtonCellReuseIdentifier = @"ButtonCellReuseIdentifier";

NSString * const MSHeaderReuseIdentifier = @"HeaderReuseIdentifier";
NSString * const MSFooterReuseIdentifier = @"FooterReuseIdentifier";

@interface MSExampleGroupedTableViewController () <UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionViewFlowLayout *collectionViewLayout;

@property (nonatomic, strong) NSArray *cellClasses;
@property (nonatomic, strong) NSArray *cellClassReuseIdentifiers;
@property (nonatomic, strong) NSArray *cellClassNames;
@property (nonatomic, strong) NSArray *cellClassDescriptions;

@end

@implementation MSExampleGroupedTableViewController

- (id)init
{
    UICollectionViewFlowLayout *collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    collectionViewFlowLayout.minimumLineSpacing = 0.0;
    collectionViewFlowLayout.sectionInset = UIEdgeInsetsZero;
    self = [super initWithCollectionViewLayout:collectionViewFlowLayout];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor lightGrayColor];

    self.cellClasses = @[
        MSGroupedTableViewCell.class,
        MSSubtitleDetailGroupedTableViewCell.class,
        MSRightDetailGroupedTableViewCell.class,
        MSMultlineGroupedTableViewCell.class,
        MSButtonGroupedTableViewCell.class
    ];
    self.cellClassReuseIdentifiers = @[
        MSCellReuseIdentifier,
        MSSubtitleDetailCellReuseIdentifier,
        MSRightDetailCellReuseIdentifier,
        MSMultilineCellReuseIdentifier,
        MSButtonCellReuseIdentifier
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
        @"A cell that displays a title label sized to multiple lines of text, as well as a right-aligned accessory view",
        @"A cell that displays a styed button, with centered text on a single line"
    ];
    
    // Cell Registration
    for (Class cellClass in self.cellClasses) {
        [self.collectionView registerClass:cellClass forCellWithReuseIdentifier:self.cellClassReuseIdentifiers[[self.cellClasses indexOfObject:cellClass]]];
    }
    
    [self.collectionView registerClass:MSGroupedTableViewHeaderView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MSHeaderReuseIdentifier];
    [self.collectionView registerClass:MSGroupedTableViewFooterView.class forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:MSFooterReuseIdentifier];
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

- (NSString *)titleForMultilineCell
{
    return @"Praesent commodo cursus magna, vel scelerisque nisl consectetur et. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus. Curabitur blandit tempus porttitor.";
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.cellClasses.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.cellClasses[section] == MSGroupedTableViewCell.class) {
        return 3;
    } else {
        return 1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MSTableCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:self.cellClassReuseIdentifiers[indexPath.section] forIndexPath:indexPath];
    
    if (self.cellClasses[indexPath.section] == MSGroupedTableViewCell.class) {
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
    else if (self.cellClasses[indexPath.section] == MSSubtitleDetailGroupedTableViewCell.class) {
        cell.title.text = @"Title Text";
        cell.detail.text = @"Detail text";
    }
    else if (self.cellClasses[indexPath.section] == MSRightDetailGroupedTableViewCell.class) {
        cell.title.text = @"Title Text";
        cell.detail.text = @"Detail text";
    }
    else if (self.cellClasses[indexPath.section] == MSMultlineGroupedTableViewCell.class) {
        cell.title.text = [self titleForMultilineCell];
    }
    else if (self.cellClasses[indexPath.section] == MSButtonGroupedTableViewCell.class) {
        cell.title.text = @"Button Title Text";
    }

    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        MSGroupedTableViewHeaderView *headerView = [self.collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:MSHeaderReuseIdentifier forIndexPath:indexPath];
        headerView.title.text = [self collectionView:collectionView titleForSupplementaryElementOfKind:kind inSection:indexPath.section];
        return headerView;
    }
    else if (kind == UICollectionElementKindSectionFooter) {
        MSGroupedTableViewFooterView *footerView = [self.collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:MSFooterReuseIdentifier forIndexPath:indexPath];
        footerView.title.text = [self collectionView:collectionView titleForSupplementaryElementOfKind:kind inSection:indexPath.section];
        return footerView;
    }
    return nil;
}

#pragma mark - UICollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = UIInterfaceOrientationIsPortrait(self.interfaceOrientation) ? CGRectGetWidth(self.view.frame) : CGRectGetHeight(self.view.frame);
    CGFloat height;
    if ((indexPath.section < (NSInteger)self.cellClasses.count) && self.cellClasses[indexPath.section] == MSMultlineGroupedTableViewCell.class) {
        height = [MSMultlineGroupedTableViewCell heightForText:[self titleForMultilineCell] forWidth:width];
    } else {
        height = [MSGroupedTableViewCell height];
    }
    return CGSizeMake(width, height);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGFloat width = UIInterfaceOrientationIsPortrait(self.interfaceOrientation) ? CGRectGetWidth(self.view.frame) : CGRectGetHeight(self.view.frame);
    CGFloat height = [MSGroupedTableViewHeaderView heightForText:[self collectionView:collectionView titleForSupplementaryElementOfKind:UICollectionElementKindSectionHeader inSection:section] forWidth:width];
    return CGSizeMake(width, height);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    CGFloat width = UIInterfaceOrientationIsPortrait(self.interfaceOrientation) ? CGRectGetWidth(self.view.frame) : CGRectGetHeight(self.view.frame);
    CGFloat height = [MSGroupedTableViewFooterView heightForText:[self collectionView:collectionView titleForSupplementaryElementOfKind:UICollectionElementKindSectionFooter inSection:section] forWidth:width];
    return CGSizeMake(width, height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
