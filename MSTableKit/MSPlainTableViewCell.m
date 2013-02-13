//
//  MSPlainTableViewCell.m
//  MSTableKit
//
//  created by Eric Horacek & Devon Tivona on 1/4/12.
//  Copyright (c) 2012 Monospace Ltd. All rights reserved.
//

#import "MSPlainTableViewCell.h"
#import "MSPlainTableView.h"
#import <QuartzCore/QuartzCore.h>

@implementation MSPlainTableViewCell

#pragma mark - UIView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundGradient.frame = self.bounds;
    
    if ([self.superview isKindOfClass:MSPlainTableView.class]) {        
        MSPlainTableView *enclosingTableView = (MSPlainTableView *)self.superview;
        self.highlightView.frame = CGRectMake(0.0, 0.0, self.bounds.size.width, self.highlightViewHeight);
        NSIndexPath *indexPath = [enclosingTableView indexPathForCell:self];
        BOOL bottomRow = (indexPath.row == ([enclosingTableView numberOfRowsInSection:indexPath.section] - 1));
        if (!bottomRow) {
            self.selectionView.frame = CGRectMake(0.0, 0.0, self.bounds.size.width, self.bounds.size.height - self.shadowViewHeight);
            self.shadowView.frame = CGRectMake(0.0, self.bounds.size.height - self.shadowViewHeight, self.bounds.size.width, self.shadowViewHeight);
            self.shadowView.alpha = 1.0;
        } else {
            self.selectionView.frame = CGRectMake(0.0, 0.0, self.bounds.size.width, self.bounds.size.height);
            self.shadowView.alpha = 0.0;
        }
    }
}

#pragma mark - MSTableViewCell

- (void)initialize
{
    [super initialize];
    self.selectionView = [[UIView alloc] init];
    [self insertSubview:self.selectionView atIndex:0];
    self.selectionView.alpha = 0.0;
    self.highlightView = [[UIView alloc] init];
    [self insertSubview:self.highlightView atIndex:0];
    self.shadowView = [[UIView alloc] init];
    [self insertSubview:self.shadowView atIndex:0];
    [self configureViews];
    
    _shadowViewHeight = 1.0;
    _highlightViewHeight = 1.0;
}

- (void)configureViews
{
    [super configureViews];
    
    self.backgroundColor = [UIColor clearColor];
    
    self.selectionView.backgroundColor = self.selectionColor;
    self.highlightView.backgroundColor = self.etchHighlightColor;
    self.shadowView.backgroundColor = self.etchShadowColor;
    
    if (self.backgroundGradient && ![self.layer.sublayers containsObject:self.backgroundGradient]) {
        if (self.backgroundGradient.superlayer) {
            CAGradientLayer *backgroundGradientCopy = [[CAGradientLayer alloc] init];
            backgroundGradientCopy.colors = [self.backgroundGradient.colors copy];
            backgroundGradientCopy.locations = [self.backgroundGradient.locations copy];
            backgroundGradientCopy.type = [self.backgroundGradient.type copy];
            backgroundGradientCopy.startPoint = self.backgroundGradient.startPoint;
            backgroundGradientCopy.endPoint = self.backgroundGradient.endPoint;
            self.backgroundGradient = backgroundGradientCopy;
        }
        [self.layer insertSublayer:self.backgroundGradient atIndex:0];
    }
}

- (void)updateBackgroundState:(BOOL)darkened animated:(BOOL)animated
{
    [super updateBackgroundState:darkened animated:animated];
    
    void(^updateBackgroundState)() = ^() {
        self.selectionView.alpha = (darkened ? 1.0 : 0.0);
        self.highlightView.alpha = (darkened ? 0.0 : 1.0);
    };
    if (animated) {
        [UIView animateWithDuration:0.3 animations:updateBackgroundState];
    } else {
        updateBackgroundState();
    }
}

@end
