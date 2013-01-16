//
//  MSPlainTableViewCell.h
//  MSTableKit
//
//  created by Eric Horacek & Devon Tivona on 1/4/12.
//  Copyright (c) 2012 Monospace Ltd. All rights reserved.
//

#import "MSTableViewCell.h"

@interface MSPlainTableViewCell : MSTableViewCell <UIAppearanceContainer>

@property (strong, nonatomic) UIColor *selectionColor UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) UIColor *etchHighlightColor UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) UIColor *etchShadowColor UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) CAGradientLayer *backgroundGradient UI_APPEARANCE_SELECTOR;

@end
