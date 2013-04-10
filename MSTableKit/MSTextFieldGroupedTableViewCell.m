//
//  MSTextFieldGroupedTableViewCell.m
//  Pods
//
//  Created by Eric Horacek on 4/5/13.
//
//

#import "MSTextFieldGroupedTableViewCell.h"
#import "UIView+AutoLayout.h"

@implementation MSTextFieldGroupedTableViewCell

#pragma mark - UIView

- (void)updateConstraints
{
    [super updateConstraints];
    
    [self.contentView removeConstraints:self.contentView.constraints];

    [self.textField centerInContainerOnAxis:NSLayoutAttributeCenterY];
    if (self.accessoryView) {
        [self.accessoryView centerInContainerOnAxis:NSLayoutAttributeCenterY];
        NSDictionary *views = @{ @"textField" : self.textField, @"accessory" : self.accessoryView };
        NSDictionary *metrics = @{ @"contentMargin" : @(self.contentMargin), @"accessoryWidth" : @(CGRectGetWidth(self.accessoryView.frame)) };
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[textField]-contentMargin-[accessory(==accessoryWidth)]|" options:0 metrics:metrics views:views]];
    } else {
        NSDictionary *views = @{ @"textField" : self.textField };
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[textField]|" options:0 metrics:nil views:views]];
    }
}

#pragma mark - MSTableCell

- (void)initialize
{
    [super initialize];
    
    self.textField = [[UITextField alloc] init];
    self.textField.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:self.textField];
}

@end
