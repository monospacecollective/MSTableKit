//
//  UCDMasterTableViewHeader.h
//  CUUCD2012
//
//  Created by Eric Horacek on 12/9/12.
//  Copyright (c) 2012 Team 11. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CAGradientLayer;

@interface MSPlainTableViewHeaderView : UITableViewHeaderFooterView <UIAppearanceContainer>

@property (strong, nonatomic) UIColor *textColor UI_APPEARANCE_SELECTOR;

@property (strong, nonatomic) UIColor *topEtchHighlightColor UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) UIColor *topEtchShadowColor UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) UIColor *bottomEtchShadowColor UI_APPEARANCE_SELECTOR;
@property (strong, nonatomic) CAGradientLayer *backgroundGradient UI_APPEARANCE_SELECTOR;

@end
