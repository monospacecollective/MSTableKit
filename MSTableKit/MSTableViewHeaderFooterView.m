//
//  MSTableViewHeaderFooterView.m
//  Grouped Example
//
//  Created by Eric Horacek on 2/1/13.
//  Copyright (c) 2013 Monospace Ltd. All rights reserved.
//

#import "MSTableViewHeaderFooterView.h"
#import "NSObject+FirstAppearanceValue.h"
#import "UILabel+ApplyTextAttributes.h"

//#define LAYOUT_DEBUG

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
    [super layoutSubviews];
    
    self.contentView.frame = UIEdgeInsetsInsetRect((CGRect){CGPointZero, self.frame.size}, self.padding);
    
    CGSize maxTitleSize = CGSizeMake(CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame));
    CGSize titleSize = [self.title.text sizeWithFont:self.title.font constrainedToSize:maxTitleSize lineBreakMode:self.title.lineBreakMode];
    CGRect titleFrame =  self.title.frame;
    titleFrame.size = CGSizeMake(maxTitleSize.width, titleSize.height);
    titleFrame.origin.y = nearbyintf((CGRectGetHeight(self.contentView.frame) / 2.0) - (CGRectGetHeight(titleFrame) / 2.0));
    self.title.frame = titleFrame;

    // Detail is not visible by default
    self.detail.frame = CGRectZero;

#if defined(LAYOUT_DEBUG)
    self.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.25];
    self.contentView.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.25];
    self.title.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
    self.detail.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
#endif
    
    [self configureViews];
}

#pragma mark - UITableViewHeaderFooterView

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    [self configureViews];
}

#pragma mark - UICollectionReusableView

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self configureViews];
}

#pragma mark - MSGroupedTableViewHeaderView

- (void)initialize
{
    _contentView = [UIView new];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.contentView];
    
    _title = [[UILabel alloc] init];
    self.title.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.title];
    
    _detail = [[UILabel alloc] init];
    self.detail.backgroundColor = [UIColor clearColor];
    self.detail.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.detail];
    
    _padding = UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0);
    
    [self configureViews];
    
    self.title.numberOfLines = 0;
}

- (void)configureViews
{
    [self.title applyTextAttributes:self.titleTextAttributes];
    [self.detail applyTextAttributes:self.detailTextAttributes];
}

+ (CGFloat)heightForText:(NSString *)text forWidth:(CGFloat)width
{
    CGFloat height;
    if (!text || [text isEqualToString:@""]) {
        height = 0;
    } else {
        CGSize maxTitleSize = CGSizeMake(width - ([self.appearance padding].left + [self.appearance padding].right), CGFLOAT_MAX);
        UIFont *font = [self firstAppearanceValueMatchingBlock:^id(id appearance) {
            return [appearance titleTextAttributes][UITextAttributeFont];
        }];
        CGSize titleSize = [text sizeWithFont:font constrainedToSize:maxTitleSize];
        height = titleSize.height;
    }
    return (height + ([self.appearance padding].top + [self.appearance padding].bottom));
}

+ (CGFloat)height
{
    
}

+ (void)applyDefaultAppearance
{
    [self.appearance setTitleTextAttributes:@{ UITextAttributeFont : [UIFont boldSystemFontOfSize:17.0] }];
    [self.appearance setDetailTextAttributes:@{ UITextAttributeFont : [UIFont systemFontOfSize:17.0] }];
    CGFloat horizontalPadding = 10.0;
    CGFloat verticalPadding = 0.0;
    [self.appearance setPadding:UIEdgeInsetsMake(verticalPadding, horizontalPadding, verticalPadding, horizontalPadding)];
}

#pragma mark - Text Attributes

- (void)setTitleTextAttributes:(NSDictionary *)titleTextAttributes
{
    _titleTextAttributes = titleTextAttributes;
    [self.title applyTextAttributes:titleTextAttributes];
    [self setNeedsDisplay];
}

- (void)setDetailTextAttributes:(NSDictionary *)detailTextAttributes
{
    _detailTextAttributes = detailTextAttributes;
    [self.detail applyTextAttributes:detailTextAttributes];
    [self setNeedsDisplay];
}

@end
