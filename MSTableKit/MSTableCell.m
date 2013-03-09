//
//  MSTableCell.m
//  Plain Example
//
//  Created by Eric Horacek on 12/25/12.
//  Copyright (c) 2012 Monospace Ltd. All rights reserved.
//

#import "MSTableCell.h"
#import "UILabel+ApplyTextAttributes.h"

//#define LAYOUT_DEBUG

#define ControlStatePresentInMask(state,mask) ({ __typeof__(state) __s = (state); __typeof__(mask) __m = (mask); (__s == UIControlStateNormal) ? (__m == UIControlStateNormal) : ((__m & __s) == __s); })

@interface MSTableCell () {
    NSMutableDictionary *_titleTextAttributesForState;
    NSMutableDictionary *_detailTextAttributesForState;
    NSMutableDictionary *_accessoryTextAttributesForState;
    NSMutableDictionary *_accessoryCharacterForAccessoryType;
    MSTableCellSelectionStyle _selectionStyle;
}

- (void)setValue:(id)value inStateDictionary:(NSMutableDictionary *)stateDictionary forState:(UIControlState)state;
- (id)valueInStateDictionary:(NSDictionary *)stateDictionary forControlState:(UIControlState)state;

@end

@implementation MSTableCell

@dynamic controlState;

#pragma mark - NSObject

+ (void)initialize
{
    [super initialize];
    [self applyDefaultAppearance];
}

#pragma mark - UIView

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.contentView.frame = UIEdgeInsetsInsetRect((CGRect){CGPointZero, self.frame.size}, self.padding);
    self.backgroundView.frame = UIEdgeInsetsInsetRect((CGRect){CGPointZero, self.frame.size}, self.backgroundViewPadding);
    
    // Accessory Sizing
    [self.accessoryView sizeToFit];
    CGRect accessoryViewFrame = self.accessoryView.frame;
    accessoryViewFrame.origin.x = CGRectGetWidth(self.contentView.frame) - CGRectGetWidth(accessoryViewFrame);
    accessoryViewFrame.origin.y = nearbyintf((CGRectGetHeight(self.contentView.frame) / 2.0) - (CGRectGetHeight(accessoryViewFrame) / 2.0));
    self.accessoryView.frame = accessoryViewFrame;
    
    // Title Sizing
    CGSize maxTitleSize;
    if (self.accessoryView) {
        maxTitleSize = CGSizeMake((CGRectGetMinX(self.accessoryView.frame) - self.contentMargin), CGRectGetHeight(self.contentView.frame));
    } else {
        maxTitleSize = CGSizeMake(CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame));
    }
    CGSize titleSize = [self.title.text sizeWithFont:self.title.font constrainedToSize:maxTitleSize lineBreakMode:self.title.lineBreakMode];
    CGRect titleFrame =  self.title.frame;
    titleFrame.size = CGSizeMake(maxTitleSize.width, titleSize.height);
    titleFrame.origin.y = nearbyintf((CGRectGetHeight(self.contentView.frame) / 2.0) - (CGRectGetHeight(titleFrame) / 2.0));
    titleFrame.origin.x = 0.0;
    self.title.frame = titleFrame;
    
    // Detail Sizing (Detail is not visible by default)
    self.detail.frame = CGRectZero;
    
#if defined(LAYOUT_DEBUG)
    // Color the background of the labels in the content view red
    for (UIView *subview in self.contentView.subviews) {
        if ([subview isKindOfClass:UILabel.class]) {
            subview.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
        }
    }
    self.contentView.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.25];
    self.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.25];
#endif
}

#pragma mark - UITableViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)setAccessoryType:(MSTableCellAccessoryType)accessoryType
{
//    [super setAccessoryType:accessoryType];
    _accessoryType = accessoryType;
    
    switch (accessoryType) {
        case UITableViewCellAccessoryNone: {
            [self.accessoryView removeFromSuperview];
            self.accessoryView = nil;
            break;
        }
        case MSTableCellAccessoryDisclosureIndicator:
        case MSTableCellAccessoryCheckmark:
        case MSTableCellAccessoryStarFull:
        case MSTableCellAccessoryStarEmpty: {
            self.accessory.text = [self accessoryCharacterForAccessoryType:accessoryType];
            [self.accessory sizeToFit];
            self.accessoryView = self.accessory;
            [self.contentView addSubview:self.accessoryView];
            break;
        }
        case UITableViewCellAccessoryDetailDisclosureButton: {
            break;
        }
    }
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self layoutSubviews];
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    [self configureViews];
    [self.backgroundView setNeedsLayout];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    [self configureViews];
    [self.backgroundView setNeedsLayout];
}

#pragma mark - MSTableCell

- (void)initialize
{
    _selectionStyle = MSTableCellSelectionStyleIndent;
    
    _titleTextAttributesForState = [NSMutableDictionary new];
    _detailTextAttributesForState = [NSMutableDictionary new];
    _accessoryTextAttributesForState = [NSMutableDictionary new];
    _accessoryCharacterForAccessoryType = [NSMutableDictionary new];
    
    _title = [UILabel new];
    self.title.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.title];
    
    _detail = [UILabel new];
    self.detail.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.detail];
    
    _accessory = [[UILabel alloc] init];
    self.accessory.backgroundColor = [UIColor clearColor];
    self.accessory.font = [UIFont fontWithName:@"Zapf Dingbats" size:18.0];
    
    _accessoryCharacterForAccessoryType[@(MSTableCellAccessoryCheckmark)] = @"\U00002713";
    _accessoryCharacterForAccessoryType[@(MSTableCellAccessoryDisclosureIndicator)] = @"\U0000276F";
    _accessoryCharacterForAccessoryType[@(MSTableCellAccessoryStarFull)] = @"\U00002605";
    _accessoryCharacterForAccessoryType[@(MSTableCellAccessoryStarEmpty)] = @"\U00002606";
    
    [self configureViews];
}

- (void)configureViews
{
    [self.title applyTextAttributes:[self titleTextAttributesForState:self.controlState]];
    [self.detail applyTextAttributes:[self detailTextAttributesForState:self.controlState]];
    [self.accessory applyTextAttributes:[self accessoryTextAttributesForState:self.controlState]];
    
    self.accessory.text = [self accessoryCharacterForAccessoryType:self.accessoryType];
    [self.accessory sizeToFit];
}

+ (void)applyDefaultAppearance
{
    CGFloat horizontalPadding = 10.0;
    CGFloat verticalPadding = 0.0;
    [self.appearance setPadding:UIEdgeInsetsMake(verticalPadding, horizontalPadding, verticalPadding, horizontalPadding)];
    [self.appearance setContentMargin:5.0];
}

+ (CGFloat)height
{
    return 44.0;
}

#pragma mark Control State Accessors

- (UIControlState)controlState
{
    BOOL selectable = (self.selectionStyle != MSTableCellSelectionStyleNone);
    
    if (selectable && self.selected) {
        return UIControlStateSelected;
    } else if (selectable && self.highlighted) {
        return UIControlStateHighlighted;
    } else {
        return UIControlStateNormal;
    }
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

- (void)setTitleTextAttributes:(NSDictionary *)textAttributes forState:(UIControlState)state
{
    [self setValue:textAttributes inStateDictionary:_titleTextAttributesForState forState:state];
    if (ControlStatePresentInMask(self.controlState, state)) {
        [self.title applyTextAttributes:textAttributes];
    }
    [self setNeedsDisplay];
}

- (void)setDetailTextAttributes:(NSDictionary *)textAttributes forState:(UIControlState)state
{
    [self setValue:textAttributes inStateDictionary:_detailTextAttributesForState forState:state];
    if (ControlStatePresentInMask(self.controlState, state)) {
        [self.detail applyTextAttributes:textAttributes];
    }
    [self setNeedsDisplay];
}

- (void)setAccessoryTextAttributes:(NSDictionary *)textAttributes forState:(UIControlState)state
{
    [self setValue:textAttributes inStateDictionary:_accessoryTextAttributesForState forState:state];
    if (ControlStatePresentInMask(self.controlState, state)) {
        [self.accessory applyTextAttributes:textAttributes];
    }
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

- (NSDictionary *)titleTextAttributesForState:(UIControlState)state
{
    return [self valueInStateDictionary:_titleTextAttributesForState forControlState:state];
}

- (NSDictionary *)detailTextAttributesForState:(UIControlState)state
{
    return [self valueInStateDictionary:_detailTextAttributesForState forControlState:state];
}

- (NSDictionary *)accessoryTextAttributesForState:(UIControlState)state
{
    return [self valueInStateDictionary:_accessoryTextAttributesForState forControlState:state];
}

#pragma mark - UITableViewCellAccessoryType Accessors

- (void)setAccessoryCharacter:(NSString *)accessoryCharacter forAccessoryType:(MSTableCellAccessoryType)accessoryType
{
    _accessoryCharacterForAccessoryType[@(accessoryType)] = accessoryCharacter;
    [self configureViews];
    [self setNeedsDisplay];
}

- (NSString *)accessoryCharacterForAccessoryType:(MSTableCellAccessoryType)accessoryType UI_APPEARANCE_SELECTOR
{
    return _accessoryCharacterForAccessoryType[@(accessoryType)];
}

@end
