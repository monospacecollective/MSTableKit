//
//  NSObject+FirstAppearanceValue.m
//  Grouped Example
//
//  Created by Eric Horacek on 3/4/13.
//  Copyright (c) 2013 Monospace Ltd. All rights reserved.
//

#import "NSObject+FirstAppearanceValue.h"

@implementation NSObject (FirstAppearanceValue)

+ (id)firstAppearanceValueMatchingBlock:(id (^)(id appearance))block
{
    id value;
    Class class = self.class;
    Class superclass;
    while ((superclass = [class superclass])) {
        if (![class conformsToProtocol:@protocol(UIAppearanceContainer)]) {
            break;
        }
        value = block([class appearance]);
        if (value) {
            break;
        }
        class = superclass;
    }
    return value;
}

@end
