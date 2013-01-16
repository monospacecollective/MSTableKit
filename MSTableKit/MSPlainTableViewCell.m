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

@interface MSPlainTableViewCell ()

@property (nonatomic, strong) UIView *selectionView;
@property (nonatomic, strong) UIView *highlightView;
@property (nonatomic, strong) UIView *shadowView;

@end

@implementation MSPlainTableViewCell

#pragma mark - NSObject

+ (void)initialize
{
    [super initialize];
    
    UIColor *defaultTextColor = [UIColor blackColor];
    [[self.class appearance] setTextColor:defaultTextColor];
    
    UIColor *defaultEtchHighlightColor = [UIColor colorWithWhite:0.75 alpha:1.0];
    UIColor *defaultEtchShadowColor = [UIColor colorWithWhite:0.45 alpha:1.0];
    UIColor *defaultSelectionColor = [UIColor colorWithWhite:0.0 alpha:0.15];
    
    [[self.class appearance] setEtchHighlightColor:defaultEtchHighlightColor];
    [[self.class appearance] setEtchShadowColor:defaultEtchShadowColor];
    [[self.class appearance] setSelectionColor:defaultSelectionColor];
    
    [[UILabel appearanceWhenContainedIn:self.class, nil] setShadowOffset:CGSizeMake(0.0, 1.0)];
    [[UILabel appearanceWhenContainedIn:self.class, nil] setShadowColor:defaultEtchHighlightColor];
}

#pragma mark - UIView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backgroundGradient.frame = self.bounds;
    
    if ([self.superview isKindOfClass:MSPlainTableView.class]) {        
        MSPlainTableView *enclosingTableView = (MSPlainTableView *)self.superview;
        self.highlightView.frame = CGRectMake(0.0, 0.0, self.bounds.size.width, 1.0);
        NSIndexPath *indexPath = [enclosingTableView indexPathForCell:self];
        BOOL bottomRow = (indexPath.row == ([enclosingTableView numberOfRowsInSection:indexPath.section] - 1));
        if (!bottomRow) {
            self.selectionView.frame = CGRectMake(0.0, 0.0, self.bounds.size.width, self.bounds.size.height - 1.0);
            self.shadowView.frame = CGRectMake(0.0, self.bounds.size.height - 1.0, self.bounds.size.width, 1.0);
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
    
    [self configureViews];
    
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
