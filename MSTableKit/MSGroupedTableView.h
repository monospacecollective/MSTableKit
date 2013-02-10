//
//  MSGroupedTableView.h
//  Grouped Example
//
//  Created by Eric Horacek on 1/13/13.
//  Copyright (c) 2013 Monospace Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSTableView.h"

// Cells
#import "MSGroupedTableViewCell.h"
#import "MSRightDetailGroupedTableViewCell.h"
#import "MSSubtitleDetailGroupedTableViewCell.h"
#import "MSButtonGroupedTableViewCell.h"

// Headers
#import "MSGroupedTableViewHeaderView.h"
#import "MSGroupedTableViewFooterView.h"

@interface MSGroupedTableView : MSTableView

@property (nonatomic, strong) UIColor *backgroundColor UI_APPEARANCE_SELECTOR;

@end
