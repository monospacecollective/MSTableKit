//
//  MSGroupedTableViewCell.h
//  Grouped Example
//
//  Created by Eric Horacek on 1/12/13.
//  Copyright (c) 2013 Monospace Ltd. All rights reserved.
//

#import "MSTableCell.h"
#import "MSGroupedCellBackgroundView.h"

@interface MSGroupedTableViewCell : MSTableCell

@property (nonatomic, strong) MSGroupedCellBackgroundView *groupedCellBackgroundView;

@end
