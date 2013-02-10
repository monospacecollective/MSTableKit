//
//  ERNavigationPaneTableView.h
//  MSTableKit
//
//  Created by Eric Horacek on 6/19/12.
//  Copyright (c) 2012 Monospace Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSTableView.h"

// Cells
#import "MSPlainTableViewCell.h"
#import "MSRightDetailPlainTableViewCell.h"
#import "MSSubtitleDetailPlainTableViewCell.h"

// Headers
#import "MSPlainTableViewHeaderView.h"

@interface MSPlainTableView : MSTableView

@property (nonatomic, strong) UIColor *backgroundColor UI_APPEARANCE_SELECTOR;

@end
