//
//  MSAppDelegate.h
//  Plain Example
//
//  Created by Eric Horacek on 12/25/12.
//  Copyright (c) 2012 Monospace Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MSExamplePlainTableViewController;

@interface MSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MSExamplePlainTableViewController *tableViewController;

@end
