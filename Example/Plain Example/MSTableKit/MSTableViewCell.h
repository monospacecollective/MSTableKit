//
//  MSTableViewCell.h
//  Plain Example
//
//  Created by Eric Horacek on 12/25/12.
//  Copyright (c) 2012 Monospace Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSTableViewCell : UITableViewCell

@property (nonatomic, strong) UIColor *titleTextColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *detailTextColor UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UILabel *accessoryTextLabel;

- (void)updateBackgroundState:(BOOL)darkened animated:(BOOL)animated;

- (void)initialize;
- (void)configureViews;

@end
