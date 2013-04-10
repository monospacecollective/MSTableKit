//
//  MSSubdetailDetailGroupedTableViewCell.m
//  Grouped Example
//
//  Created by Eric Horacek on 1/14/13.
//  Copyright (c) 2013 Monospace Ltd. All rights reserved.
//

#import "MSSubtitleDetailGroupedTableViewCell.h"
#import "UIView+AutoLayout.h"

@implementation MSSubtitleDetailGroupedTableViewCell

- (void)updateConstraints
{
    [super updateConstraints];
    
    [self.contentView removeConstraints:self.contentView.constraints];
    
    if (self.accessoryView) {
        [self.accessoryView centerInContainerOnAxis:NSLayoutAttributeCenterY];
        NSDictionary *views = @{ @"title" : self.title, @"detail" : self.detail, @"accessory" : self.accessoryView };
        NSDictionary *metrics = @{ @"contentMargin" : @(self.contentMargin), @"accessoryWidth" : @(CGRectGetWidth(self.accessoryView.frame)) };
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[title]-contentMargin-[accessory(==accessoryWidth)]|" options:0 metrics:metrics views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[detail]-contentMargin-[accessory(==accessoryWidth)]|" options:0 metrics:metrics views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=0)-[title]-(>=0)-[detail]-(>=0)-|" options:0 metrics:nil views:views]];
    } else {
        NSDictionary *views = @{ @"title" : self.title, @"detail" : self.detail };
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[title]|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[detail]|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=0)-[title]-(>=0)-[detail]-(>=0)-|" options:0 metrics:nil views:views]];
    }
}

+ (void)applyDefaultAppearance
{
    [super applyDefaultAppearance];
    [self.appearance setDetailTextAttributes:@{ UITextAttributeFont : [UIFont systemFontOfSize:15.0] } forState:UIControlStateNormal];
    CGFloat horizontalPadding = 20.0;
    CGFloat verticalPadding = 2.0;
    [self.appearance setPadding:UIEdgeInsetsMake(verticalPadding, horizontalPadding, verticalPadding, horizontalPadding)];
}


@end
