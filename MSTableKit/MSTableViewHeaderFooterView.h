//
//  MSTableViewHeaderFooterView.h
//  Grouped Example
//
//  Created by Eric Horacek on 2/1/13.
//  Copyright (c) 2013 Monospace Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSTableViewHeaderFooterView : UICollectionReusableView

@property (nonatomic, strong, readonly) UIView *contentView;
@property (nonatomic, strong, readonly) UILabel *title;
@property (nonatomic, strong, readonly) UILabel *detail;

@property (nonatomic, strong) NSDictionary *titleTextAttributes UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) NSDictionary *detailTextAttributes UI_APPEARANCE_SELECTOR;

@property (nonatomic, assign) UIEdgeInsets padding UI_APPEARANCE_SELECTOR;

- (void)initialize;
- (void)configureViews;

+ (void)applyDefaultAppearance;
+ (CGFloat)heightForText:(NSString *)text forWidth:(CGFloat)width;
+ (CGFloat)height;

@end
