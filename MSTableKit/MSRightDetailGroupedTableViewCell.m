//
//  MSRightDetailGroupedTableViewCell.m
//  Grouped Example
//
//  Created by Eric Horacek on 1/14/13.
//  Copyright (c) 2013 Monospace Ltd. All rights reserved.
//

#import "MSRightDetailGroupedTableViewCell.h"
#import "UIView+AutoLayout.h"

@implementation MSRightDetailGroupedTableViewCell

#pragma mark - UIView

- (void)updateConstraints
{
    [super updateConstraints];
    
    [self.contentView removeConstraints:self.contentView.constraints];
    
    [self.accessoryView centerInContainerOnAxis:NSLayoutAttributeCenterY];
    [self.detail centerInContainerOnAxis:NSLayoutAttributeCenterY];
    [self.title centerInContainerOnAxis:NSLayoutAttributeCenterY];
    
    if (self.accessoryView) {
        NSDictionary *views = @{ @"title" : self.title, @"detail" : self.detail, @"accessory" : self.accessoryView };
        NSDictionary *metrics = @{ @"contentMargin" : @(self.contentMargin), @"accessoryWidth" : @(CGRectGetWidth(self.accessoryView.frame)) };
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[title]-contentMargin-[detail]-contentMargin-[accessory(==accessoryWidth)]|" options:0 metrics:metrics views:views]];
    } else {
        NSDictionary *views = @{ @"title" : self.title, @"detail" : self.detail };
        NSDictionary *metrics = @{ @"contentMargin" : @(self.contentMargin) };
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[title]-contentMargin-[detail]|" options:0 metrics:metrics views:views]];
    }
}

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//
//    // Title Sizing
//    CGSize maxTitleSize;
//    if (self.accessoryView) {
//        maxTitleSize = CGSizeMake((CGRectGetMinX(self.accessoryView.frame) - self.contentMargin), CGRectGetHeight(self.contentView.frame));
//    } else {
//        maxTitleSize = CGSizeMake(CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame));
//    }
//    CGSize titleSize = [self.title.text sizeWithFont:self.title.font forWidth:maxTitleSize.width lineBreakMode:self.title.lineBreakMode];
//    CGRect titleFrame =  self.title.frame;
//    titleFrame.size = CGSizeMake(titleSize.width, titleSize.height);
//    titleFrame.origin.y = nearbyintf((CGRectGetHeight(self.contentView.frame) / 2.0) - (CGRectGetHeight(titleFrame) / 2.0));
//    self.title.frame = titleFrame;
//    
//    // Detail Sizing
//    CGSize maxDetailSize;
//    if (self.accessoryView) {
//        maxDetailSize = CGSizeMake((CGRectGetMinX(self.accessoryView.frame) - self.contentMargin - CGRectGetMaxX(self.title.frame) - self.contentMargin), CGRectGetHeight(self.contentView.frame));
//    } else {
//        maxDetailSize = CGSizeMake(CGRectGetWidth(self.contentView.frame) - CGRectGetMaxX(self.title.frame) - self.contentMargin, CGRectGetHeight(self.contentView.frame));
//    }
//    CGSize detailSize = [self.title.text sizeWithFont:self.detail.font forWidth:maxDetailSize.width lineBreakMode:self.detail.lineBreakMode];
//    CGRect detailFrame =  self.detail.frame;
//    detailFrame.size = CGSizeMake(maxDetailSize.width, detailSize.height);
//    detailFrame.origin.y = nearbyintf((CGRectGetHeight(self.contentView.frame) / 2.0) - (CGRectGetHeight(detailFrame) / 2.0));
//    detailFrame.origin.x = CGRectGetMaxX(titleFrame) + self.contentMargin;
//    self.detail.frame = detailFrame;
//}

#pragma mark - MSGroupedTableViewCell

- (void)initialize
{
    [super initialize];
    self.detail.textAlignment = NSTextAlignmentRight;
}

@end
