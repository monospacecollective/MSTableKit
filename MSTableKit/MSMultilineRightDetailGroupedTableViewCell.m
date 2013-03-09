//
//  MSMultilineRightDetailGroupedTableViewCell.m
//  Grouped Example
//
//  Created by Eric Horacek on 3/6/13.
//  Copyright (c) 2013 Monospace Ltd. All rights reserved.
//

#import "MSMultilineRightDetailGroupedTableViewCell.h"
#import "NSObject+FirstAppearanceValue.h"

@implementation MSMultilineRightDetailGroupedTableViewCell

#pragma mark - UIView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // Title Sizing
    CGSize maxTitleSize = CGSizeMake(CGRectGetWidth(self.contentView.frame), CGFLOAT_MAX);
    CGSize titleSize = [self.title.text sizeWithFont:self.title.font forWidth:maxTitleSize.width lineBreakMode:self.title.lineBreakMode];
    CGRect titleFrame =  self.title.frame;
    titleFrame.size = titleSize;
    titleFrame.origin.y = 0.0;
    self.title.frame = titleFrame;
    
    // Detail Sizing
    CGSize maxDetailSize = CGSizeMake(CGRectGetWidth(self.contentView.frame) - CGRectGetMaxX(self.title.frame) - self.contentMargin, CGFLOAT_MAX);
    CGSize detailSize = [self.detail.text sizeWithFont:self.detail.font constrainedToSize:maxDetailSize lineBreakMode:self.detail.lineBreakMode];
    CGRect detailFrame =  self.detail.frame;
    detailFrame.size = detailSize;
    detailFrame.origin.y = nearbyintf((CGRectGetHeight(self.contentView.frame) / 2.0) - (CGRectGetHeight(detailFrame) / 2.0));
    detailFrame.origin.x = CGRectGetWidth(self.contentView.frame) - CGRectGetWidth(detailFrame);
    self.detail.frame = detailFrame;
}

#pragma mark - MSGroupedTableViewCell

- (void)initialize
{
    [super initialize];
    self.title.numberOfLines = 0;
    self.detail.numberOfLines = 0;
}

+ (CGFloat)heightForTitle:(NSString *)title detail:(NSString *)detail forWidth:(CGFloat)width
{
    UIEdgeInsets padding = [[self firstAppearanceValueMatchingBlock:^id(id appearance) {
        if (UIEdgeInsetsEqualToEdgeInsets([appearance padding], UIEdgeInsetsZero)) {
            return nil;
        } else {
            return [NSValue valueWithUIEdgeInsets:[appearance padding]];
        }
    }] UIEdgeInsetsValue];
    
    CGFloat contentMargin = [[self firstAppearanceValueMatchingBlock:^id(id appearance) {
        return @([appearance contentMargin]);
    }] floatValue];
    
    CGSize titleSize;
    if (!title || [title isEqualToString:@""]) {
        titleSize = CGSizeZero;
    } else {
        CGSize maxTitleSize = CGSizeMake(width - (padding.left + padding.right), CGFLOAT_MAX);
        UIFont *font = [self firstAppearanceValueMatchingBlock:^id(id appearance) {
            return [appearance titleTextAttributesForState:UIControlStateNormal][UITextAttributeFont];
        }];
        titleSize = [title sizeWithFont:font constrainedToSize:maxTitleSize];
    }
    
    CGSize detailSize;
    if (!detail || [detail isEqualToString:@""]) {
        detailSize = CGSizeZero;
    } else {
        CGSize maxDetailSize = CGSizeMake((width - (padding.left + padding.right + titleSize.width + contentMargin)), CGFLOAT_MAX);
        UIFont *font = [self firstAppearanceValueMatchingBlock:^id(id appearance) {
            return [appearance detailTextAttributesForState:UIControlStateNormal][UITextAttributeFont];
        }];
        detailSize = [detail sizeWithFont:font constrainedToSize:maxDetailSize];
    }
    
    CGFloat height = fmaxf(titleSize.height, detailSize.height);
    
    return (height + (padding.top + padding.bottom));
}

@end
