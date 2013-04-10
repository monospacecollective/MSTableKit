//
//  MSSubtitleDetailPlainTableViewCell.m
//  MSTableKit Example
//
//  Created by Eric Horacek on 12/24/12.
//  Copyright (c) 2012 Monospace Ltd. All rights reserved.
//

#import "MSSubtitleDetailPlainTableViewCell.h"
#import "UIView+AutoLayout.h"

@implementation MSSubtitleDetailPlainTableViewCell

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

@end
