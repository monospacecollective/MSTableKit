//
//  MSAppDelegate.m
//  Grouped Example
//
//  Created by Eric Horacek on 12/26/12.
//  Copyright (c) 2012 Monospace Ltd. All rights reserved.
//

#import "MSAppDelegate.h"
#import "KGNoise.h"
#import "MSTableKit.h"
#import "MSExampleGroupedTableViewController.h"

@implementation MSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.tableViewController = [[MSExampleGroupedTableViewController alloc] init];
    
    CGFloat color = 1.0;
    UIColor* backgroundColor = [UIColor colorWithWhite:(0.2 + (0.6 * color)) alpha:1.0];
    backgroundColor = [backgroundColor colorWithNoiseWithOpacity:(0.2 - (color * 0.1)) andBlendMode:kCGBlendModeMultiply];
    [[UITableView appearance] setBackgroundColor:backgroundColor];
    
    UIColor *shadowColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    NSValue *shadowOffset = [NSValue valueWithCGSize:CGSizeMake(0, 1.0)];
    
    [[MSGroupedTableViewCell appearance] setTitleTextAttributes:@{
                               UITextAttributeTextColor : [UIColor blackColor],
                         UITextAttributeTextShadowColor : shadowColor,
                        UITextAttributeTextShadowOffset : shadowOffset,
     } forState:UIControlStateNormal];
    
    [[MSGroupedTableViewCell appearance] setDetailTextAttributes:@{
                                UITextAttributeTextColor : [UIColor blackColor],
                          UITextAttributeTextShadowColor : shadowColor,
                         UITextAttributeTextShadowOffset : shadowOffset,
     } forState:UIControlStateNormal];
    
    [[MSTableCell appearance] setAccessoryTextAttributes:@{
                                   UITextAttributeTextColor : [UIColor darkGrayColor],
                             UITextAttributeTextShadowColor : shadowColor,
                            UITextAttributeTextShadowOffset : shadowOffset,
     } forState:UIControlStateNormal];
    
    [[MSMultlineGroupedTableViewCell appearance] setTitleTextAttributes:@{
                                                   UITextAttributeFont : [UIFont systemFontOfSize:15.0]
     } forState:UIControlStateNormal];
    
    [[MSButtonGroupedTableViewCell appearance] setTitleTextAttributes:@{
                                            UITextAttributeTextColor : [UIColor whiteColor],
                                      UITextAttributeTextShadowColor : [UIColor blackColor],
                                     UITextAttributeTextShadowOffset : [NSValue valueWithCGSize:CGSizeMake(0, -1.0)],
     } forState:UIControlStateNormal];
    
    [[MSButtonGroupedTableViewCell appearance] setTitleTextAttributes:@{
                                            UITextAttributeTextColor : [UIColor grayColor],
     } forState:UIControlStateHighlighted];
    
    NSDictionary *headerFooterTextAttributes = @{
        UITextAttributeTextColor : [UIColor colorWithWhite:0.2 alpha:1.0],
        UITextAttributeTextShadowColor : [[UIColor whiteColor] colorWithAlphaComponent:0.3],
        UITextAttributeTextShadowOffset : [NSValue valueWithCGSize:CGSizeMake(0, 1.0)],
    };
    
    [MSTableViewHeaderFooterView.appearance setTitleTextAttributes:headerFooterTextAttributes];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.tableViewController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
