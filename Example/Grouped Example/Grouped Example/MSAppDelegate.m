//
//  MSAppDelegate.m
//  Grouped Example
//
//  Created by Eric Horacek on 12/26/12.
//  Copyright (c) 2012 Monospace Ltd. All rights reserved.
//

#import "MSAppDelegate.h"
#import "MSExampleGroupedTableViewController.h"
#import "KGNoise.h"
#import "MSTableViewCell.h"

@implementation MSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.tableViewController = [[MSExampleGroupedTableViewController alloc] initWithNibName:nil bundle:nil];
    
    CGFloat color = 1.0;
    UIColor* backgroundColor = [UIColor colorWithWhite:(0.2 + (0.6 * color)) alpha:1.0];
    backgroundColor = [backgroundColor colorWithNoiseWithOpacity:(0.2 - (color * 0.1)) andBlendMode:kCGBlendModeMultiply];
    [[UITableView appearance] setBackgroundColor:backgroundColor];
    
    [[UILabel appearanceWhenContainedIn:MSTableViewCell.class, nil] setShadowColor:[UIColor colorWithWhite:1.0 alpha:0.5]];
    [[UILabel appearanceWhenContainedIn:MSTableViewCell.class, nil] setShadowOffset:CGSizeMake(0.0, 1.0)];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.tableViewController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
