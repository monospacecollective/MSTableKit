//
//  MSGroupedTableViewFooterView.m
//  MSTableKit
//
//  Created by Eric Horacek on 2/1/13.
//  Copyright (c) 2013 Monospace Ltd. All rights reserved.
//

#import "MSGroupedTableViewFooterView.h"

//#define LAYOUT_DEBUG

@implementation MSGroupedTableViewFooterView

#pragma mark - MSTableViewHeaderFooterView

- (void)initialize
{
    [super initialize];
    self.textLabel.numberOfLines = 0;
    self.textLabel.font = self.class.defaultTextLabelFont;
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_6_0
    self.textLabel.textAlignment = NSTextAlignmentCenter;
#else
    self.textLabel.textAlignment = UITextAlignmentCenter;
#endif
    self.detailTextLabel.hidden = YES;
    
#if defined(LAYOUT_DEBUG)
    self.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
    self.textLabel.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
#endif
}

+ (CGSize)padding
{
    CGFloat horizontalPadding = ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 54.0 : 20.0);
    CGFloat verticalPadding = 8.0;
    return CGSizeMake(horizontalPadding, verticalPadding);
}

+ (UIFont *)defaultTextLabelFont
{
    return [UIFont systemFontOfSize:15.0];
}

@end
