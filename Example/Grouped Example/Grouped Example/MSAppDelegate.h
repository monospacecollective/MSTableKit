//
//  MSAppDelegate.h
//  Grouped Example
//
//  Created by Eric Horacek on 12/26/12.
//  Copyright (c) 2012 Monospace Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MSExampleGroupedTableViewController;

@interface MSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MSExampleGroupedTableViewController *tableViewController;

@end
