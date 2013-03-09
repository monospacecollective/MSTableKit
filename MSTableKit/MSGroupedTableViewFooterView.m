//
//  MSGroupedTableViewFooterView.m
//  MSTableKit
//
//  Created by Eric Horacek on 2/1/13.
//  Copyright (c) 2013 Monospace Ltd. All rights reserved.
//

#import "MSGroupedTableViewFooterView.h"

@implementation MSGroupedTableViewFooterView

- (void)initialize
{
    [super initialize];
    self.title.numberOfLines = 0;
    self.title.textAlignment = NSTextAlignmentCenter;
}

+ (void)applyDefaultAppearance
{
    [self.appearance setTitleTextAttributes:@{ UITextAttributeFont : [UIFont systemFontOfSize:15.0] }];
    
    CGFloat horizontalPadding = ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 54.0 : 20.0);
    CGFloat verticalPadding = 8.0;
    [self.appearance setPadding:UIEdgeInsetsMake(verticalPadding, horizontalPadding, verticalPadding, horizontalPadding)];
}


@end
