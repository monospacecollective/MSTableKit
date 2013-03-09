//
//  MSButtonGroupedTableViewCell.m
//  Grouped Example
//
//  Created by Eric Horacek on 1/14/13.
//  Copyright (c) 2013 Monospace Ltd. All rights reserved.
//

#import "MSButtonGroupedTableViewCell.h"
#import "UIColor+Expanded.h"

@interface MSButtonGroupedTableViewCell () {
    UIColor *_buttonbackgroundColor;
}

@end

@implementation MSButtonGroupedTableViewCell

#pragma mark - MSTableCell

- (void)initialize
{
    [super initialize];
    
    self.groupedCellBackgroundView.backgroundColorGradientEnabled = YES;
    self.groupedCellBackgroundView.middleBottomUsesShadowColorForNormalInnerShadowColor = NO;
    self.groupedCellBackgroundView.backgroundNoiseEnabled = YES;
    [self.groupedCellBackgroundView setInnerShadowColor:[[UIColor whiteColor] colorWithAlphaComponent:0.3] forState:UIControlStateNormal];
    
    self.title.textAlignment = NSTextAlignmentCenter;
    self.buttonBackgroundColor = [UIColor darkGrayColor];
}

#pragma mark - MSButtonGroupedTableViewCell

- (void)setButtonBackgroundColor:(UIColor *)buttonBackgroundColor
{
    [self.groupedCellBackgroundView setFillColor:buttonBackgroundColor forState:UIControlStateNormal];
    [self.groupedCellBackgroundView setFillColor:[buttonBackgroundColor colorByAdding:-0.1] forState:UIControlStateHighlighted];
    [self.groupedCellBackgroundView setBorderColor:[buttonBackgroundColor colorByAdding:-0.2] forState:UIControlStateNormal];
    [self.groupedCellBackgroundView setBorderColor:[buttonBackgroundColor colorByAdding:-0.3] forState:UIControlStateHighlighted];
//    if (buttonBackgroundColor.brightness < 0.5) {
//        self.titleTextColor = [UIColor whiteColor];
//        self.title.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
//        self.title.shadowOffset = CGSizeMake(0.0, -1.0);
//    } else {
//        self.titleTextColor = [UIColor blackColor];
//        self.title.shadowColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
//        self.title.shadowOffset = CGSizeMake(0.0, 1.0);
//    }
    _buttonbackgroundColor = buttonBackgroundColor;
}

- (UIColor *)buttonBackgroundColor
{
    return _buttonbackgroundColor;
}

@end
