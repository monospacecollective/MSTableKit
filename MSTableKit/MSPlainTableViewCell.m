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

@synthesize selectionColor = _selectionColor;
@synthesize etchHighlightColor = _etchHighlightColor;
@synthesize etchShadowColor = _etchShadowColor;
@synthesize backgroundGradient = _backgroundGradient;
@synthesize highlightViewHeight = _highlightViewHeight;
@synthesize shadowViewHeight = _shadowViewHeight;

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

#pragma mark - Setters

- (UIColor *)selectionColor
{
    return _selectionColor;
}

- (UIColor *)etchHighlightColor
{
    return _etchHighlightColor;
}

- (UIColor *)etchShadowColor
{
    return _etchShadowColor;
}

- (CAGradientLayer *)backgroundGradient
{
    return _backgroundGradient;
}


- (CGFloat)highlightViewHeight
{
    return _highlightViewHeight;
}

- (CGFloat)shadowViewHeight
{
    return _shadowViewHeight;
}

#pragma mark - Getters

- (void)setSelectionColor:(UIColor *)selectionColor
{
    _selectionColor = selectionColor;
    [self configureViews];
    [self setNeedsDisplay];
}

- (void)setEtchHighlightColor:(UIColor *)etchHighlightColor
{
    _etchHighlightColor = etchHighlightColor;
    [self configureViews];
    [self setNeedsDisplay];
}

- (void)setEtchShadowColor:(UIColor *)etchShadowColor
{
    _etchShadowColor = etchShadowColor;
    [self configureViews];
    [self setNeedsDisplay];
}

- (void)setBackgroundGradient:(CAGradientLayer *)backgroundGradient
{
    _backgroundGradient = backgroundGradient;
    [self configureViews];
    [self setNeedsDisplay];
}

- (void)setHighlightViewHeight:(CGFloat)highlightViewHeight
{
    _highlightViewHeight = highlightViewHeight;
    [self configureViews];
    [self setNeedsDisplay];
}

- (void)setShadowViewHeight:(CGFloat)shadowViewHeight
{
    _shadowViewHeight = shadowViewHeight;
    [self configureViews];
    [self setNeedsDisplay];
}

@end
