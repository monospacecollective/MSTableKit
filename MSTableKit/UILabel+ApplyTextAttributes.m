//
//  UILabel+ApplyTextAttributes.m
//  Grouped Example
//
//  Created by Eric Horacek on 3/4/13.
//  Copyright (c) 2013 Monospace Ltd. All rights reserved.
//

#import "UILabel+ApplyTextAttributes.h"

@implementation UILabel (ApplyTextAttributes)

- (void)applyTextAttributes:(NSDictionary *)attributes
{
    self.font = (attributes[UITextAttributeFont] ? attributes[UITextAttributeFont] : self.font);
	self.textColor = (attributes[UITextAttributeTextColor] ? attributes[UITextAttributeTextColor] : self.textColor);
	self.shadowColor = (attributes[UITextAttributeTextShadowColor] ? attributes[UITextAttributeTextShadowColor] : self.shadowColor);
	self.shadowOffset = (attributes[UITextAttributeTextShadowOffset] ? [attributes[UITextAttributeTextShadowOffset] CGSizeValue] : self.shadowOffset);
}

@end
