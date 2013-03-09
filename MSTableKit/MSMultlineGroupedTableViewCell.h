//
//  MSMultlineGroupedTableViewCell.h
//  Grouped Example
//
//  Created by Eric Horacek on 3/4/13.
//  Copyright (c) 2013 Monospace Ltd. All rights reserved.
//

#import "MSGroupedTableViewCell.h"

@interface MSMultlineGroupedTableViewCell : MSGroupedTableViewCell

+ (CGFloat)heightForText:(NSString *)text forWidth:(CGFloat)width;

@end
