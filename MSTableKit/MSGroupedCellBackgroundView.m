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

- (CGPathRef)cellPathForRect:(CGRect)rect inset:(CGSize)insets offset:(CGSize)offset cornerRadius:(CGFloat)cornerRadius;

@end

@implementation MSGroupedCellBackgroundView

#pragma mark - UIView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.opaque = NO;
        // Requires redraw on rotate
        self.contentMode = UIViewContentModeRedraw;
        
        _cornerRadius = 4.0;
        _backgroundColorGradientEnabled = NO;
        _middleBottomUsesShadowColorForNormalInnerShadowColor = YES;
        
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
        _borderColorDictionary[@(UIControlStateNormal)] = [UIColor colorWithWhite:0.5 alpha:1.0];
        _borderColorDictionary[@(UIControlStateHighlighted)] = [UIColor colorWithWhite:0.4 alpha:1.0];
        
        _fillColorDictionary[@(UIControlStateNormal)] = [[UIColor blackColor] colorWithAlphaComponent:0.1];
        _fillColorDictionary[@(UIControlStateHighlighted)] = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        
        _shadowColorDictionary[@(UIControlStateNormal)] = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        _shadowColorDictionary[@(UIControlStateHighlighted)] = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        _shadowColorDictionary[@(UIControlStateNormal)] = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        
        _innerShadowColorDictionary[@(UIControlStateNormal)] = [UIColor colorWithWhite:0.0 alpha:0.1];
        _innerShadowBlurDictionary[@(UIControlStateNormal)] = @(0.0);
        _innerShadowOffsetDictionary[@(UIControlStateNormal)] = [NSValue valueWithCGSize:CGSizeMake(0.0, 1.0)];
        
        _innerShadowColorDictionary[@(UIControlStateHighlighted)] = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _innerShadowBlurDictionary[@(UIControlStateHighlighted)] = @(4.0);
        _innerShadowOffsetDictionary[@(UIControlStateHighlighted)] = [NSValue valueWithCGSize:CGSizeMake(0.0, 0.5)];
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    NSParameterAssert([self.superview isKindOfClass:MSGroupedTableViewCell.class]);
    MSGroupedTableViewCell *containingCell = (MSGroupedTableViewCell *)self.superview;
    UIControlState controlState = containingCell.controlState;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    // Shadow
#warning use provided shadow offset and blur radius
    if (_type == MSGroupedCellBackgroundViewTypeBottom ||
        _type == MSGroupedCellBackgroundViewTypeSingle) {
        CGPathRef shadowPath = [self cellPathForRect:rect inset:CGSizeMake(0.5, 0.0) offset:CGSizeZero cornerRadius:_cornerRadius];
        UIBezierPath *shadowBezierPath = [UIBezierPath bezierPathWithCGPath:shadowPath];
        CGPathRelease(shadowPath);
        [shadowBezierPath applyTransform:CGAffineTransformMakeTranslation(0.0, 0.5)];
        [[self shadowColorForState:controlState] set];
        [shadowBezierPath stroke];
    }
    
    // Border & Fill
    CGPathRef borderPath = [self cellPathForRect:rect inset:CGSizeMake(0.5, 0.5) offset:CGSizeZero cornerRadius:_cornerRadius];
    UIBezierPath *borderBezierPath = [UIBezierPath bezierPathWithCGPath:borderPath];
    CGPathRelease(borderPath);
    
    if (self.backgroundColorGradientEnabled && (controlState == UIControlStateNormal)) {
        UIColor *fillColor = [self fillColorForState:controlState];
        NSArray* gradientColors = @[(id)[fillColor colorByAdding:0.1].CGColor, (id)[fillColor colorByAdding:-0.1].CGColor];
        CGFloat gradientLocations[] = {0.0, 1.0};
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradientColors, gradientLocations);
        CGColorSpaceRelease(colorSpace);
        CGContextSaveGState(context);
        [borderBezierPath addClip];
        CGPoint startPoint = CGPointMake(0.0, 0.0);
        CGPoint endPoint = CGPointMake(0.0, rect.size.height);
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
        CGContextRestoreGState(context);
    } else {
        [[self fillColorForState:controlState] set];
        [borderBezierPath fill];
    }
    
    // Background Noise
    if (self.backgroundNoiseEnabled) {
        CGContextSaveGState(context);
        [borderBezierPath addClip];
        [KGNoise drawNoiseWithOpacity:self.noiseOpacity andBlendMode:self.noiseBlendMode];
        CGContextRestoreGState(context);
    }
    
    [[self borderColorForState:controlState] set];
    [borderBezierPath stroke];
    
    // Inner Shadow
    CGColorRef shadowColor;
    if (self.middleBottomUsesShadowColorForNormalInnerShadowColor && controlState == UIControlStateNormal && (_type == MSGroupedCellBackgroundViewTypeBottom || _type == MSGroupedCellBackgroundViewTypeMiddle)) {
        shadowColor = [[self shadowColorForState:controlState] CGColor];
    } else {
        shadowColor = [[self innerShadowColorForState:controlState] CGColor];
    }
    CGSize shadowOffset = [self innerShadowOffsetForState:controlState];
    CGFloat shadowBlurRadius = [self innerShadowBlurForState:controlState];
    
    CGPathRef innerShadowPath = [self cellPathForRect:rect inset:CGSizeMake(1.0, 1.0) offset:CGSizeZero cornerRadius:(_cornerRadius - 0.5)];
    UIBezierPath* innerShadowBezierPath = [UIBezierPath bezierPathWithCGPath:innerShadowPath];
    CGPathRelease(innerShadowPath);
    CGRect roundedRectangleBorderRect = CGRectInset([innerShadowBezierPath bounds], -shadowBlurRadius, -shadowBlurRadius);
    roundedRectangleBorderRect = CGRectOffset(roundedRectangleBorderRect, -shadowOffset.width, -shadowOffset.height);
    roundedRectangleBorderRect = CGRectInset(CGRectUnion(roundedRectangleBorderRect, [innerShadowBezierPath bounds]), -1, -1);
    UIBezierPath* roundedRectangleNegativePath = [UIBezierPath bezierPathWithRect:roundedRectangleBorderRect];
    [roundedRectangleNegativePath appendPath:innerShadowBezierPath];
    roundedRectangleNegativePath.usesEvenOddFillRule = YES;
    CGContextSaveGState(context);
    CGFloat xOffset = shadowOffset.width + round(roundedRectangleBorderRect.size.width);
    CGFloat yOffset = shadowOffset.height;
    CGContextSetShadowWithColor(context, CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)), shadowBlurRadius, shadowColor);
    [innerShadowBezierPath addClip];
    CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(roundedRectangleBorderRect.size.width), 0);
    [roundedRectangleNegativePath applyTransform: transform];
    [[UIColor grayColor] setFill];
    [roundedRectangleNegativePath fill];
    CGContextRestoreGState(context);
}

#pragma mark - MSGroupedCellBackgroundView

- (CGPathRef)cellPathForRect:(CGRect)rect inset:(CGSize)insets offset:(CGSize)offset cornerRadius:(CGFloat)cornerRadius
{
    CGFloat insetdx = insets.width;
    CGFloat insetdy = insets.height;
    
    CGFloat minx = CGRectGetMinX(rect), midx = CGRectGetMidX(rect), maxx = CGRectGetMaxX(rect);
    CGFloat miny = CGRectGetMinY(rect), midy = CGRectGetMidY(rect), maxy = CGRectGetMaxY(rect);
    
    minx += insetdx;
    maxx -= insetdx;
    
    CGMutablePathRef path = CGPathCreateMutable();
    if (_type == MSGroupedCellBackgroundViewTypeTop) {
        
        miny += insetdy;
        maxy -= insetdy;
        
        CGPathMoveToPoint(path, NULL, minx, maxy);
        CGPathAddArcToPoint(path, NULL, minx, miny, midx, miny, cornerRadius);
        CGPathAddArcToPoint(path, NULL, maxx, miny, maxx, maxy, cornerRadius);
        CGPathAddLineToPoint(path, NULL, maxx, maxy);
        
    } else if (_type == MSGroupedCellBackgroundViewTypeBottom) {
        
        miny = (miny - 1.0) + insetdy;
        maxy -= (1.0 + insetdy);
        
        CGPathMoveToPoint(path, NULL, minx, miny);
        CGPathAddArcToPoint(path, NULL, minx, maxy, midx, maxy, cornerRadius);
        CGPathAddArcToPoint(path, NULL, maxx, maxy, maxx, miny, cornerRadius);
        CGPathAddLineToPoint(path, NULL, maxx, miny);
        
    } else if (_type == MSGroupedCellBackgroundViewTypeMiddle) {
        
        miny = (miny - 1.0) + insetdy;
        maxy -= insetdy;
        
        CGPathMoveToPoint(path, NULL, minx, miny);
        CGPathAddLineToPoint(path, NULL, maxx, miny);
        CGPathAddLineToPoint(path, NULL, maxx, maxy);
        CGPathAddLineToPoint(path, NULL, minx, maxy);
        
    } else if (_type == MSGroupedCellBackgroundViewTypeSingle) {
        
        miny += insetdy;
        maxy -= (1.0 + insetdy);
        
        CGPathMoveToPoint(path, NULL, minx, midy);
        CGPathAddArcToPoint(path, NULL, minx, miny, midx, miny, cornerRadius);
        CGPathAddArcToPoint(path, NULL, maxx, miny, maxx, midy, cornerRadius);
        CGPathAddArcToPoint(path, NULL, maxx, maxy, midx, maxy, cornerRadius);
        CGPathAddArcToPoint(path, NULL, minx, maxy, minx, midy, cornerRadius);
    }
    CGPathCloseSubpath(path);
    return path;
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
