//
//  UCDMasterTableViewHeader.m
//  CUUCD2012
//
//  Created by Eric Horacek on 12/9/12.
//  Copyright (c) 2012 Team 11. All rights reserved.
//

#import "MSPlainTableViewHeaderView.h"
#import <QuartzCore/QuartzCore.h>

@interface MSPlainTableViewHeaderView ()

@property (nonatomic, strong) UIView *topEtchHighlightView;
@property (nonatomic, strong) UIView *bottomEtchShadowView;
@property (strong, nonatomic) UIView *backgroundView;

@end

@implementation MSPlainTableViewHeaderView

#pragma mark - UIView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.bottomEtchShadowView.frame = CGRectMake(0.0, (CGRectGetHeight(self.bounds) - self.bottomEtchShadowHeight), CGRectGetWidth(self.bounds), self.bottomEtchShadowHeight);
    self.topEtchHighlightView.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(self.bounds), self.topEtchHighlightHeight);
    
    CGRect backgroundFrame = (CGRect){{0.0, 0.0}, self.frame.size};
    self.backgroundGradient.frame = backgroundFrame;
    self.backgroundView.frame = backgroundFrame;
}

#pragma mark - MSGroupedTableViewHeaderView

- (void)initialize
{
    [super initialize];
    
    self.opaque = YES;
    self.layer.masksToBounds = NO;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    self.backgroundView = [[UIView alloc] init];
    self.topEtchHighlightView = [[UIView alloc] init];
    self.bottomEtchShadowView = [[UIView alloc] init];
    
    [self insertSubview:self.backgroundView atIndex:0];
    [self insertSubview:self.topEtchHighlightView aboveSubview:self.backgroundView];
    [self insertSubview:self.bottomEtchShadowView aboveSubview:self.backgroundView];
}

- (void)configureViews
{
    [super configureViews];
    
    self.topEtchHighlightView.backgroundColor = self.topEtchHighlightColor;
    self.bottomEtchShadowView.backgroundColor = self.bottomEtchShadowColor;
    self.backgroundView.backgroundColor = self.backgroundColor;
    
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
        [self.layer insertSublayer:self.backgroundGradient above:self.backgroundView.layer];
    }
}

+ (void)applyDefaultAppearance
{
    [self.appearance setTopEtchHighlightHeight:1.0];
    [self.appearance setBottomEtchShadowHeight:1.0];
}

@end
