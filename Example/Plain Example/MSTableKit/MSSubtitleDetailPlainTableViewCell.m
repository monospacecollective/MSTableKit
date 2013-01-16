//
//  MSSubtitleDetailPlainTableViewCell.m
//  MSTableKit Example
//
//  Created by Eric Horacek on 12/24/12.
//  Copyright (c) 2012 Monospace Ltd. All rights reserved.
//

#import "MSSubtitleDetailPlainTableViewCell.h"

@implementation MSSubtitleDetailPlainTableViewCell

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
