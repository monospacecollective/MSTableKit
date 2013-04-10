//
//  MSGroupedCellBackgroundView.h
//  MSTableKit
//
//  Created by Eric Horacek on 12/1/13.
//  Copyright 2012 Monospace Ltd. All rights reserved.
//

#import "MSGroupedCellBackgroundView.h"
#import "UIColor+Expanded.h"
#import "KGNoise.h"
#import "MSGroupedTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@interface MSGroupedCellBackgroundView() {
    NSMutableDictionary *_borderColorDictionary;
    NSMutableDictionary *_fillColorDictionary;
    NSMutableDictionary *_shadowColorDictionary;
    NSMutableDictionary *_shadowOffsetDictionary;
    NSMutableDictionary *_shadowBlurDictionary;
    NSMutableDictionary *_innerShadowColorDictionary;
    NSMutableDictionary *_innerShadowOffsetDictionary;
    NSMutableDictionary *_innerShadowBlurDictionary;
    CGFloat _cornerRadius;
    MSGroupedCellBackgroundViewType _type;
}

@property (nonatomic, strong) CAShapeLayer *innerShadowLayer;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;

- (UIBezierPath *)cellPathForRect:(CGRect)rect inset:(CGSize)insets offset:(CGSize)offset cornerRadius:(CGFloat)cornerRadius;

@end

@implementation MSGroupedCellBackgroundView

#pragma mark - UIView

- (id)init
{
    if (self = [super init]) {
        
        self.layer.shouldRasterize = YES;
        self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
        self.opaque = NO;
        // Requires redraw on rotate
        self.contentMode = UIViewContentModeRedraw;
        
        _cornerRadius = 4.0;
        _backgroundColorGradientEnabled = NO;
        _middleBottomUsesShadowColorForNormalInnerShadowColor = NO;
        _topMiddleUsesShadowColorForNormalInnerShadowColor = YES;
        
        _backgroundNoiseEnabled = NO;
        _noiseBlendMode = kCGBlendModeMultiply;
        _noiseOpacity = 0.1;
        
        _borderColorDictionary = [[NSMutableDictionary alloc] init];
        _fillColorDictionary = [[NSMutableDictionary alloc] init];
        _shadowColorDictionary = [[NSMutableDictionary alloc] init];
        _shadowOffsetDictionary = [[NSMutableDictionary alloc] init];
        _shadowBlurDictionary = [[NSMutableDictionary alloc] init];
        _innerShadowColorDictionary = [[NSMutableDictionary alloc] init];
        _innerShadowOffsetDictionary = [[NSMutableDictionary alloc] init];
        _innerShadowBlurDictionary = [[NSMutableDictionary alloc] init];
        
        // Color Defaults, have to do it this was as it messes up UIAppearance
        _borderColorDictionary[@(UIControlStateNormal)] = [UIColor colorWithHexString:@"cccccc"];
        _borderColorDictionary[@(UIControlStateHighlighted)] = [UIColor colorWithHexString:@"999999"];
        
        _fillColorDictionary[@(UIControlStateNormal)] = [UIColor colorWithHexString:@"eeeeee"];
        _fillColorDictionary[@(UIControlStateHighlighted)] = [UIColor colorWithHexString:@"cccccc"];
        
        _shadowColorDictionary[@(UIControlStateNormal)] = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        _shadowBlurDictionary[@(UIControlStateNormal)] = @(0.0);
        _shadowOffsetDictionary[@(UIControlStateNormal)] = [NSValue valueWithCGSize:CGSizeMake(0.0, 1.0)];
        
        _shadowColorDictionary[@(UIControlStateHighlighted)] = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        _shadowBlurDictionary[@(UIControlStateHighlighted)] = @(0.0);
        _shadowOffsetDictionary[@(UIControlStateHighlighted)] = [NSValue valueWithCGSize:CGSizeMake(0.0, 1.0)];
        
        _innerShadowColorDictionary[@(UIControlStateNormal)] = [UIColor colorWithWhite:0.8 alpha:1.0];
        _innerShadowBlurDictionary[@(UIControlStateNormal)] = @(0.0);
        _innerShadowOffsetDictionary[@(UIControlStateNormal)] = [NSValue valueWithCGSize:CGSizeMake(0.0, 0.0)];
        
        _innerShadowColorDictionary[@(UIControlStateHighlighted)] = [UIColor colorWithWhite:0.5 alpha:1.0];
        _innerShadowBlurDictionary[@(UIControlStateHighlighted)] = @(3.0);
        _innerShadowOffsetDictionary[@(UIControlStateHighlighted)] = [NSValue valueWithCGSize:CGSizeMake(0.0, 0.5)];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [self.shapeLayer removeFromSuperlayer];
    self.shapeLayer = nil;
    
    [self.innerShadowLayer removeFromSuperlayer];
    self.innerShadowLayer = nil;
    
    self.shapeLayer = [CAShapeLayer layer];
    [self.layer addSublayer:self.shapeLayer];
    
    self.innerShadowLayer = [CAShapeLayer layer];
    self.innerShadowLayer.frame = self.layer.bounds;
    self.innerShadowLayer.fillRule = kCAFillRuleEvenOdd;
    self.innerShadowLayer.needsDisplayOnBoundsChange = YES;
    [self.layer addSublayer:self.innerShadowLayer];
}

- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    if ([self.superview.superview isKindOfClass:UICollectionView.class]) {
        UICollectionView *enclosingCollectionView = (UICollectionView *)self.superview.superview;
        NSIndexPath *indexPath = [enclosingCollectionView indexPathForCell:(UICollectionViewCell *)self.superview];
        NSInteger rowsForSection = [enclosingCollectionView numberOfItemsInSection:indexPath.section];
        if((indexPath.row == 0) && (indexPath.row == (rowsForSection - 1))) {
            self.type = MSGroupedCellBackgroundViewTypeSingle;
        } else if (indexPath.row == 0) {
            self.type = MSGroupedCellBackgroundViewTypeTop;
        } else if (indexPath.row != (rowsForSection - 1)) {
            self.type = MSGroupedCellBackgroundViewTypeMiddle;
        } else {
            self.type = MSGroupedCellBackgroundViewTypeBottom;
        }
    }
    
    MSGroupedTableViewCell *containingCell = (MSGroupedTableViewCell *)self.superview;
    UIControlState controlState = containingCell.controlState;
    
    CGRect shapeRect = (CGRect){CGPointZero, self.frame.size};
    
    self.shapeLayer.path = [[self cellPathForRect:shapeRect inset:CGSizeMake(0.5, 0.5) offset:CGSizeZero cornerRadius:_cornerRadius] CGPath];
    self.shapeLayer.fillColor = [[self fillColorForState:controlState] CGColor];
    
    self.shapeLayer.strokeColor = [[self borderColorForState:controlState] CGColor];
    
    if (_type == MSGroupedCellBackgroundViewTypeBottom ||
        _type == MSGroupedCellBackgroundViewTypeSingle) {
        self.shapeLayer.shadowOpacity = 1.0;
        self.shapeLayer.shadowColor = [[self shadowColorForState:controlState] CGColor];
        self.shapeLayer.shadowOffset = [self shadowOffsetForState:controlState];
        self.shapeLayer.shadowRadius = [self shadowBlurForState:controlState];
    } else {
        self.shapeLayer.shadowOpacity = 0.0;
    }
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectInset(shapeRect, -10.0, -10.0));
    CGPathAddPath(path, NULL, [[self cellPathForRect:shapeRect inset:CGSizeMake(1.0, 1.0) offset:CGSizeZero cornerRadius:(_cornerRadius - 2)] CGPath]);
    CGPathCloseSubpath(path);
    self.innerShadowLayer.path = path;
    CGPathRelease(path);
    self.innerShadowLayer.fillColor = [[self innerShadowColorForState:controlState] CGColor];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = [[self cellPathForRect:shapeRect inset:CGSizeMake(1.0, 1.0) offset:CGSizeZero cornerRadius:(_cornerRadius - 2)] CGPath];
    self.innerShadowLayer.mask = maskLayer;
    
    self.innerShadowLayer.shadowOpacity = 1.0;

    CGColorRef innerShadowColor;
    if ((self.middleBottomUsesShadowColorForNormalInnerShadowColor) && controlState == UIControlStateNormal && (_type == MSGroupedCellBackgroundViewTypeBottom || _type == MSGroupedCellBackgroundViewTypeMiddle)) {
        innerShadowColor = [[self shadowColorForState:controlState] CGColor];
    }
    else if (self.topMiddleUsesShadowColorForNormalInnerShadowColor && controlState == UIControlStateNormal && (_type == MSGroupedCellBackgroundViewTypeTop || _type == MSGroupedCellBackgroundViewTypeMiddle)) {
        innerShadowColor = [[self shadowColorForState:controlState] CGColor];
    }
    else {
        innerShadowColor = [[self innerShadowColorForState:controlState] CGColor];
    }

    self.innerShadowLayer.shadowColor = innerShadowColor;
    self.innerShadowLayer.shadowOffset = [self innerShadowOffsetForState:controlState];
    self.innerShadowLayer.shadowRadius = [self innerShadowBlurForState:controlState];
}


#pragma mark - MSGroupedCellBackgroundView

- (UIBezierPath *)cellPathForRect:(CGRect)rect inset:(CGSize)insets offset:(CGSize)offset cornerRadius:(CGFloat)cornerRadius
{
    CGRect pathRect = CGRectInset(rect, insets.width, insets.height);
    UIBezierPath *bezierPath;
    if (_type == MSGroupedCellBackgroundViewTypeMiddle) {
        pathRect.size.height += 1.0;
        bezierPath = [UIBezierPath bezierPathWithRect:pathRect];
    } else {
        CGSize cornerRadii = CGSizeMake(_cornerRadius, _cornerRadius);
        UIRectCorner corners = 0;
        if (_type == MSGroupedCellBackgroundViewTypeTop) {
            corners = (UIRectCornerTopLeft | UIRectCornerTopRight);
            pathRect.size.height += 1.0;
        } else if (_type == MSGroupedCellBackgroundViewTypeBottom) {
            corners = (UIRectCornerBottomLeft | UIRectCornerBottomRight);
        } else if (_type == MSGroupedCellBackgroundViewTypeSingle) {
            corners = UIRectCornerAllCorners;
        }
        bezierPath = [UIBezierPath bezierPathWithRoundedRect:pathRect
                                           byRoundingCorners:corners
                                                 cornerRadii:cornerRadii];

    }
    [bezierPath applyTransform:CGAffineTransformMakeTranslation(offset.width, offset.height)];
    return bezierPath;
}

#pragma mark - UIControlState Accessors

#pragma mark Setters

- (void)setValue:(id)value inStateDictionary:(NSMutableDictionary *)stateDictionary forState:(UIControlState)state
{
    static NSArray *statesNumbers;
    if (!statesNumbers) {
        statesNumbers = @[@(UIControlStateNormal), @(UIControlStateHighlighted), @(UIControlStateSelected)];
    }
    for (NSNumber *stateNumber in statesNumbers) {
        NSUInteger stateInteger = [stateNumber unsignedIntegerValue];
        BOOL statePresentInMask = (stateInteger == UIControlStateNormal) ? (state == UIControlStateNormal) : ((state & stateInteger) == stateInteger);
        if (statePresentInMask) {
            stateDictionary[stateNumber] = value;
        }
    }
}

- (void)setBorderColor:(UIColor *)borderColor forState:(UIControlState)state
{
    [self setValue:borderColor inStateDictionary:_borderColorDictionary forState:state];
    [self setNeedsDisplay];
}

- (void)setFillColor:(UIColor *)fillColor forState:(UIControlState)state
{
    [self setValue:fillColor inStateDictionary:_fillColorDictionary forState:state];
    [self setNeedsDisplay];
}

- (void)setShadowColor:(UIColor *)shadowColor forState:(UIControlState)state
{
    [self setValue:shadowColor inStateDictionary:_shadowColorDictionary forState:state];
    [self setNeedsDisplay];
}

- (void)setShadowOffset:(CGSize)shadowOffset forState:(UIControlState)state
{
    [self setValue:[NSValue valueWithCGSize:shadowOffset] inStateDictionary:_shadowOffsetDictionary forState:state];
    [self setNeedsDisplay];
}

- (void)setShadowBlur:(CGFloat)shadowBlur forState:(UIControlState)state
{
    [self setValue:@(shadowBlur) inStateDictionary:_shadowBlurDictionary forState:state];
    [self setNeedsDisplay];
}

- (void)setInnerShadowColor:(UIColor *)shadowColor forState:(UIControlState)state
{
    [self setValue:shadowColor inStateDictionary:_innerShadowColorDictionary forState:state];
    [self setNeedsDisplay];
}

- (void)setInnerShadowOffset:(CGSize)innerShadowOffset forState:(UIControlState)state
{
    [self setValue:[NSValue valueWithCGSize:innerShadowOffset] inStateDictionary:_innerShadowOffsetDictionary forState:state];
    [self setNeedsDisplay];
}

- (void)setInnerShadowBlur:(CGFloat)shadowBlur forState:(UIControlState)state
{
    [self setValue:@(shadowBlur) inStateDictionary:_innerShadowBlurDictionary forState:state];
    [self setNeedsDisplay];
}

#pragma mark Getters

- (id)valueInStateDictionary:(NSDictionary *)stateDictionary forControlState:(UIControlState)state
{
    NSAssert((state == UIControlStateNormal) || (state == UIControlStateSelected) || (state == UIControlStateHighlighted) || (state == UIControlStateDisabled), @"Queried control states must not be bit masks");
    id stateDictionaryValue = stateDictionary[@(state)];
    if (stateDictionaryValue) {
        return stateDictionaryValue;
    }
    // If we're querying the selected state, default to highlighted if it exists
    else if ((state == UIControlStateSelected) && stateDictionary[@(UIControlStateHighlighted)]) {
        return stateDictionary[@(UIControlStateHighlighted)];
    }
    // If we're querying any state that doesn't exist in the dict, default to normal
    else {
        return stateDictionary[@(UIControlStateNormal)];
    }
}

- (UIColor *)borderColorForState:(UIControlState)state
{
    return [self valueInStateDictionary:_borderColorDictionary forControlState:state];
}

- (UIColor *)fillColorForState:(UIControlState)state
{
    return [self valueInStateDictionary:_fillColorDictionary forControlState:state];
}

- (UIColor *)shadowColorForState:(UIControlState)state
{
    return [self valueInStateDictionary:_shadowColorDictionary forControlState:state];
}

- (CGSize)shadowOffsetForState:(UIControlState)state
{
    return [[self valueInStateDictionary:_shadowOffsetDictionary forControlState:state] CGSizeValue];
}

- (CGFloat)shadowBlurForState:(UIControlState)state
{
    return [[self valueInStateDictionary:_shadowBlurDictionary forControlState:state] floatValue];
}

- (UIColor *)innerShadowColorForState:(UIControlState)state
{
    return [self valueInStateDictionary:_innerShadowColorDictionary forControlState:state];
}

- (CGSize)innerShadowOffsetForState:(UIControlState)state
{
    return [[self valueInStateDictionary:_innerShadowOffsetDictionary forControlState:state] CGSizeValue];
}

- (CGFloat)innerShadowBlurForState:(UIControlState)state
{
    return [[self valueInStateDictionary:_innerShadowBlurDictionary forControlState:state] floatValue];
}

#pragma mark Non-UIControlState Accessors

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    [self setNeedsDisplay];
}

- (CGFloat)cornerRadius
{
    return _cornerRadius;
}

- (void)setType:(MSGroupedCellBackgroundViewType)type
{
    _type = type;
    [self setNeedsDisplay];
}

- (MSGroupedCellBackgroundViewType)type
{
    return _type;
}

@end
