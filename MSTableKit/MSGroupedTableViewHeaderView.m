//
//  MSGroupedTableViewHeaderView.m
//  Grouped Example
//
//  Created by Eric Horacek on 1/14/13.
//  Copyright (c) 2013 Monospace Ltd. All rights reserved.
//

#import "MSGroupedTableViewHeaderView.h"

@implementation MSGroupedTableViewHeaderView

#pragma mark - MSGroupedTableViewHeaderView

- (void)initialize
{
    [super initialize];
    
    self.textLabel.font = self.class.defaultTextLabelFont;
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_6_0
    self.textLabel.textAlignment = NSTextAlignmentLeft;
#else
    self.textLabel.textAlignment = UITextAlignmentLeft;
#endif
    self.detailTextLabel.hidden = YES;
}

+ (CGSize)padding
{
    CGFloat horizontalPadding = ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 54.0 : 20.0);
    return CGSizeMake(horizontalPadding, 6.0);
}

@end
