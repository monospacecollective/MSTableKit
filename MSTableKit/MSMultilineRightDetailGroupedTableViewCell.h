//
//  MSMultilineRightDetailGroupedTableViewCell.h
//  Grouped Example
//
//  Created by Eric Horacek on 3/6/13.
//  Copyright (c) 2013 Monospace Ltd. All rights reserved.
//

#import "MSRightDetailGroupedTableViewCell.h"

@interface MSMultilineRightDetailGroupedTableViewCell : MSRightDetailGroupedTableViewCell

+ (CGFloat)heightForTitle:(NSString *)title detail:(NSString *)detail forWidth:(CGFloat)width;

@end
