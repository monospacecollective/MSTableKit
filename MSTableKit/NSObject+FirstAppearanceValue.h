//
//  NSObject+FirstAppearanceValue.h
//  Grouped Example
//
//  Created by Eric Horacek on 3/4/13.
//  Copyright (c) 2013 Monospace Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (FirstAppearanceValue)

+ (id)firstAppearanceValueMatchingBlock:(id (^)(id appearance))block;

@end
