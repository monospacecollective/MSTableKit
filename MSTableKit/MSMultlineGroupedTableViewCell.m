//
//  MSMultlineGroupedTableViewCell.m
//  Grouped Example
//
//  Created by Eric Horacek on 3/4/13.
//  Copyright (c) 2013 Monospace Ltd. All rights reserved.
//

#import "MSMultlineGroupedTableViewCell.h"
#import "NSObject+FirstAppearanceValue.h"

@implementation MSMultlineGroupedTableViewCell

#pragma mark - UIView

- (void)updateConstraints
{
    [super updateConstraints];
    
    NSDictionary *views = @{ @"title" : self.title };
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[title]|" options:0 metrics:nil views:views]];
}

#pragma mark - MSGroupedTableViewCell

- (void)initialize
{
    [super initialize];
    self.title.numberOfLines = 0;
}

+ (void)applyDefaultAppearance
{
    [self.appearance setTitleTextAttributes:@{
        UITextAttributeFont : [UIFont systemFontOfSize:15.0]
     } forState:UIControlStateNormal];
}

#pragma mark - MSMultlineGroupedTableViewCell

+ (CGFloat)heightForText:(NSString *)text forWidth:(CGFloat)width
{
    UIEdgeInsets padding = [[self firstAppearanceValueMatchingBlock:^id(id appearance) {
        if (UIEdgeInsetsEqualToEdgeInsets([appearance padding], UIEdgeInsetsZero)) {
            return nil;
        } else {
            return [NSValue valueWithUIEdgeInsets:[appearance padding]];
        }
    }] UIEdgeInsetsValue];
    
    CGFloat height;
    if (!text || [text isEqualToString:@""]) {
        height = 0;
    } else {
        CGSize maxTitleSize = CGSizeMake(width - (padding.left + padding.right), CGFLOAT_MAX);
        UIFont *font = [self firstAppearanceValueMatchingBlock:^id(id appearance) {
            return [appearance titleTextAttributesForState:UIControlStateNormal][UITextAttributeFont];
        }];
        CGSize titleSize = [text sizeWithFont:font constrainedToSize:maxTitleSize];
        height = titleSize.height;
    }
    return (height + (padding.top + padding.bottom));
}

@end
