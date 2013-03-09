//
//  MSTableCellEtch.m
//  Plain Example
//
//  Created by Eric Horacek on 3/5/13.
//  Copyright (c) 2013 Monospace Ltd. All rights reserved.
//

#import "MSTableCellEtch.h"
#import <QuartzCore/QuartzCore.h>

@implementation MSTableCellEtch

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.layer.shadowColor = [[UIColor colorWithWhite:1.0 alpha:0.1] CGColor];
        self.layer.shadowOpacity = 1.0;
        self.layer.shadowRadius = 0.0;
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.layer.shadowPath = [[UIBezierPath bezierPathWithRect:(CGRect){CGPointMake(0.0, 4.0), self.frame.size }] CGPath];
}
@end
