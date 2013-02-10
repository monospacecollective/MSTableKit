//
//  MSTableView.m
//  MSTableKit
//
//  Created by Fabian Canas on 2/9/13.
//  Copyright (c) 2013 Fabian Canas. All rights reserved.
//

#import "MSTableView.h"

#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@interface MSTableView ()
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
@property (nonatomic, strong) NSMutableDictionary *cellClassByReuseIdentifier;
#endif
@end

@implementation MSTableView

#pragma mark - iOS 5 Bridge

#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0

- (NSMutableDictionary *)cellClassByReuseIdentifier {
    if (_cellClassByReuseIdentifier == nil) {
        self.cellClassByReuseIdentifier = [NSMutableDictionary new];
    }
    return _cellClassByReuseIdentifier;
}

- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier {
    if (SYSTEM_VERSION_LESS_THAN(@"6.0")) {
        if (cellClass == nil) {
            [self.cellClassByReuseIdentifier removeObjectForKey:identifier];
        } else {
            [self.cellClassByReuseIdentifier setObject:cellClass forKey:identifier];
        }
    } else {
        [super registerClass:cellClass forCellReuseIdentifier:identifier];
    }
}

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier {
    if (SYSTEM_VERSION_LESS_THAN(@"6.0")) {
        id cell = [super dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            Class registeredClass = [self.cellClassByReuseIdentifier objectForKey:identifier];
            cell = [[registeredClass alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:identifier];
        }
        return cell;
    } else {
        return [super dequeueReusableCellWithIdentifier:identifier];
    }
};

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
    if (SYSTEM_VERSION_LESS_THAN(@"6.0")) {
        return [self dequeueReusableCellWithIdentifier:identifier];
    } else {
        return [super dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    }
}

#endif

@end
