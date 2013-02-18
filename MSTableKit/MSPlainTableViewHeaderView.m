//
//  UCDMasterTableViewHeader.m
//  CUUCD2012
//
//  Created by Eric Horacek on 12/9/12.
//  Copyright (c) 2012 Team 11. All rights reserved.
//

#import "MSPlainTableViewHeaderView.h"
#import "MSPlainTableView.h"
#import <QuartzCore/QuartzCore.h>

@interface MSPlainTableViewHeaderView ()

@property (nonatomic, strong) UIView *topShadowLine;
@property (nonatomic, strong) UIView *topHighlightLine;
@property (nonatomic, strong) UIView *bottomShadowLine;

#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
@property (strong, nonatomic) UIView *backgroundView;
#endif

@end

@implementation MSPlainTableViewHeaderView

#pragma mark - UIView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
    self.bottomShadowLine.frame = CGRectMake(0.0, (CGRectGetHeight(self.bounds) - 1.0), CGRectGetWidth(self.bounds), 1.0);
    self.topShadowLine.frame = CGRectMake(0.0, -1.0, CGRectGetWidth(self.bounds), 1.0);
    self.topHighlightLine.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(self.bounds), 1.0);
#else
    self.bottomShadowLine.frame = CGRectMake(0.0, (CGRectGetHeight(self.bounds) - 1.0), CGRectGetWidth(self.bounds), 1.0);
    self.topShadowLine.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(self.bounds), 1.0);
    self.topHighlightLine.frame = CGRectMake(0.0, 1.0, CGRectGetWidth(self.bounds), 1.0);
#endif
    
    CGRect backgroundFrame = (CGRect){{0.0, 0.0}, self.frame.size};
    self.backgroundGradient.frame = backgroundFrame;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
    self.backgroundView.frame = backgroundFrame;
#endif
}

#pragma mark - MSGroupedTableViewHeaderView

- (void)initialize
{
    [super initialize];
    
    self.opaque = YES;
    self.layer.masksToBounds = NO;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    self.topHighlightLine = [[UIView alloc] init];
    self.bottomShadowLine = [[UIView alloc] init];
    self.topShadowLine = [[UIView alloc] init];
    self.backgroundView = [[UIView alloc] init];
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_6_0
    [self.contentView addSubview:self.topHighlightLine];
    [self.contentView addSubview:self.bottomShadowLine];
    [self.contentView addSubview:self.topShadowLine];
#else
    [self insertSubview:self.backgroundView atIndex:0];
    [self insertSubview:self.topHighlightLine aboveSubview:self.backgroundView];
    [self insertSubview:self.bottomShadowLine aboveSubview:self.backgroundView];
    [self insertSubview:self.topShadowLine aboveSubview:self.backgroundView];
#endif
}

- (void)configureViews
{
    [super configureViews];
    
    self.topHighlightLine.backgroundColor = self.topEtchHighlightColor;
    self.topShadowLine.backgroundColor = self.topEtchShadowColor;
    self.bottomShadowLine.backgroundColor = self.bottomEtchShadowColor;
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

+ (CGSize)padding
{
    return CGSizeMake(6.0, 4.0);
}

+ (UIFont *)defaultTextLabelFont
{
    return [UIFont boldSystemFontOfSize:15.0];
}

@end
