//
//  MSPlainTableViewCell.h
//  MSTableKit
//
//  created by Eric Horacek & Devon Tivona on 1/4/12.
//  Copyright (c) 2012 Monospace Ltd. All rights reserved.
//

#import "MSTableViewCell.h"

@class CAGradientLayer;

@interface MSPlainTableViewCell : MSTableViewCell <UIAppearanceContainer>

@property (nonatomic, strong) UIColor *selectionColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *etchHighlightColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *etchShadowColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) CAGradientLayer *backgroundGradient UI_APPEARANCE_SELECTOR;

@property (nonatomic, assign) CGFloat highlightViewHeight UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat shadowViewHeight UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIView *selectionView;
@property (nonatomic, strong) UIView *highlightView;
@property (nonatomic, strong) UIView *shadowView;

@end
