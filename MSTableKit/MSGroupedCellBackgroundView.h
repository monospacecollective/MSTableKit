//
//  MSGroupedCellBackgroundView.h
//  MSTableKit
//
//  Created by Eric Horacek on 12/1/13.
//  Copyright 2012 Monospace Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MSGroupedCellBackgroundViewType) {
    MSGroupedCellBackgroundViewTypeTop,
    MSGroupedCellBackgroundViewTypeMiddle,
    MSGroupedCellBackgroundViewTypeBottom,
    MSGroupedCellBackgroundViewTypeSingle
};

@interface MSGroupedCellBackgroundView : UIView

@property (nonatomic, assign) MSGroupedCellBackgroundViewType type;

@property (nonatomic, assign) CGFloat cornerRadius UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) BOOL backgroundColorGradientEnabled UI_APPEARANCE_SELECTOR;

@property (nonatomic, assign) BOOL middleBottomUsesShadowColorForNormalInnerShadowColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) BOOL topMiddleUsesShadowColorForNormalInnerShadowColor UI_APPEARANCE_SELECTOR;

@property (nonatomic, assign) BOOL backgroundNoiseEnabled UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat noiseOpacity UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGBlendMode noiseBlendMode UI_APPEARANCE_SELECTOR;

- (void)setBorderColor:(UIColor *)borderColor forState:(UIControlState)state UI_APPEARANCE_SELECTOR;
- (void)setFillColor:(UIColor *)borderColor forState:(UIControlState)state UI_APPEARANCE_SELECTOR;
- (void)setShadowColor:(UIColor *)shadowColor forState:(UIControlState)state UI_APPEARANCE_SELECTOR;
- (void)setShadowOffset:(CGSize)shadowOffset forState:(UIControlState)state UI_APPEARANCE_SELECTOR;
- (void)setShadowBlur:(CGFloat)shadowBlur forState:(UIControlState)state UI_APPEARANCE_SELECTOR;
- (void)setInnerShadowColor:(UIColor *)shadowColor forState:(UIControlState)state UI_APPEARANCE_SELECTOR;
- (void)setInnerShadowOffset:(CGSize)shadowOffset forState:(UIControlState)state UI_APPEARANCE_SELECTOR;
- (void)setInnerShadowBlur:(CGFloat)shadowBlur forState:(UIControlState)state UI_APPEARANCE_SELECTOR;

- (UIColor *)borderColorForState:(UIControlState)state UI_APPEARANCE_SELECTOR;
- (UIColor *)fillColorForState:(UIControlState)state UI_APPEARANCE_SELECTOR;
- (UIColor *)shadowColorForState:(UIControlState)state UI_APPEARANCE_SELECTOR;
- (CGSize)shadowOffsetForState:(UIControlState)state UI_APPEARANCE_SELECTOR;
- (CGFloat)shadowBlurForState:(UIControlState)state UI_APPEARANCE_SELECTOR;
- (UIColor *)innerShadowColorForState:(UIControlState)state UI_APPEARANCE_SELECTOR;
- (CGSize)innerShadowOffsetForState:(UIControlState)state UI_APPEARANCE_SELECTOR;
- (CGFloat)innerShadowBlurForState:(UIControlState)state UI_APPEARANCE_SELECTOR;

@end
