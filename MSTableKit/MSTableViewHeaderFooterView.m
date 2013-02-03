//
//  MSTableViewHeaderFooterView.m
//  Grouped Example
//
//  Created by Eric Horacek on 2/1/13.
//  Copyright (c) 2013 Monospace Ltd. All rights reserved.
//

#import "MSTableViewHeaderFooterView.h"

//#define LAYOUT_DEBUG

@interface MSTableViewHeaderFooterView ()

+ (void)applyDefaultAppearance;
- (void)applyTextAttributes:(NSDictionary *)attributes toLabel:(UILabel *)label;

@end

@implementation MSTableViewHeaderFooterView

#pragma mark - NSObject

+ (void)initialize
{
    [super initialize];
    [self applyDefaultAppearance];
}

#pragma mark - UIView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)layoutSubviews
{
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
    [super layoutSubviews];
#endif
    
    CGFloat maxTextLabelWidth = (CGRectGetWidth(self.frame) - (self.class.padding.width * 2.0));
    CGSize textLabelSize = [self.textLabel.text sizeWithFont:self.textLabel.font constrainedToSize:CGSizeMake(maxTextLabelWidth, CGFLOAT_MAX)];
    textLabelSize.width = maxTextLabelWidth;
    
    CGRect textLabelFrame = self.textLabel.frame;
    textLabelFrame.size = textLabelSize;
    textLabelFrame.origin = (CGPoint){self.class.padding.width, self.class.padding.height};
    
    self.textLabel.frame = textLabelFrame;
    
    [self configureViews];
}

#pragma mark - UITableViewHeaderFooterView

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    [self configureViews];
}

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_6_0
- (void)prepareForReuse
{
    [super prepareForReuse];
    [self configureViews];
}
#endif

#pragma mark - MSGroupedTableViewHeaderView

- (void)initialize
{
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
    _textLabel = [[UILabel alloc] init];
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.textLabel.font = [UIFont boldSystemFontOfSize:17.0];
    [self addSubview:self.textLabel];
    
    _detailTextLabel = [[UILabel alloc] init];
    self.detailTextLabel.backgroundColor = [UIColor clearColor];
    self.detailTextLabel.font = [UIFont systemFontOfSize:17.0];
    [self addSubview:self.detailTextLabel];
    
    [self configureViews];
#else
    // This is required for the text views to be added as subviews
    [super layoutSubviews];
#endif
    
    self.textLabel.numberOfLines = 0;
    
#if defined(LAYOUT_DEBUG)
    self.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
    self.textLabel.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
#endif
}

- (void)configureViews
{
    [self applyTextAttributes:self.titleTextAttributes toLabel:self.textLabel];
    [self applyTextAttributes:self.detailTextAttributes toLabel:self.detailTextLabel];
}

- (void)applyTextAttributes:(NSDictionary *)attributes toLabel:(UILabel *)label
{
	label.font = (attributes[UITextAttributeFont] ? attributes[UITextAttributeFont] : label.font);
	label.textColor = (attributes[UITextAttributeTextColor] ? attributes[UITextAttributeTextColor] : label.textColor);
	label.shadowColor = (attributes[UITextAttributeTextShadowColor] ? attributes[UITextAttributeTextShadowColor] : label.shadowColor);
	label.shadowOffset = (attributes[UITextAttributeTextShadowOffset] ? [attributes[UITextAttributeTextShadowOffset] CGSizeValue] : label.shadowOffset);
}

+ (CGFloat)heightForText:(NSString *)text forWidth:(CGFloat)width
{
    if (!text || [text isEqualToString:@""]) {
        return 0.0;
    }
    CGFloat maxTextLabelWidth = (width - (self.padding.width * 2.0));
    UIFont *font = ([self.appearance titleTextAttributes][UITextAttributeFont] ? [self.appearance titleTextAttributes][UITextAttributeFont] : [self defaultTextLabelFont]);
    CGSize textLabelSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(maxTextLabelWidth, CGFLOAT_MAX)];
    return textLabelSize.height + (self.padding.height * 2.0);
}

+ (CGSize)padding
{
    NSAssert(NO, @"This method should be overridden by subclasses");
    return CGSizeZero;
}

+ (UIFont *)defaultTextLabelFont
{
    NSAssert(NO, @"This method should be overridden by subclasses");
    return nil;
}

+ (void)applyDefaultAppearance
{
    
}

@end