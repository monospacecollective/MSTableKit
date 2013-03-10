//
//  MSCollectionViewPlainTableLayout.m
//  Plain Example
//
//  Created by Eric Horacek on 3/5/13.
//  Copyright (c) 2013 Monospace Ltd. All rights reserved.
//

#import "MSCollectionViewTableLayout.h"
#import "MSTableKitConstants.h"
#import "MSTableCell.h"

NSString *const MSCollectionElementKindCellEtch = @"MSCollectionElementKindCellEtch";
NSString *const MSCollectionElementKindHeaderEtch = @"MSCollectionElementKindHeaderEtch";

@interface MSCollectionViewTableLayout()

@property (nonatomic, strong) NSMutableDictionary *cellEtchAttributes;

// Registered Decoration Classes
@property (nonatomic, strong) NSMutableDictionary *registeredDecorationClasses;

@end

@implementation MSCollectionViewTableLayout

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"collectionView"];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.cellEtchAttributes = [NSMutableDictionary new];
        
        self.registeredDecorationClasses = [NSMutableDictionary new];
        self.cellEtchReferenceHeight = 1.0;
        self.minimumLineSpacing = 0.0;
        self.sectionInset = UIEdgeInsetsZero;
        
        [self addObserver:self forKeyPath:@"collectionView" options:NSKeyValueObservingOptionNew context:NULL];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // When there's a new UICollectionView set, configure it
    if ([keyPath isEqualToString:@"collectionView"]) {
        if (change[NSKeyValueChangeNewKey]) {
            self.collectionView.alwaysBounceVertical = YES;
            // Whoa whoa, check out this mother fucker
            self.collectionView.delegate = self;
            self.collectionView.dataSource = self;
        }
    }
}

- (UICollectionView *)collectionView
{
    UICollectionView *collectionView = [super collectionView];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    return collectionView;
}

- (void)registerClass:(Class)viewClass forDecorationViewOfKind:(NSString *)decorationViewKind
{
    [super registerClass:viewClass forDecorationViewOfKind:decorationViewKind];
    self.registeredDecorationClasses[decorationViewKind] = viewClass;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *rectAttributes = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *returnAttributes = [NSMutableArray new];
    
    for (UICollectionViewLayoutAttributes *attributes in rectAttributes) {
        if (attributes.representedElementKind == UICollectionElementKindSectionHeader) {
            
            attributes.zIndex = 2;
            
            if (self.stickySectionHeaders) {
                
                NSIndexPath *firstCellIndexPath = [NSIndexPath indexPathForItem:0 inSection:attributes.indexPath.section];
                NSIndexPath *lastCellIndexPath = [NSIndexPath indexPathForItem:fmaxf(0, ([self.collectionView numberOfItemsInSection:attributes.indexPath.section] - 1)) inSection:attributes.indexPath.section];
                
                UICollectionViewLayoutAttributes *firstCellAttributes = (UICollectionViewLayoutAttributes *)[self layoutAttributesForItemAtIndexPath:firstCellIndexPath];
                UICollectionViewLayoutAttributes *lastCellAttributes = (UICollectionViewLayoutAttributes *)[self layoutAttributesForItemAtIndexPath:lastCellIndexPath];
                
                CGPoint origin = attributes.frame.origin;
                origin.y = fminf(fmaxf(self.collectionView.contentOffset.y, (CGRectGetMinY(firstCellAttributes.frame) - CGRectGetHeight(attributes.frame))), (CGRectGetMaxY(lastCellAttributes.frame) - CGRectGetHeight(attributes.frame)));
                attributes.frame = (CGRect){origin, attributes.frame.size};
            }
        }
        else if (attributes.representedElementCategory == UICollectionElementCategoryCell) {
            
            attributes.zIndex = 1;
            
            UICollectionViewLayoutAttributes *etchAttributes = [self layoutAttributesForDecorationViewAtIndexPath:attributes.indexPath ofKind:MSCollectionElementKindCellEtch withItemCache:self.cellEtchAttributes];
            
            CGFloat etchMinY = CGRectGetMinY(attributes.frame) - self.cellEtchReferenceHeight;
            etchAttributes.frame = CGRectMake(CGRectGetMinX(attributes.frame), etchMinY, CGRectGetWidth(attributes.frame), self.cellEtchReferenceHeight);
            etchAttributes.zIndex = 0;
            
            BOOL lastCellInSection = (([self.collectionView numberOfItemsInSection:attributes.indexPath.section] - 1) == attributes.indexPath.item);
            if (lastCellInSection) {
                
                UICollectionViewLayoutAttributes *etchAttributes = [self layoutAttributesForDecorationViewAtIndexPath:[NSIndexPath indexPathForItem:(attributes.indexPath.item + 1) inSection:attributes.indexPath.section] ofKind:MSCollectionElementKindCellEtch withItemCache:self.cellEtchAttributes];
                CGFloat etchMinY = CGRectGetMaxY(attributes.frame) - self.cellEtchReferenceHeight;
                etchAttributes.frame = CGRectMake(CGRectGetMinX(attributes.frame), etchMinY, CGRectGetWidth(attributes.frame), self.cellEtchReferenceHeight);
                etchAttributes.zIndex = 0;
            }
        }
        [returnAttributes addObject:attributes];
    }
    
    // Return the visible attributes (rect intersection)
    [returnAttributes addObjectsFromArray:[[self.cellEtchAttributes allValues] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *layoutAttributes, NSDictionary *bindings) {
        return CGRectIntersectsRect(rect, layoutAttributes.frame);
    }]]];

    return returnAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind atIndexPath:(NSIndexPath *)indexPath
{
    if (decorationViewKind == MSCollectionElementKindCellEtch) {
        return self.cellEtchAttributes[indexPath];
    } else {
        return [super layoutAttributesForDecorationViewOfKind:decorationViewKind atIndexPath:indexPath];
    }
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBound
{
    return YES;
}

#pragma mark - MSCollectionViewTableLayout

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewAtIndexPath:(NSIndexPath *)indexPath ofKind:(NSString *)kind withItemCache:(NSMutableDictionary *)itemCache
{
    UICollectionViewLayoutAttributes *layoutAttributes;
    if (self.registeredDecorationClasses[kind] && !(layoutAttributes = itemCache[indexPath])) {
        layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:kind withIndexPath:indexPath];
        itemCache[indexPath] = layoutAttributes;
    }
    return layoutAttributes;
}

- (void)setSections:(NSArray *)sections
{
    _sections = sections;
    
    for (NSDictionary *section in sections) {
        for (NSDictionary *row in section[MSTableSectionRows]) {
            [self.collectionView registerClass:row[MSTableClass] forCellWithReuseIdentifier:row[MSTableReuseIdentifer]];
        }
        NSDictionary *header = section[MSTableSectionHeader];
        if (header) {
            [self.collectionView registerClass:header[MSTableClass] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:header[MSTableReuseIdentifer]];
        }
    }
    
    [self invalidateLayout];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.sections.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.sections[section][MSTableSectionRows] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *row = self.sections[indexPath.section][MSTableSectionRows][indexPath.row];
    UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:row[MSTableReuseIdentifer] forIndexPath:indexPath];
    void (^configurationBlock)(id cell) = row[MSTableConfigurationBlock];
    configurationBlock(cell);
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *section = self.sections[indexPath.section];
    if (kind == UICollectionElementKindSectionHeader) {
        NSDictionary *header = self.sections[indexPath.section][MSTableSectionHeader];
        if (!header) {
            return nil;
        }
        UICollectionReusableView *headerView = [self.collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:header[MSTableReuseIdentifer] forIndexPath:indexPath];
        void (^configurationBlock)(id headerView) = header[MSTableConfigurationBlock];
        configurationBlock(headerView);
        return headerView;
    }
    else if (kind == UICollectionElementKindSectionFooter) {
        NSDictionary *footer = self.sections[indexPath.section][MSTableSectionFooter];
        if (!footer) {
            return nil;
        }
        UICollectionReusableView *footerView = [self.collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:footer[MSTableReuseIdentifer] forIndexPath:indexPath];
        void (^configurationBlock)(id footerView) = footer[MSTableConfigurationBlock];
        configurationBlock(footerView);
        return footerView;
    }
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *row = self.sections[indexPath.section][MSTableSectionRows][indexPath.row];
    void (^itemSelectionBlock)() = row[MSTableItemSelectionBlock];
    if (itemSelectionBlock) {
        itemSelectionBlock(indexPath);
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *row = self.sections[indexPath.section][MSTableSectionRows][indexPath.row];
    CGFloat width = CGRectGetWidth(self.collectionView.frame);
    CGSize (^sizeBlock)(CGFloat width) = row[MSTableSizeBlock];
    if (sizeBlock) {
        return sizeBlock(width);
    } else {
        return CGSizeMake(width, [row[MSTableClass] height]);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    NSDictionary *header = self.sections[section][MSTableSectionHeader];
    if (!header) {
        return CGSizeZero;
    }
    CGFloat width = CGRectGetWidth(self.collectionView.frame);
    CGSize (^sizeBlock)(CGFloat width) = header[MSTableSizeBlock];
    if (sizeBlock) {
        return sizeBlock(width);
    } else {
        return CGSizeMake(width, [header[MSTableClass] height]);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    NSDictionary *footer = self.sections[section][MSTableSectionFooter];
    if (!footer) {
        return CGSizeZero;
    }
    CGFloat width = CGRectGetWidth(self.collectionView.frame);
    CGSize (^sizeBlock)(CGFloat width) = footer[MSTableSizeBlock];
    if (sizeBlock) {
        return sizeBlock(width);
    } else {
        return CGSizeMake(width, [footer[MSTableClass] height]);
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    CGFloat sectionSpacing = 10.0;
    if (section == 0) {
        if (collectionView.numberOfSections == 1) {
            return UIEdgeInsetsMake(sectionSpacing, 0.0, sectionSpacing, 0.0);
        } else {
            return UIEdgeInsetsMake(sectionSpacing, 0.0, (sectionSpacing / 2.0), 0.0);
        }
    }
    else if (section == (collectionView.numberOfSections - 1)) {
        return UIEdgeInsetsMake((sectionSpacing / 2.0), 0.0, sectionSpacing, 0.0);
    }
    else {
        return UIEdgeInsetsMake((sectionSpacing / 2.0), 0.0, (sectionSpacing / 2.0), 0.0);
    }
}

@end
