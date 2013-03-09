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
    self.title.textAlignment = NSTextAlignmentLeft;
}

+ (void)applyDefaultAppearance
{
    [self.appearance setTitleTextAttributes:@{ UITextAttributeFont : [UIFont boldSystemFontOfSize:17.0] }];
    
//    CGFloat horizontalPadding = ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 54.0 : 20.0);
//    CGFloat verticalPadding = 6.0;
//    [self.appearance setPadding:UIEdgeInsetsMake(verticalPadding, horizontalPadding, verticalPadding, horizontalPadding)];
}

@end
