//
//  UCDMasterTableViewHeader.h
//  CUUCD2012
//
//  Created by Eric Horacek on 12/9/12.
//  Copyright (c) 2012 Team 11. All rights reserved.
//

#import "MSTableViewHeaderFooterView.h"

@class CAGradientLayer;

@interface MSPlainTableViewHeaderView : MSTableViewHeaderFooterView

@property (strong, nonatomic) UIColor *backgroundColor UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) UIColor *topEtchHighlightColor UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) UIColor *bottomEtchShadowColor UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) CAGradientLayer *backgroundGradient UI_APPEARANCE_SELECTOR;

@property (nonatomic, assign) CGFloat topEtchHighlightHeight UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat bottomEtchShadowHeight UI_APPEARANCE_SELECTOR;

@end
