//
//  MSTableView.h
//  MSTableKit
//
//  Created by Fabian Canas on 2/9/13.
//  Copyright (c) 2013 Fabian Canas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSTableView : UITableView

#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0

- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier;

- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;

#endif

@end
