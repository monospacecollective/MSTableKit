//
//  CustomCellBackgroundView.m
//
//  Created by Devon Tivona on 11/21/08.
//  Copyright 2008 Monospace Collective. All rights reserved.
//

#import "ERStyledGroupedTableBackgroundView.h"
#import "ERStyledGroupedTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

static void addRoundedRectToPath(CGContextRef context, CGRect rect,
                                 float ovalWidth,float ovalHeight);

@interface ERStyledGroupedTableBackgroundView() {
    
    UIColor *_borderColor;
    UIColor *_fillColor;
    UIColor *_highlightColor;
    UIColor *_innerShadowColor;
    CGFloat _roundSize;
    CustomCellBackgroundViewPosition position;
}

- (UIImage *)styledGroupedTableViewCellSelectedImageForPosition:(CustomCellBackgroundViewPosition)cellPosition;

@end

@implementation ERStyledGroupedTableBackgroundView

@dynamic borderColor;
@dynamic fillColor;
@dynamic shadowColor;
@dynamic innerShadowColor;
@dynamic roundSize;

@synthesize position;

- (BOOL) isOpaque {
    return NO;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Default initialization
        self.roundSize = 4.0;
    }
    return self;
}

- (UIImage *)styledGroupedTableViewCellSelectedImageForPosition:(CustomCellBackgroundViewPosition)cellPosition
{
    UIImage *selectedImage;
    
    switch (cellPosition) {
        case CustomCellBackgroundViewPositionSingle:
            selectedImage = [UIImage imageNamed:@"ERStyledGroupedTableViewCellSelectedSingle"];
            break;
        case CustomCellBackgroundViewPositionTop:
            selectedImage = [UIImage imageNamed:@"ERStyledGroupedTableViewCellSelectedTop"];
            break;
        case CustomCellBackgroundViewPositionMiddle:
            selectedImage = [UIImage imageNamed:@"ERStyledGroupedTableViewCellSelectedMiddle"];
            break;
        case CustomCellBackgroundViewPositionBottom:
            selectedImage = [UIImage imageNamed:@"ERStyledGroupedTableViewCellSelectedBottom"];
            break;
        default:
            selectedImage = nil;
            break;
    }
    
    if (selectedImage != nil) {
        selectedImage = [selectedImage resizableImageWithCapInsets:UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0)];
    }
    
    return selectedImage;
}

-(void)drawRect:(CGRect)rect 
{
    //
    // HIGHLIGHT
    //
    
    ERStyledGroupedTableViewCell *containingCell = (ERStyledGroupedTableViewCell *)self.superview;

    BOOL highlighted = ((containingCell.highlighted || containingCell.selected) && containingCell.shouldDrawSelection);
    
    CGContextRef h = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(h, [_highlightColor CGColor]);
    
    CGContextSetLineWidth(h, 1);
    
    __block CGFloat minx = CGRectGetMinX(rect) , midx = CGRectGetMidX(rect), maxx = CGRectGetMaxX(rect) ;
    __block CGFloat miny = CGRectGetMinY(rect) , midy = CGRectGetMidY(rect) , maxy = CGRectGetMaxY(rect) ;
    
    if (position == CustomCellBackgroundViewPositionTop) 
    {
        CGContextSetStrokeColorWithColor(h, [_innerShadowColor CGColor]);
        
        minx = minx + 0.5;
        miny = miny + 1.5;
        
        maxx = maxx - 0.5;
        maxy = maxy + 1.0;
        
        CGContextMoveToPoint(h, minx, maxy);
        CGContextAddArcToPoint(h, minx, miny, midx, miny, _roundSize);
        CGContextAddArcToPoint(h, maxx, miny, maxx, maxy, _roundSize);
        CGContextAddLineToPoint(h, maxx, maxy);
    } 
    else if (position == CustomCellBackgroundViewPositionBottom) 
    {
        minx = minx + 0.5;        
        miny = miny + 0.5;
        
        maxx = maxx - 0.5;
        maxy = maxy - 0.5;
        
        CGContextMoveToPoint(h, minx, miny);
        CGContextAddArcToPoint(h, minx, maxy, midx, maxy, _roundSize);
        CGContextAddArcToPoint(h, maxx, maxy, maxx, miny, _roundSize);
        CGContextAddLineToPoint(h, maxx, miny);
    } 
    else if (position == CustomCellBackgroundViewPositionMiddle) 
    {
        minx = minx + 0.5;
        miny = miny + 0.5;
        
        maxx = maxx - 0.5;
        maxy = maxy + 1.0 ;
        
        CGContextMoveToPoint(h, minx, miny);
        CGContextAddLineToPoint(h, maxx, miny);
        CGContextAddLineToPoint(h, maxx, maxy);
        CGContextAddLineToPoint(h, minx, maxy);
    }
    else if (position == CustomCellBackgroundViewPositionSingle)
    {
        minx = minx + 0.5;
        miny = miny + 0.5;
        
        maxx = maxx - 0.5;
        maxy = maxy - 0.5;
        
        CGContextMoveToPoint(h, minx, midy);
        CGContextAddArcToPoint(h, minx, miny, midx, miny, _roundSize);
        CGContextAddArcToPoint(h, maxx, miny, maxx, midy, _roundSize);
        CGContextAddArcToPoint(h, maxx, maxy, midx, maxy, _roundSize);
        CGContextAddArcToPoint(h, minx, maxy, minx, midy, _roundSize);
        
    }
    else 
    {
        return;
    }
    
    // Close the path
    CGContextClosePath(h);  
    CGContextDrawPath(h, kCGPathStroke);
    
    //
    // STROKE
    //
    
    void(^drawCell)(BOOL filled, BOOL bordered) = ^(BOOL filled, BOOL bordered) {
    
        CGContextRef c = UIGraphicsGetCurrentContext();
        
        minx = CGRectGetMinX(rect) , midx = CGRectGetMidX(rect), maxx = CGRectGetMaxX(rect) ;
        miny = CGRectGetMinY(rect) , midy = CGRectGetMidY(rect) , maxy = CGRectGetMaxY(rect) ;
        
        if (position == CustomCellBackgroundViewPositionTop)
        {
            minx = minx + 0.5;
            miny = miny + 0.5;
            
            maxx = maxx - 0.5;
            maxy = maxy - 0.5;
            
            CGContextMoveToPoint(c, minx, maxy);
            CGContextAddArcToPoint(c, minx, miny, midx, miny, _roundSize);
            CGContextAddArcToPoint(c, maxx, miny, maxx, maxy, _roundSize);
            CGContextAddLineToPoint(c, maxx, maxy);
        }
        else if (position == CustomCellBackgroundViewPositionBottom)
        {
            minx = minx + 0.5;
            
            if (highlighted) {
                miny = miny + 0.5;
            } else {
                miny = miny - 0.5;
            }
            
            maxx = maxx - 0.5;
            maxy = maxy - 1.5;
            
            CGContextMoveToPoint(c, minx, miny);
            CGContextAddArcToPoint(c, minx, maxy, midx, maxy, _roundSize);
            CGContextAddArcToPoint(c, maxx, maxy, maxx, miny, _roundSize);
            CGContextAddLineToPoint(c, maxx, miny);
        }
        else if (position == CustomCellBackgroundViewPositionMiddle)
        {
            minx = minx + 0.5;
            
            if (highlighted) {
                miny = miny + 0.5;
            } else {
                miny = miny - 0.5;
            }
            
            maxx = maxx - 0.5;
            maxy = maxy - 0.5;
            
            CGContextMoveToPoint(c, minx, miny);
            CGContextAddLineToPoint(c, maxx, miny);
            CGContextAddLineToPoint(c, maxx, maxy);
            CGContextAddLineToPoint(c, minx, maxy);
        }
        else if (position == CustomCellBackgroundViewPositionSingle)
        {
            minx = minx + 0.5;
            miny = miny + 0.5;
            
            maxx = maxx - 0.5;
            maxy = maxy - 1.5;
            
            CGContextMoveToPoint(c, minx, midy);
            CGContextAddArcToPoint(c, minx, miny, midx, miny, _roundSize);
            CGContextAddArcToPoint(c, maxx, miny, maxx, midy, _roundSize);
            CGContextAddArcToPoint(c, maxx, maxy, midx, maxy, _roundSize);
            CGContextAddArcToPoint(c, minx, maxy, minx, midy, _roundSize);
        }
        
        // Close the path
        CGContextClosePath(c);
        
        // Set border as stroke color
        if (highlighted) {
            CGContextSetStrokeColorWithColor(c, [[_borderColor colorByDarkeningTo:0.5] CGColor]);
        } else {
            CGContextSetStrokeColorWithColor(c, [_borderColor CGColor]);
        }
        
        // Set stroke width
        CGContextSetLineWidth(c, 1);
        
        // Set fill
        CGContextSetFillColorWithColor(c, [_fillColor CGColor]);
        
        // Just Fill
        if (filled && !bordered) {
            CGContextFillPath(c);
        }
        // Just bordered
        else if (bordered && !filled) {
            CGContextDrawPath(c, kCGPathStroke);
        }
        // Filled and bordered
        else if (bordered && filled) {
            CGContextDrawPath(c, kCGPathFillStroke);
        }    
    };
    
    drawCell(YES, NO);
    
    //
    // SINGLE INNER SHADOW
    //
    
    // Since we're "pressed" when highlighted, don't show the inner shadow unless we're not highlighted
    if (position == CustomCellBackgroundViewPositionSingle && !highlighted)
    {
        CGContextRef is = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(is, [_innerShadowColor CGColor]);
        
        CGContextSetLineWidth(is, 1);
        
        CGFloat minx = CGRectGetMinX(rect) , midx = CGRectGetMidX(rect), maxx = CGRectGetMaxX(rect) ;
        CGFloat miny = CGRectGetMinY(rect) , midy = CGRectGetMidY(rect) , maxy = CGRectGetMaxY(rect) ;
        
        minx = minx + 0.5;
        miny = miny + 1.5;
        
        maxx = maxx - 0.5;
        maxy = maxy - 1.5;
        
        CGContextMoveToPoint(is, minx, midy);
        CGContextAddArcToPoint(is, minx, miny, midx, miny, _roundSize);
        CGContextAddArcToPoint(is, maxx, miny, maxx, midy, _roundSize);
        CGContextAddArcToPoint(is, maxx, maxy, midx, maxy, _roundSize);
        CGContextAddArcToPoint(is, minx, maxy, minx, midy, _roundSize);
        
        // Close the path
        CGContextClosePath(is);
        CGContextDrawPath(is, kCGPathStroke);   
    }
    
    drawCell(NO, YES);
    
    //
    // IMAGE DRAWING
    //
    
    if (highlighted) {
        
        UIImage *selectedImage = [self styledGroupedTableViewCellSelectedImageForPosition:position];
        CGRect imageRect = CGRectInset(self.bounds, 1.0, 1.0);
        
        if (position == CustomCellBackgroundViewPositionBottom ||
            position == CustomCellBackgroundViewPositionSingle) {
            
            imageRect.size.height -= 1.0;
        }
        
        [selectedImage drawInRect:imageRect];
    }
}

#pragma mark - Accessors -

#pragma mark borderColor

- (UIColor *)borderColor
{
    return _borderColor;
}

- (void)setBorderColor:(UIColor *)aBorderColor
{
    if (_borderColor != aBorderColor) {
        _borderColor = aBorderColor;
        [self setNeedsDisplay];
    }
}

#pragma mark fillColor

- (UIColor *)fillColor
{
    return _fillColor;
}

- (void)setFillColor:(UIColor *)aFillColor
{
    if (_fillColor != aFillColor) {
        _fillColor = aFillColor;        
        [self setNeedsDisplay];
    }
}

#pragma mark shadowColor

- (UIColor *)shadowColor
{
    return _highlightColor;
}

- (void)setShadowColor:(UIColor *)anHighlightColor
{
    if (_highlightColor != anHighlightColor) {
        _highlightColor = anHighlightColor;
        [self setNeedsDisplay];
    }
}

#pragma mark innerShadowColor

- (UIColor *)innerShadowColor
{
    return _innerShadowColor;
}

- (void)setInnerShadowColor:(UIColor *)anInnerShadowColor
{
    if (_innerShadowColor != anInnerShadowColor) {
        _innerShadowColor = anInnerShadowColor;
        [self setNeedsDisplay];
    }
}

#pragma mark roundSize

- (CGFloat)roundSize
{
    return _roundSize;
}

- (void)setRoundSize:(CGFloat)roundSize
{
    if (_roundSize != roundSize) {
        _roundSize = roundSize;
        [self setNeedsDisplay];
    }
}

@end
