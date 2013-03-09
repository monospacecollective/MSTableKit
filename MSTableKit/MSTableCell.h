//
//  MSTableCell.h
//  Plain Example
//
//  Created by Eric Horacek on 12/25/12.
//  Copyright (c) 2012 Monospace Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MSTableCellSelectionStyle) {
    MSTableCellSelectionStyleNone,
    MSTableCellSelectionStyleIndent
};

typedef NS_ENUM(NSInteger, MSTableCellAccessoryType) {
    MSTableCellAccessoryTypeNone,
    MSTableCellAccessoryDisclosureIndicator,
    MSTableCellAccessoryDetailDisclosureButton,
    MSTableCellAccessoryCheckmark,
    MSTableCellAccessoryStarFull,
    MSTableCellAccessoryStarEmpty,
};

@interface MSTableCell : UICollectionViewCell

@property (nonatomic, strong, readonly) UILabel *title;
@property (nonatomic, strong, readonly) UILabel *detail;
@property (nonatomic, strong, readonly) UILabel *accessory;
@property (nonatomic, assign, readonly) UIControlState controlState;

@property (nonatomic, strong) UIView *accessoryView;
@property (nonatomic, assign) MSTableCellAccessoryType accessoryType;

@property (nonatomic, assign) MSTableCellSelectionStyle selectionStyle;

@property (nonatomic, assign) CGFloat contentMargin UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) UIEdgeInsets padding UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) UIEdgeInsets backgroundViewPadding UI_APPEARANCE_SELECTOR;

- (void)setTitleTextAttributes:(NSDictionary *)textAttributes forState:(UIControlState)state UI_APPEARANCE_SELECTOR;
- (void)setDetailTextAttributes:(NSDictionary *)textAttributes forState:(UIControlState)state UI_APPEARANCE_SELECTOR;
- (void)setAccessoryTextAttributes:(NSDictionary *)textAttributes forState:(UIControlState)state UI_APPEARANCE_SELECTOR;

- (NSDictionary *)titleTextAttributesForState:(UIControlState)state UI_APPEARANCE_SELECTOR;
- (NSDictionary *)detailTextAttributesForState:(UIControlState)state UI_APPEARANCE_SELECTOR;
- (NSDictionary *)accessoryTextAttributesForState:(UIControlState)state UI_APPEARANCE_SELECTOR;

- (void)setAccessoryCharacter:(NSString *)accessorycharacter forAccessoryType:(MSTableCellAccessoryType)accessoryType UI_APPEARANCE_SELECTOR;
- (NSString *)accessoryCharacterForAccessoryType:(MSTableCellAccessoryType)accessoryType UI_APPEARANCE_SELECTOR;

- (void)initialize;
- (void)configureViews;

+ (void)applyDefaultAppearance;
+ (CGFloat)height;

@end
