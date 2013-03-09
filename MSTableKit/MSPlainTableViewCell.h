//
//  MSPlainTableViewCell.h
//  MSTableKit
//
//  created by Eric Horacek & Devon Tivona on 1/4/12.
//  Copyright (c) 2012 Monospace Ltd. All rights reserved.
//

#import "MSTableCell.h"

@class CAGradientLayer;

@interface MSPlainTableViewCell : MSTableCell

@property (nonatomic, strong) CAGradientLayer *backgroundGradient UI_APPEARANCE_SELECTOR;

@end
