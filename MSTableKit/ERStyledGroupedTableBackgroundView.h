//
//  CustomCellBackgroundView.h
//
//  Created by Devon Tivona on 11/21/08.
//  Copyright 2008 Monospace Collective. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CustomCellBackgroundViewPosition) {
    CustomCellBackgroundViewPositionTop, 
    CustomCellBackgroundViewPositionMiddle, 
    CustomCellBackgroundViewPositionBottom,
    CustomCellBackgroundViewPositionSingle
};

@interface ERStyledGroupedTableBackgroundView : UIView

@property(nonatomic, strong) UIColor *borderColor;
@property(nonatomic, strong) UIColor *fillColor;
@property(nonatomic, strong) UIColor *shadowColor;
@property(nonatomic, strong) UIColor *innerShadowColor;
@property(nonatomic, assign) CGFloat roundSize;

@property(nonatomic) CustomCellBackgroundViewPosition position;

@end
