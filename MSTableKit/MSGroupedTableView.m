//
//  MSGroupedTableView.m
//  Grouped Example
//
//  Created by Eric Horacek on 1/13/13.
//  Copyright (c) 2013 Monospace Ltd. All rights reserved.
//

#import "MSGroupedTableView.h"

@implementation MSGroupedTableView

#pragma mark - UITableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:UITableViewStyleGrouped];
    if (self) {
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.backgroundView = nil;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

@end
