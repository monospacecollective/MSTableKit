//
//  MSSubtitleDetailPlainTableViewCell.m
//  MSTableKit Example
//
//  Created by Eric Horacek on 12/24/12.
//  Copyright (c) 2012 Monospace Ltd. All rights reserved.
//

#import "MSSubtitleDetailPlainTableViewCell.h"

@implementation MSSubtitleDetailPlainTableViewCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // Title Sizing
    CGSize maxTitleSize;
    if (self.accessoryView) {
        maxTitleSize = CGSizeMake((CGRectGetMinX(self.accessoryView.frame) - self.contentMargin), CGRectGetHeight(self.contentView.frame));
    } else {
        maxTitleSize = CGSizeMake(CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame));
    }
    CGSize titleSize = [self.title.text sizeWithFont:self.title.font forWidth:maxTitleSize.width lineBreakMode:self.title.lineBreakMode];
    CGRect titleFrame =  self.title.frame;
    titleFrame.size = CGSizeMake(maxTitleSize.width, titleSize.height);
    titleFrame.origin = CGPointZero;
    self.title.frame = titleFrame;
    
    // Detail Sizing
    CGSize maxDetailSize;
    if (self.accessoryView) {
        maxDetailSize = CGSizeMake((CGRectGetMinX(self.accessoryView.frame) - self.contentMargin), CGRectGetHeight(self.contentView.frame));
    } else {
        maxDetailSize = CGSizeMake(CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame));
    }
    CGSize detailSize = [self.title.text sizeWithFont:self.detail.font forWidth:maxDetailSize.width lineBreakMode:self.detail.lineBreakMode];
    CGRect detailFrame =  self.detail.frame;
    detailFrame.size = CGSizeMake(maxDetailSize.width, detailSize.height);
    detailFrame.origin.y = CGRectGetMaxY(self.title.frame) - 2.0;
    self.detail.frame = detailFrame;}

@end
