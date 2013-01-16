//
//  UCDMasterTableViewHeader.m
//  CUUCD2012
//
//  Created by Eric Horacek on 12/9/12.
//  Copyright (c) 2012 Team 11. All rights reserved.
//

#import "MSPlainTableViewHeaderView.h"
#import "MSPlainTableView.h"

@interface MSPlainTableViewHeaderView ()

@property (nonatomic, strong) UIView *topShadowLine;
@property (nonatomic, strong) UIView *topHighlightLine;
@property (nonatomic, strong) UIView *bottomShadowLine;

- (void)initialize;
- (void)configureViews;

@end

@implementation MSPlainTableViewHeaderView

#pragma mark - NSObject

+ (void)initialize
{
    UIColor *defaultTextColor = [UIColor blackColor];
    [[self.class appearanceWhenContainedIn:MSPlainTableView.class, nil] setTextColor:defaultTextColor];
    
    UIColor *defaultTopEtchHighlightColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    UIColor *defaultTopEtchShadowColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    UIColor *defaultBottomEtchShadowColor = [UIColor colorWithWhite:0.0 alpha:0.4];
    
    [[self.class appearance] setTopEtchHighlightColor:defaultTopEtchHighlightColor];
    [[self.class appearance] setTopEtchShadowColor:defaultTopEtchShadowColor];
    [[self.class appearance] setBottomEtchShadowColor:defaultBottomEtchShadowColor];
    
    [[UILabel appearanceWhenContainedIn:self.class, nil] setShadowOffset:CGSizeMake(0.0, 1.0)];
    [[UILabel appearanceWhenContainedIn:self.class, nil] setShadowColor:defaultTopEtchHighlightColor];
    [[UILabel appearanceWhenContainedIn:self.class, nil] setFont:[UIFont boldSystemFontOfSize:14.0]];
    
    CAGradientLayer *defaultBackgroundGradient = [CAGradientLayer layer];
    UIColor *gradientTopColor = [UIColor colorWithWhite:0.0 alpha:0.1];
    UIColor *gradientBottomColor = [UIColor colorWithWhite:0.0 alpha:0.3];
    defaultBackgroundGradient.colors = @[(id)[gradientTopColor CGColor], (id)[gradientBottomColor CGColor]];
    [[self.class appearance] setBackgroundGradient:defaultBackgroundGradient];
}


#pragma mark - UIView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundGradient.frame = self.bounds;
    
    self.bottomShadowLine.frame = CGRectMake(0.0, (CGRectGetHeight(self.bounds) - 1.0), CGRectGetWidth(self.bounds), 1.0);
    self.topShadowLine.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(self.bounds), 1.0);
    self.topHighlightLine.frame = CGRectMake(0.0, 1.0, CGRectGetWidth(self.bounds), 1.0);
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    [self configureViews];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self configureViews];
}

#pragma mark - MSTableViewHeaderView

- (void)initialize
{
    self.layer.masksToBounds = NO;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    self.topHighlightLine = [[UIView alloc] init];
    [self.contentView addSubview:self.topHighlightLine];
    
    self.bottomShadowLine = [[UIView alloc] init];
    [self.contentView addSubview:self.bottomShadowLine];
    
    self.topShadowLine = [[UIView alloc] init];
    [self.contentView addSubview:self.topShadowLine];
    
    self.backgroundView = [[UIView alloc] init];
    
    [self configureViews];
}

- (void)configureViews
{
    self.textLabel.backgroundColor = [UIColor clearColor];
    
    self.backgroundView.backgroundColor = self.backgroundColor;
    
    self.topHighlightLine.backgroundColor = self.topEtchHighlightColor;
    self.topShadowLine.backgroundColor = self.topEtchShadowColor;
    self.bottomShadowLine.backgroundColor = self.bottomEtchShadowColor;
    
    self.textLabel.textColor = self.textColor;
    
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

@end
