//
//  MSTableViewCell.m
//  Plain Example
//
//  Created by Eric Horacek on 12/25/12.
//  Copyright (c) 2012 Monospace Ltd. All rights reserved.
//

#import "MSTableViewCell.h"

//#define LAYOUT_DEBUG

#define ControlStatePresentInMask(state,mask) ({ __typeof__(state) __s = (state); __typeof__(mask) __m = (mask); (__s == UIControlStateNormal) ? (__m == UIControlStateNormal) : ((__m & __s) == __s); })

@interface MSTableViewCell () {
    NSMutableDictionary *_titleTextAttributesForState;
    NSMutableDictionary *_detailTextAttributesForState;
    NSMutableDictionary *_accessoryTextAttributesForState;
    NSMutableDictionary *_accessoryCharacterForAccessoryType;
    MSTableViewCellSelectionStyle _selectionStyle;
}

- (void)applyTextAttributes:(NSDictionary *)attributes toLabel:(UILabel *)label;

- (void)setValue:(id)value inStateDictionary:(NSMutableDictionary *)stateDictionary forState:(UIControlState)state;
- (id)valueInStateDictionary:(NSDictionary *)stateDictionary forControlState:(UIControlState)state;

@end

@implementation MSTableViewCell

@dynamic controlState;

#pragma mark - UIView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.accessoryTextLabel sizeToFit];
    
#if defined(LAYOUT_DEBUG)
    // Color the background of the labels in the content view red
    for (UIView *subview in self.contentView.subviews) {
        if ([subview isKindOfClass:UILabel.class]) {
            subview.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
        }
    }
#endif
}

#pragma mark - UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
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

- (void)setAccessoryType:(UITableViewCellAccessoryType)accessoryType
{
    [super setAccessoryType:accessoryType];
    switch (accessoryType) {
        case UITableViewCellAccessoryNone: {
            [self.accessoryView removeFromSuperview];
            self.accessoryView = nil;
            break;
        }
        case UITableViewCellAccessoryDisclosureIndicator:
        case UITableViewCellAccessoryCheckmark: {
            self.accessoryTextLabel.text = [self accessoryCharacterForAccessoryType:accessoryType];
            [self.accessoryTextLabel sizeToFit];
            self.accessoryView = self.accessoryTextLabel;
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
    self.detailTextLabel.text = nil;
    self.textLabel.text = nil;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    [self updateBackgroundState:((self.selected || self.highlighted) && self.selectionStyle != MSTableViewCellSelectionStyleNone) animated:animated];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    [self updateBackgroundState:((self.selected || self.highlighted) && self.selectionStyle != MSTableViewCellSelectionStyleNone) animated:animated];
}

#pragma mark - MSTableViewCell

- (void)initialize
{
    // Overridding default UITableViewCell stuff
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.detailTextLabel.backgroundColor = [UIColor clearColor];
    
    [super setSelectionStyle:UITableViewCellSelectionStyleNone];
    _selectionStyle = MSTableViewCellSelectionStyleIndent;
    
    _titleTextAttributesForState = [NSMutableDictionary new];
    _detailTextAttributesForState = [NSMutableDictionary new];
    _accessoryTextAttributesForState = [NSMutableDictionary new];
    _accessoryCharacterForAccessoryType = [NSMutableDictionary new];
    
    _accessoryCharacterForAccessoryType[@(UITableViewCellAccessoryCheckmark)] = @"\U00002713";
    _accessoryCharacterForAccessoryType[@(UITableViewCellAccessoryDisclosureIndicator)] = @"\U0000276F";
    
    _accessoryTextLabel = [[UILabel alloc] init];
    self.accessoryTextLabel.backgroundColor = [UIColor clearColor];
    self.accessoryTextLabel.font = [UIFont fontWithName:@"Zapf Dingbats" size:18.0];
    
    [self configureViews];
}

- (void)configureViews
{
    [self applyTextAttributes:[self titleTextAttributesForState:self.controlState] toLabel:self.textLabel];
    [self applyTextAttributes:[self detailTextAttributesForState:self.controlState] toLabel:self.detailTextLabel];
    [self applyTextAttributes:[self accessoryTextAttributesForState:self.controlState] toLabel:self.accessoryTextLabel];
    
    self.accessoryTextLabel.text = [self accessoryCharacterForAccessoryType:self.accessoryType];
    [self.accessoryTextLabel sizeToFit];
}

- (void)updateBackgroundState:(BOOL)darkened animated:(BOOL)animated
{
    [self configureViews];
}

- (void)applyTextAttributes:(NSDictionary *)attributes toLabel:(UILabel *)label
{
	label.font = (attributes[UITextAttributeFont] ? attributes[UITextAttributeFont] : label.font);
	label.textColor = (attributes[UITextAttributeTextColor] ? attributes[UITextAttributeTextColor] : label.textColor);
	label.shadowColor = (attributes[UITextAttributeTextShadowColor] ? attributes[UITextAttributeTextShadowColor] : label.shadowColor);
	label.shadowOffset = (attributes[UITextAttributeTextShadowOffset] ? [attributes[UITextAttributeTextShadowOffset] CGSizeValue] : label.shadowOffset);
}

#pragma mark Selection Style Accessors

- (void)setSelectionStyle:(NSInteger)selectionStyle
{
    _selectionStyle = selectionStyle;
}

- (NSInteger)selectionStyle
{
    return _selectionStyle;
}

#pragma mark Control State Accessors

- (UIControlState)controlState
{
    BOOL selectable = (self.selectionStyle != MSTableViewCellSelectionStyleNone);
    
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
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
    if (ControlStatePresentInMask(self.controlState, state)) {
        [self applyTextAttributes:textAttributes toLabel:self.textLabel];
    }
#endif
    [self setNeedsDisplay];
}

- (void)setDetailTextAttributes:(NSDictionary *)textAttributes forState:(UIControlState)state
{
    [self setValue:textAttributes inStateDictionary:_detailTextAttributesForState forState:state];
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
    if (ControlStatePresentInMask(self.controlState, state)) {
        [self applyTextAttributes:textAttributes toLabel:self.detailTextLabel];
    }
#endif
    [self setNeedsDisplay];
}

- (void)setAccessoryTextAttributes:(NSDictionary *)textAttributes forState:(UIControlState)state
{
    [self setValue:textAttributes inStateDictionary:_accessoryTextAttributesForState forState:state];
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
    if (ControlStatePresentInMask(self.controlState, state)) {
        [self applyTextAttributes:textAttributes toLabel:self.accessoryTextLabel];
    }
#endif
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

- (void)setAccessoryCharacter:(NSString *)accessoryCharacter forAccessoryType:(UITableViewCellAccessoryType)accessoryType
{
    _accessoryCharacterForAccessoryType[@(accessoryType)] = accessoryCharacter;
    [self configureViews];
    [self setNeedsDisplay];
}

- (NSString *)accessoryCharacterForAccessoryType:(UITableViewCellAccessoryType)accessoryType UI_APPEARANCE_SELECTOR
{
    return _accessoryCharacterForAccessoryType[@(accessoryType)];
}

@end
