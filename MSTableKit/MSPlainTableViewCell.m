//
//  MSPlainTableViewCell.m
//  MSTableKit
//
//  created by Eric Horacek & Devon Tivona on 1/4/12.
//  Copyright (c) 2012 Monospace Ltd. All rights reserved.
//

#import "MSPlainTableViewCell.h"
#import "MSPlainSelectedBackground.h"
#import <QuartzCore/QuartzCore.h>

@interface MSPlainTableViewCell ()

@property (nonatomic, strong) UIView *selectionView;

@end

@implementation MSPlainTableViewCell

@synthesize backgroundGradient = _backgroundGradient;

#pragma mark - UIView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundGradient.frame = self.bounds;
    self.selectionView.frame = self.bounds;
}

#pragma mark - MSTableCell

- (void)initialize
{
    [super initialize];
    
    self.selectedBackgroundView = [[MSPlainSelectedBackground alloc] init];
    
    [self configureViews];
}

- (void)configureViews
{
    [super configureViews];
    
    self.backgroundColor = [UIColor clearColor];
    
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

#pragma mark - Setters

- (CAGradientLayer *)backgroundGradient
{
    return _backgroundGradient;
}

#pragma mark - Getters

- (void)setBackgroundGradient:(CAGradientLayer *)backgroundGradient
{
    _backgroundGradient = backgroundGradient;
    [self configureViews];
    [self setNeedsDisplay];
}

@end
