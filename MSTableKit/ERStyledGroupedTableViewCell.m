//
//  ERStyledGroupedTableViewCell.m
//  Erudio
//
//  Created by Devon Tivona on 1/22/12.
//  Copyright (c) 2012 Monospace Ltd. All rights reserved.
//

#import "ERStyledGroupedTableViewCell.h"
#import "ERStyledGroupedTableBackgroundView.h"
#import "SSSwitch.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+ViewHierarchyAction.h"
#import "ERCellNibManager.h"
#import "ERStyleManager.h"

NSInteger const ERStyledGroupedCellViewTagTextField = 101;
NSInteger const ERStyledGroupedCellViewTagSlider = 102;
NSInteger const ERStyledGroupedCellViewTagTextView = 103;

//#define LAYOUT_DEBUG

@interface ERStyledGroupedTableViewCell ()

- (void)setBackgroundState:(BOOL)darkened animated:(BOOL)animated;

@end

@implementation ERStyledGroupedTableViewCell

@dynamic shouldDrawSelection;
@dynamic fillColor;
@dynamic borderColor;
@dynamic highlightColor;

@dynamic toggleSwitch;
@dynamic textField;
@dynamic textView;
@dynamic slider;

- (void)layoutSubviews
{
#ifdef LAYOUT_DEBUG
    // Layout debug Mode, colors views
    [self subviewHierarchyAction:^(UIView *view) {
        if ([view isKindOfClass:UILabel.class]) {
            [view setBackgroundColor:[[UIColor redColor] colorWithAlphaComponent:0.5]];
        }
        if ([view isKindOfClass:UIImageView.class]) {
            [view setBackgroundColor:[[UIColor blueColor] colorWithAlphaComponent:0.5]];
        }
    }]; 
#endif
    
    // Don't call super's layoutSubviews! We handle everything. We gots it.
    CGFloat backgroundInset = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 20.0 : 10.0;
    self.backgroundView.frame = CGRectInset(self.bounds, backgroundInset, 0.0);
    
    // Padding between elements
    CGFloat contentPadding = 9.0;
    
    // Inset from sides to edge elements
    CGFloat contentInset = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? (backgroundInset + 14.0) : (backgroundInset + 11.0);

    // Image View
    if (self.imageView && self.imageView.image) {
        self.imageView.frame = CGRectMake((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? (backgroundInset + 9.0) : (backgroundInset + 8.0), ceilf((CGRectGetHeight(self.frame) - self.imageView.image.size.height) / 2.0), self.imageView.image.size.width, self.imageView.image.size.height);
    }
    
    // Text Label
    [self.textLabel sizeToFit];
    CGRect textLabelFrame = self.textLabel.frame;
    if (self.imageView && self.imageView.image) {
        textLabelFrame.origin.x = CGRectGetMaxX(self.imageView.frame) + contentPadding;
    } else {
        textLabelFrame.origin.x = contentInset;
    }
    
    // Center of the cell for a vertically centered label
    CGFloat labelCenter = floorf((self.bounds.size.height / 2.0) - (textLabelFrame.size.height / 2.0)) - 1.0;
    textLabelFrame.origin.y = labelCenter;
    
    // Detail Subtitle
    if ([self.reuseIdentifier isEqualToString:ERStyledGroupedCellReuseIdentifierDetail]) {
        // If there's nothing in the detail label, center the text label
        if (!self.detailTextLabel || !self.detailTextLabel.text || [self.detailTextLabel.text isEqualToString:@""]) {
            textLabelFrame.origin.y = labelCenter;
        } else {
            textLabelFrame.origin.y = 2.0;   
        }
    } else {
        textLabelFrame.origin.y = labelCenter;        
    }
    
    CGFloat rightInset = self.accessoryView ? (contentInset + contentPadding + CGRectGetWidth(self.accessoryView.frame)) : contentInset;
    textLabelFrame.size.width = self.bounds.size.width - rightInset - CGRectGetMinX(textLabelFrame);
    self.textLabel.frame = textLabelFrame;
    
    // Detail Subtitle
    if ([self.reuseIdentifier isEqualToString:ERStyledGroupedCellReuseIdentifierDetail]) {

        CGRect detailLabelFrame = self.detailTextLabel.frame;
        detailLabelFrame.origin.x = contentInset;
        detailLabelFrame.origin.y = 22.0;
        detailLabelFrame.size.width = self.bounds.size.width - rightInset - CGRectGetMinX(detailLabelFrame);
        self.detailTextLabel.frame = detailLabelFrame;
        
    } 
    // Detail Right
    else if ([self.reuseIdentifier isEqualToString:ERStyledGroupedCellReuseIdentifierDetailRight]) {
        
        [self.textLabel sizeToFit];
        
        CGRect detailLabelFrame = self.detailTextLabel.frame;
        detailLabelFrame.origin.x = CGRectGetMaxX(self.textLabel.frame) + contentPadding;
        detailLabelFrame.origin.y = labelCenter;
        detailLabelFrame.size.width = self.bounds.size.width - rightInset - CGRectGetMinX(detailLabelFrame);
        self.detailTextLabel.frame = detailLabelFrame;
    }

    // Accessory View
    if (self.accessoryView) {
        
        CGFloat accessoryX = floorf(self.bounds.size.width - self.accessoryView.frame.size.width - contentInset);
        CGFloat accessoryY = floorf((self.bounds.size.height / 2.0) - (self.self.accessoryView.frame.size.height / 2.0));
        self.accessoryView.frame = CGRectMake(accessoryX,
                                              accessoryY,
                                              self.accessoryView.frame.size.width,
                                              self.accessoryView.frame.size.height);
    }
    
    // Text Field
    if ([self.reuseIdentifier isEqualToString:ERStyledGroupedCellReuseIdentifierTextField]) {
        
        UITextField *textField = (UITextField *)[self viewWithTag:ERStyledGroupedCellViewTagTextField];
        
        CGRect textFieldFrame = textField.frame;
        textFieldFrame.origin.x = contentInset;
        textFieldFrame.origin.y = floorf((self.bounds.size.height / 2.0) - (textFieldFrame.size.height / 2.0));
        textFieldFrame.size.width = self.bounds.size.width - rightInset - CGRectGetMinX(textLabelFrame);
        textField.frame = textFieldFrame;
    }
    
    // Text View
    if ([self.reuseIdentifier isEqualToString:ERStyledGroupedCellReuseIdentifierTextView]) {
        
        CGFloat cellHeight = [self.class cellHeightForTextViewWithText:self.textView.text cellWidth:CGRectGetWidth(self.frame)];
        
        CGRect cellFrame = self.frame;
        cellFrame.size.height = cellHeight;
        self.frame = cellFrame;
        
        // FUCK YO COUCH this is required to have touches forward to the entirety of the textView (otherwise only the top 44px can do so)
        self.contentView.frame = self.bounds;
        
        CGSize textSize = [self.class textSizeForTextViewWithText:self.textView.text cellWidth:CGRectGetWidth(self.frame)];
        
        CGRect textViewFrame = self.textView.frame;
        textViewFrame.size = textSize;
        textViewFrame.origin.x = contentInset;
        textViewFrame.origin.y = floorf((self.bounds.size.height / 2.0) - (textViewFrame.size.height / 2.0));
        self.textView.frame = textViewFrame;
    }
    
    // Right Fixed
    if ([self.reuseIdentifier isEqualToString:ERStyledGroupedCellReuseIdentifierDetailRightFixed]) {
        
        // Sizing
        [self.detailTextLabel sizeToFit];  
        CGRect tempDetailTextLabelFrame = self.detailTextLabel.frame;
        tempDetailTextLabelFrame.origin.x = CGRectGetMaxX(self.frame) - rightInset - tempDetailTextLabelFrame.size.width;
        tempDetailTextLabelFrame.origin.y = labelCenter;
        self.detailTextLabel.frame = tempDetailTextLabelFrame;
        
        [self.textLabel sizeToFit];
        CGRect tempTextLabelFrame = self.textLabel.frame;
        tempTextLabelFrame.origin.x = contentInset;
        tempTextLabelFrame.origin.y = labelCenter;
        tempTextLabelFrame.size.width = tempDetailTextLabelFrame.origin.x - tempTextLabelFrame.origin.x - 5.0;
        self.textLabel.frame = tempTextLabelFrame;
    }
    
    // Slider Cell
    if ([self.reuseIdentifier isEqualToString:ERStyledGroupedCellReuseIdentifierSlider]) {
        
        CGRect sliderRect = self.slider.frame;
        sliderRect.origin.x = contentInset;
        sliderRect.size.width = self.frame.size.width - (contentInset * 2.0);
        self.slider.frame = sliderRect;
        self.slider.center = CGPointMake(self.slider.center.x, (self.bounds.size.height / 2.0));
    }
    
    // If we're a top or single cell, move elements 1 px down
    CustomCellBackgroundViewPosition position = [(ERStyledGroupedTableBackgroundView *)self.backgroundView position];
    if (position == CustomCellBackgroundViewPositionTop ||
        position == CustomCellBackgroundViewPositionSingle) {
        
        CGFloat offset = 1.0;
        self.textLabel.frame = CGRectOffset(self.textLabel.frame, 0.0, offset);
        self.detailTextLabel.frame = CGRectOffset(self.detailTextLabel.frame, 0.0, offset);
//        self.textField.frame = CGRectOffset(self.textField.frame, 0.0, offset);
//        self.slider.frame = CGRectOffset(self.slider.frame, 0.0, -1.0);
    }
}

- (void)setAccessoryType:(UITableViewCellAccessoryType)accessoryType
{
    if (accessoryType == UITableViewCellAccessoryNone) {
        [self.accessoryView removeFromSuperview];
        self.accessoryView = nil;
    } else if (accessoryType == UITableViewCellAccessoryDisclosureIndicator) {
        self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ERStyledGroupedTableCellDisclosureArrow"]];
        [self addSubview:self.accessoryView];
    }
}

- (void)awakeFromNib 
{    
    // Calls our version of the method
    [self setAccessoryType:self.accessoryType];
    
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.textLabel.opaque = NO;
    
    self.detailTextLabel.backgroundColor = [UIColor clearColor];
    self.detailTextLabel.opaque = NO;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
    
    // Instantiate background view
    
    self.shouldDrawSelection = YES;
    
    ERStyledGroupedTableBackgroundView *backgroundView = [[ERStyledGroupedTableBackgroundView alloc] initWithFrame:CGRectZero];
    self.backgroundView = backgroundView;
    
    // Delete
    if ([self.reuseIdentifier isEqualToString:ERStyledGroupedCellReuseIdentifierDelete]) {
        backgroundView.fillColor = [UIColor colorWithRed:.69 green:.13 blue:.16 alpha:1.0];
        backgroundView.borderColor = [UIColor colorWithRed:.47 green:.02 blue:.01 alpha:1.0];
        backgroundView.shadowColor = [UIColor colorWithWhite:1.0 alpha:1.0];
        backgroundView.innerShadowColor = [UIColor colorWithWhite:1.0 alpha:0.25];
        self.textLabel.shadowColor = [UIColor colorWithRed:.47 green:.02 blue:.01 alpha:1.0];
    } else {
        backgroundView.borderColor = [UIColor colorWithWhite:0.7 alpha:1.0];
        backgroundView.shadowColor = [UIColor colorWithWhite:1.0 alpha:1.0];
        backgroundView.fillColor = [UIColor colorWithWhite:0.0 alpha:0.1];
        backgroundView.innerShadowColor = [UIColor colorWithWhite:0.0 alpha:0.05];
    }
    
    // Toggle
    if ([self.reuseIdentifier isEqualToString:ERStyledGroupedCellReuseIdentifierToggle]) {

        SSSwitch *toggleSwitch = [[SSSwitch alloc] initWithFrame:CGRectMake(0.0, 0.0, 84.0, 27.0)];
        
        toggleSwitch.backgroundColor = [UIColor clearColor];
        
        UIEdgeInsets buttonEdgeInsets = UIEdgeInsetsMake(0.0, 4.0, 0.0, 4.0);
        toggleSwitch.onBackgroundImageView.image = [[UIImage imageNamed:@"ERSwitchTrack"] resizableImageWithCapInsets:buttonEdgeInsets];
        toggleSwitch.offBackgroundImageView.image = [[UIImage imageNamed:@"ERSwitchTrackLight"] resizableImageWithCapInsets:buttonEdgeInsets];
        
        self.accessoryType = UITableViewCellAccessoryNone;
        self.accessoryView = toggleSwitch;
        [self addSubview:toggleSwitch];
    }
    
    // Text View
    if ([self.reuseIdentifier isEqualToString:ERStyledGroupedCellReuseIdentifierTextView]) {
        
        self.textView.backgroundColor = [UIColor clearColor];
#if defined(LAYOUT_DEBUG)
        self.textView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
#endif
        self.textView.font = [UIFont systemFontOfSize:17.0];
        self.textView.contentInset = UIEdgeInsetsMake(-8.0, -8.0, 0.0, 0.0);
        self.textView.scrollEnabled = NO;
        self.textView.layer.masksToBounds = NO;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            UIToolbar* doneAccessoryToolbar = [[ERStyleManager sharedManager] doneAccessoryToolbarWithTarget:self.textView action:@selector(resignFirstResponder)];
            self.textView.inputAccessoryView = doneAccessoryToolbar;
        }
    }
    
    // Fixed-size right
    if ([self.reuseIdentifier isEqualToString:ERStyledGroupedCellReuseIdentifierDetailRightFixed]) {
        self.textLabel.adjustsFontSizeToFitWidth = NO;
        self.detailTextLabel.adjustsFontSizeToFitWidth = NO;
    }
    
    if ([self.reuseIdentifier isEqualToString:ERStyledGroupedCellReuseIdentifierDetailRight]) {
        self.detailTextLabel.adjustsFontSizeToFitWidth = YES;
        self.detailTextLabel.minimumFontSize = 13.0;
    }
    
    if ([self.reuseIdentifier isEqualToString:ERStyledGroupedCellReuseIdentifierBasic]) {
        self.textLabel.adjustsFontSizeToFitWidth = YES;
        self.textLabel.minimumFontSize = 14.0;
    }
    
    // Slider
    if ([self.reuseIdentifier isEqualToString:ERStyledGroupedCellReuseIdentifierSlider]) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.accessoryView = self.slider;
        [self addSubview:self.slider];
    }
    
    [super awakeFromNib];
}

- (void)setStyleForRow:(NSInteger)row rowCount:(NSInteger)rowCount
{
    ERStyledGroupedTableBackgroundView *backgroundView = (ERStyledGroupedTableBackgroundView *)self.backgroundView;
    
    if(row == 0 && row == rowCount - 1)
    {
        backgroundView.position = CustomCellBackgroundViewPositionSingle;
    }
    else if (row == 0) 
    {
        backgroundView.position = CustomCellBackgroundViewPositionTop;
    } 
    else if (row != rowCount - 1) 
    {
        backgroundView.position = CustomCellBackgroundViewPositionMiddle;
    } 
    else 
    {
        backgroundView.position = CustomCellBackgroundViewPositionBottom;
    }
    
    if ((backgroundView.position == CustomCellBackgroundViewPositionSingle) ||
        (backgroundView.position == CustomCellBackgroundViewPositionBottom)) {
        
    }
    
    [backgroundView setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [self setBackgroundState:selected animated:animated];
    [super setSelected:selected animated:animated];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [self setBackgroundState:highlighted animated:animated];
    [super setHighlighted:highlighted animated:animated];
}

- (void)prepareForReuse
{
    ERStyledGroupedTableBackgroundView *backgroundView = (ERStyledGroupedTableBackgroundView *)self.backgroundView;
    [backgroundView setNeedsDisplay];
    
    self.shouldDrawSelection = YES;
    self.imageView.image = nil;
    
    // We don't want for it to make delete cells the incorrect color
    if (![self.reuseIdentifier isEqualToString:ERStyledGroupedCellReuseIdentifierDelete]) {
        self.fillColor = nil;
    }
    
    if ([self.reuseIdentifier isEqualToString:ERStyledGroupedCellReuseIdentifierDetailRight] ||
        [self.reuseIdentifier isEqualToString:ERStyledGroupedCellReuseIdentifierDetail] ||
        [self.reuseIdentifier isEqualToString:ERStyledGroupedCellReuseIdentifierBasic]) {
        self.textLabel.textColor = [UIColor blackColor];
    }
    
    // Remove all targets on our target switch
    if ([self.reuseIdentifier isEqualToString:ERStyledGroupedCellReuseIdentifierToggle]) {
        [self.toggleSwitch removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    }
    
    [super prepareForReuse];
}

#pragma mark - Accessors

- (UIColor *)fillColor
{
    ERStyledGroupedTableBackgroundView *backgroundView = (ERStyledGroupedTableBackgroundView *)self.backgroundView;
    return backgroundView.fillColor;
}

- (void)setFillColor:(UIColor *)fillColor
{
    ERStyledGroupedTableBackgroundView *backgroundView = (ERStyledGroupedTableBackgroundView *)self.backgroundView;
    
    if ((fillColor != nil) &&
        ![fillColor isEqual:backgroundView.fillColor]) {
        backgroundView.fillColor = fillColor;        
    } else if (fillColor == nil) {
        backgroundView.fillColor = [UIColor colorWithWhite:0.0 alpha:0.1];
    }
}

- (UIColor *)borderColor
{
    ERStyledGroupedTableBackgroundView *backgroundView = (ERStyledGroupedTableBackgroundView *)self.backgroundView;
    return backgroundView.borderColor;
}

- (void)setBorderColor:(UIColor *)aBorderColor
{
    ERStyledGroupedTableBackgroundView *backgroundView = (ERStyledGroupedTableBackgroundView *)self.backgroundView;
    
    if (![aBorderColor isEqual:backgroundView.borderColor]) {
        
        backgroundView.borderColor = aBorderColor;        
        
    } else if (aBorderColor == nil) {
        
        backgroundView.borderColor = [UIColor colorWithWhite:0.7 alpha:1.0];
    }
}

- (UIColor *)highlightColor
{
    ERStyledGroupedTableBackgroundView *backgroundView = (ERStyledGroupedTableBackgroundView *)self.backgroundView;
    return backgroundView.shadowColor;
}

- (void)setHighlightColor:(UIColor *)aHighlightColor
{
    ERStyledGroupedTableBackgroundView *backgroundView = (ERStyledGroupedTableBackgroundView *)self.backgroundView;
    
    if (![aHighlightColor isEqual:backgroundView.shadowColor]) {
        
        backgroundView.shadowColor = aHighlightColor;        
        
    } else if (aHighlightColor == nil) {
        
        backgroundView.shadowColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    }
}

- (BOOL)shouldDrawSelection
{
    return _shouldDrawSelection;
}

- (void)setShouldDrawSelection:(BOOL)flag
{
    if (_shouldDrawSelection != flag) {
        
        ERStyledGroupedTableBackgroundView *backgroundView = (ERStyledGroupedTableBackgroundView *)self.backgroundView;
        [backgroundView setNeedsDisplay];
        
        _shouldDrawSelection = flag;
    }
}

- (SSSwitch *)toggleSwitch
{
    if ([self.accessoryView isKindOfClass:SSSwitch.class]) {
        return (SSSwitch *)self.accessoryView;
    } else {
        return nil;
    }
}

- (UITextField *)textField
{
    UITextField *textField = (UITextField *)[self viewWithTag:ERStyledGroupedCellViewTagTextField];
    if (textField && [textField isKindOfClass:UITextField.class]) {
        return textField;
    } else {
        return nil;
    }
}

- (UITextView *)textView
{
    UITextView *textView = (UITextView *)[self viewWithTag:ERStyledGroupedCellViewTagTextView];
    if (textView && [textView isKindOfClass:UITextView.class]) {
        return textView;
    } else {
        return nil;
    }
}

- (UISlider *)slider
{
    UISlider *slider = (UISlider *)[self viewWithTag:ERStyledGroupedCellViewTagSlider];
    if (slider && [slider isKindOfClass:UISlider.class]) {
        return slider;
    } else {
        return nil;
    }
}

#pragma mark - ERStyledGroupedTableViewCell Methods

- (void)setBackgroundState:(BOOL)darkened animated:(BOOL)animated
{
    [self.backgroundView setNeedsDisplay];
    
    void (^toggleBackgroundState)(void);
    
    // If the cell is in a "pressed" state
    if (darkened) {
        toggleBackgroundState = ^{
            if ([self.reuseIdentifier isEqualToString:ERStyledGroupedCellReuseIdentifierDelete]) {
                self.textLabel.textColor = [UIColor lightGrayColor];
            }        
        };
    }
    // If the cell is in a standard state
    else {
        toggleBackgroundState = ^{
            if ([self.reuseIdentifier isEqualToString:ERStyledGroupedCellReuseIdentifierDelete]) {
                self.textLabel.textColor = [UIColor whiteColor];
            }        
        };
    }
    
    if (animated) {
        [UIView animateWithDuration:0.3 animations:toggleBackgroundState];
    } else {
        toggleBackgroundState();
    }
}

#pragma mark Layout

+ (CGFloat)cellHeight
{
    return 44.0;
}

+ (CGFloat)cellHeightForTextViewWithText:(NSString *)text cellWidth:(CGFloat)cellWidth
{
    CGFloat textHeight = [self textSizeForTextViewWithText:text cellWidth:cellWidth].height;
    // Padding
    CGFloat cellHeight = textHeight + (10.0 * 2.0);
    // If it's less than our default cell height, just return it
    return (cellHeight <= self.cellHeight) ? self.cellHeight : cellHeight;
}

+ (CGSize)textSizeForTextViewWithText:(NSString *)text cellWidth:(CGFloat)cellWidth;
{
    CGFloat backgroundInset = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 20.0 : 10.0;
    CGFloat contentInset = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? (backgroundInset + 14.0) : (backgroundInset + 11.0);
    
    CGFloat contentWidth = cellWidth - (contentInset * 2.0);
    UIFont *font = [UIFont systemFontOfSize:17.0];
    
    // If text is non-nil, calculate its width and height using our content size
    CGSize textSize = CGSizeZero;
    if (text != nil) {
        // Text size width adjustment required to get character wrapping correct
        CGFloat widthAdjustment = 16.0;
        textSize = [text sizeWithFont:font
                    constrainedToSize:CGSizeMake((contentWidth - widthAdjustment), CGFLOAT_MAX)
                        lineBreakMode:UILineBreakModeWordWrap];
    }
    
    // Calculate the height of a single line - this is our minimum height
    CGSize singleLineSize = [@"x" sizeWithFont:font
                                      forWidth:CGFLOAT_MAX
                                 lineBreakMode:UILineBreakModeWordWrap];
    
    // Weird bug with the sizeWithFont... if it ends in a newline, it doesn't count it as a line, so add that height if it does
    if ((text.length != 0) && [[text substringFromIndex:(text.length - 1)] isEqualToString:@"\n"]) {
        textSize.height += singleLineSize.height;
    }
    
    return CGSizeMake(contentWidth, (textSize.height <= singleLineSize.height) ? singleLineSize.height : textSize.height);
}

+ (void)resizeTableView:(UITableView *)tableView forTextView:(UITextView *)textView inCellAtIndexPath:(NSIndexPath *)indexPath
{
    // Grab the index path for this cell
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        CGFloat cellHeight = [ERStyledGroupedTableViewCell cellHeightForTextViewWithText:textView.text cellWidth:CGRectGetWidth(tableView.frame)];
        if (CGRectGetHeight(cell.frame) != cellHeight) {
            [cell setNeedsLayout];
            [cell.backgroundView setNeedsDisplay];
            
            // Reload the heights of the table view without reloading data
            [UIView setAnimationsEnabled:NO];
            // If there's rows below us, reload them
            if ([tableView numberOfSections] > (indexPath.section + 1)) {
                NSUInteger nextIndex = (indexPath.section + 1);
                NSRange reloadRange = NSMakeRange(nextIndex, [tableView numberOfSections] - nextIndex);
                [tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:reloadRange] withRowAnimation:UITableViewRowAnimationNone];
            }
            // Otherwise, just do a begin/end block to update heights
            else {
                [tableView beginUpdates];
                [tableView endUpdates];
            }
            [UIView setAnimationsEnabled:YES];
        }
    }
}

@end
