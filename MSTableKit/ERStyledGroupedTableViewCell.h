//
//  ERStyledGroupedTableViewCell.h
//  Erudio
//
//  Created by Devon Tivona on 1/22/12.
//  Copyright (c) 2012 Monospace Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSSwitch.h"
#import "ERStyledTextView.h"

@interface ERStyledGroupedTableViewCell : UITableViewCell {

@private
    BOOL _shouldDrawSelection;
}

// Configures the rounded style of a grouped table view cell (top/middle/bottom/single)
- (void)setStyleForRow:(NSInteger)row rowCount:(NSInteger)rowCount;

@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, strong) UIColor *highlightColor;
@property (nonatomic, assign) BOOL shouldDrawSelection;

@property (nonatomic, readonly) SSSwitch *toggleSwitch;
@property (nonatomic, readonly) UITextField *textField;
@property (nonatomic, readonly) ERStyledTextView *textView;
@property (nonatomic, readonly) UISlider *slider;

+ (CGFloat)cellHeight;

+ (CGFloat)cellHeightForTextViewWithText:(NSString *)text cellWidth:(CGFloat)cellWidth;
+ (CGSize)textSizeForTextViewWithText:(NSString *)text cellWidth:(CGFloat)cellWidth;
+ (void)resizeTableView:(UITableView *)tableView forTextView:(UITextView *)textView inCellAtIndexPath:(NSIndexPath *)indexPath;

@end
