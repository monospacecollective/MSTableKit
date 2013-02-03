//
//  MSTableViewHeaderFooterView.h
//  Grouped Example
//
//  Created by Eric Horacek on 2/1/13.
//  Copyright (c) 2013 Monospace Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_6_0
@interface MSTableViewHeaderFooterView : UITableViewHeaderFooterView
#else
@interface MSTableViewHeaderFooterView : UIView
#endif

#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
@property (nonatomic, strong, readonly) UILabel* textLabel;
@property (nonatomic, strong, readonly) UILabel* detailTextLabel;
#endif

@property (nonatomic, strong) NSDictionary *titleTextAttributes UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) NSDictionary *detailTextAttributes UI_APPEARANCE_SELECTOR;

- (void)initialize;
- (void)configureViews;

// Sizing Calculation
+ (UIFont *)defaultTextLabelFont;
+ (CGFloat)heightForText:(NSString *)text forWidth:(CGFloat)width;
+ (CGSize)padding;

@end
