//
//  MSTableViewCell.m
//  Plain Example
//
//  Created by Eric Horacek on 12/25/12.
//  Copyright (c) 2012 Monospace Ltd. All rights reserved.
//

#import "MSTableViewCell.h"

//#define LAYOUT_DEBUG

@implementation MSTableViewCell

#pragma mark - UIView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.accessoryType == UITableViewCellAccessoryCheckmark) {
        self.accessoryView.frame = CGRectOffset(self.accessoryView.frame, 0.0, 2.0);
    }
    
#if defined(LAYOUT_DEBUG)
    // Color the background of the labels in the content view red
    for (UIView *subview in self.contentView.subviews) {
        if ([subview isKindOfClass:UILabel.class]) {
            subview.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
        }
    }
#endif
}

#pragma mark - UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)setAccessoryType:(UITableViewCellAccessoryType)accessoryType
{
    [super setAccessoryType:accessoryType];
    switch (accessoryType) {
        case UITableViewCellAccessoryNone: {
            [self.accessoryView removeFromSuperview];
            self.accessoryView = nil;
            break;
        }
        case UITableViewCellAccessoryDisclosureIndicator: {
            self.accessoryTextLabel.font = [UIFont fontWithName:@"Zapf Dingbats" size:18.0];
            self.accessoryTextLabel.text = @"\U0000276F";
            [self.accessoryTextLabel sizeToFit];
            self.accessoryView = self.accessoryTextLabel;
            [self.contentView addSubview:self.accessoryView];
            break;
        }
        case UITableViewCellAccessoryCheckmark: {
            self.accessoryTextLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:32.0];
            self.accessoryTextLabel.text = @"\U00002713 ";
            [self.accessoryTextLabel sizeToFit];
            self.accessoryView = self.accessoryTextLabel;
            [self.contentView addSubview:self.accessoryView];
            break;
        }
        case UITableViewCellAccessoryDetailDisclosureButton: {
            break;
        }
    }
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.detailTextLabel.text = nil;
    self.textLabel.text = nil;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    [self updateBackgroundState:highlighted animated:animated];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    [self updateBackgroundState:selected animated:animated];
}

#pragma mark - MSTableViewCell

- (void)initialize
{
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.detailTextLabel.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryTextLabel = [[UILabel alloc] init];
    self.accessoryTextLabel.backgroundColor = [UIColor clearColor];
    [self configureViews];
}

- (void)configureViews
{
    self.textLabel.textColor = self.titleTextColor;
    self.detailTextLabel.textColor = self.detailTextColor;
    self.accessoryTextLabel.textColor = self.titleTextColor;
}

- (void)updateBackgroundState:(BOOL)darkened animated:(BOOL)animated
{
    [self configureViews];
}

@end
