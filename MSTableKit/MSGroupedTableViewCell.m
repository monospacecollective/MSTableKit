//
//  MSGroupedTableViewCell.m
//  Grouped Example
//
//  Created by Eric Horacek on 1/12/13.
//  Copyright (c) 2013 Monospace Ltd. All rights reserved.
//

#import "MSGroupedTableViewCell.h"

@implementation MSGroupedTableViewCell

#pragma mark - MSTableCell

- (void)initialize
{
    [super initialize];
    self.groupedCellBackgroundView = [[MSGroupedCellBackgroundView alloc] init];
    self.backgroundView = self.groupedCellBackgroundView;
}

+ (void)applyDefaultAppearance
{
    CGFloat horizontalPadding = 20.0;
    CGFloat verticalPadding = 10.0;
//    [self.appearance setPadding:UIEdgeInsetsMake(verticalPadding, horizontalPadding, verticalPadding, horizontalPadding)];
    [self.appearance setBackgroundViewPadding:UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0)];
}

@end
