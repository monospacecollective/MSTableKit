//
//  MSGroupedTableViewHeaderView.m
//  Grouped Example
//
//  Created by Eric Horacek on 1/14/13.
//  Copyright (c) 2013 Monospace Ltd. All rights reserved.
//

#import "MSGroupedTableViewHeaderView.h"

@interface MSGroupedTableViewHeaderView ()

- (void)initialize;

@end

@implementation MSGroupedTableViewHeaderView

#pragma mark - UIView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

#pragma mark - MSGroupedTableViewHeaderView

- (void)initialize
{
    self.textLabel.textColor = [UIColor blackColor];
}

@end
