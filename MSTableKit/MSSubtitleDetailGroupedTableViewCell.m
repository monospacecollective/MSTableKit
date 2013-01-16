//
//  MSSubtitleDetailGroupedTableViewCell.m
//  Grouped Example
//
//  Created by Eric Horacek on 1/14/13.
//  Copyright (c) 2013 Monospace Ltd. All rights reserved.
//

#import "MSSubtitleDetailGroupedTableViewCell.h"

@implementation MSSubtitleDetailGroupedTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.detailTextLabel.frame = CGRectOffset(self.detailTextLabel.frame, 0.0, -2.0);
}

@end
