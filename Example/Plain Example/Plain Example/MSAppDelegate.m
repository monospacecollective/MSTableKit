//
//  MSAppDelegate.m
//  Plain Example
//
//  Created by Eric Horacek on 12/25/12.
//  Copyright (c) 2012 Monospace Ltd. All rights reserved.
//

#import "MSAppDelegate.h"
#import "MSExamplePlainTableViewController.h"
#import "MSPlainTableView.h"
#import "KGNoise.h"

@implementation MSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Cell Theming
    CGFloat color = 0.0;
    UIColor *backgroundColor = [UIColor colorWithWhite:(0.2 + (0.6 * color)) alpha:1.0];
    
    UIColor *tableViewBackgroundColor = [backgroundColor colorWithNoiseWithOpacity:(0.2 - (color * 0.1)) andBlendMode:kCGBlendModeMultiply];
    [[UITableView appearance] setBackgroundColor:tableViewBackgroundColor];
    
    UIColor *cellEtchHighlightColor = [UIColor colorWithWhite:1.0 alpha:(0.1 + (color * 0.45))];
    UIColor *cellEtchShadowColor = [UIColor colorWithWhite:(0.0 + (0.5 * color)) alpha:1.0];
    UIColor *textColor = (color > 0.5) ? [UIColor blackColor] : [UIColor whiteColor];
    
    [[MSPlainTableViewCell appearanceWhenContainedIn:MSPlainTableView.class, nil] setEtchHighlightColor:cellEtchHighlightColor];
    [[MSPlainTableViewCell appearanceWhenContainedIn:MSPlainTableView.class, nil] setEtchShadowColor:cellEtchShadowColor];
    [[MSPlainTableViewCell appearanceWhenContainedIn:MSPlainTableView.class, nil] setTitleTextColor:textColor];
    [[MSPlainTableViewCell appearanceWhenContainedIn:MSPlainTableView.class, nil] setDetailTextColor:textColor];
    
    UIColor *headerTopEtchHighlightColor = [UIColor colorWithWhite:1.0 alpha:(0.1 + (color * 0.3))];
    UIColor *headerTopEtchShadowColor = [UIColor colorWithWhite:(0.0 + (0.5 * color)) alpha:1.0];
    UIColor *headerBottomEtchShadowColor = [UIColor colorWithWhite:(0.0 + (0.3 * color)) alpha:1.0];
    
    [[MSPlainTableViewHeaderView appearanceWhenContainedIn:MSPlainTableView.class, nil] setTopEtchHighlightColor:headerTopEtchHighlightColor];
    [[MSPlainTableViewHeaderView appearanceWhenContainedIn:MSPlainTableView.class, nil] setTopEtchShadowColor:headerTopEtchShadowColor];
    [[MSPlainTableViewHeaderView appearanceWhenContainedIn:MSPlainTableView.class, nil] setBottomEtchShadowColor:headerBottomEtchShadowColor];
    [[MSPlainTableViewHeaderView appearanceWhenContainedIn:MSPlainTableView.class, nil] setTextColor:textColor];
    [[MSPlainTableViewHeaderView appearanceWhenContainedIn:MSPlainTableView.class, nil] setBackgroundColor:[UIColor blackColor]];
    
    CGSize textShadowOffset;
    UIColor *cellTextShadowColor;
    UIColor *headerTextShadowColor;
    if (color > 0.5) {
        textShadowOffset = CGSizeMake(0.0, 1.0);
        cellTextShadowColor = cellEtchHighlightColor;
        headerTextShadowColor = headerTopEtchHighlightColor;
    } else {
        textShadowOffset = CGSizeMake(0.0, -1.0);
        cellTextShadowColor = cellEtchShadowColor;
        headerTextShadowColor = cellEtchShadowColor;
    }
    
    // MSPlainTableViewCell
    [[UILabel appearanceWhenContainedIn:MSPlainTableViewCell.class, UIViewController.class, nil] setShadowOffset:textShadowOffset];
    [[UILabel appearanceWhenContainedIn:MSPlainTableViewCell.class, UIViewController.class, nil] setShadowColor:cellTextShadowColor];
    
    // MSPlainTableViewHeaderView
    [[UILabel appearanceWhenContainedIn:MSPlainTableViewHeaderView.class, UIViewController.class, nil] setShadowOffset:textShadowOffset];
    [[UILabel appearanceWhenContainedIn:MSPlainTableViewHeaderView.class, UIViewController.class, nil] setShadowColor:headerTextShadowColor];
    
    self.tableViewController = [[MSExamplePlainTableViewController alloc] initWithNibName:nil bundle:nil];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.tableViewController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
