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
    self.groupedCellBackgroundView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.backgroundView = self.groupedCellBackgroundView;
}

+ (void)applyDefaultAppearance
{
    [super applyDefaultAppearance];
    [self.appearance setPadding:UIEdgeInsetsMake(0.0, 20.0, 0.0, 20.0)];
    [self.appearance setBackgroundViewPadding:UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0)];
}

@end
