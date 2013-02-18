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
#import <QuartzCore/QuartzCore.h>

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
    
    [MSPlainTableViewCell.appearance setEtchHighlightColor:cellEtchHighlightColor];
    [MSPlainTableViewCell.appearance setEtchShadowColor:cellEtchShadowColor];
    [MSPlainTableViewCell.appearance setSelectionColor:[UIColor colorWithWhite:0.0 alpha:0.1]];
    
    UIColor *headerTopEtchHighlightColor = [UIColor colorWithWhite:1.0 alpha:(0.1 + (color * 0.1))];
    UIColor *headerTopEtchShadowColor = [UIColor colorWithWhite:(0.0 + (0.5 * color)) alpha:1.0];
    UIColor *headerBottomEtchShadowColor = [UIColor colorWithWhite:(0.0 + (0.3 * color)) alpha:1.0];
    UIColor *headerBackgroundColor = [[UIColor colorWithWhite:0.0 alpha:1.0] colorWithNoiseWithOpacity:0.05 andBlendMode:kCGBlendModeScreen];
    
    [MSPlainTableViewHeaderView.appearance setTopEtchHighlightColor:headerTopEtchHighlightColor];
    [MSPlainTableViewHeaderView.appearance setTopEtchShadowColor:headerTopEtchShadowColor];
    [MSPlainTableViewHeaderView.appearance setBottomEtchShadowColor:headerBottomEtchShadowColor];
    [MSPlainTableViewHeaderView.appearance setBackgroundColor:headerBackgroundColor];
    
    CAGradientLayer *defaultBackgroundGradient = [CAGradientLayer layer];
    UIColor *gradientTopColor = [UIColor colorWithWhite:1.0 alpha:0.05];
    UIColor *gradientBottomColor = [UIColor colorWithWhite:1.0 alpha:0.1];
    defaultBackgroundGradient.colors = @[(id)[gradientTopColor CGColor], (id)[gradientBottomColor CGColor]];
    [MSPlainTableViewHeaderView.appearance setBackgroundGradient:defaultBackgroundGradient];
    
    UIColor *textColor = (color > 0.5) ? [UIColor blackColor] : [UIColor whiteColor];
    NSValue *textShadowOffset;
    UIColor *textShadowColor;
    UIColor *headerTextShadowColor;
    if (color > 0.5) {
        textShadowOffset = [NSValue valueWithCGSize:CGSizeMake(0.0, 1.0)];
        textShadowColor = cellEtchHighlightColor;
        headerTextShadowColor = headerTopEtchHighlightColor;
    } else {
        textShadowOffset = [NSValue valueWithCGSize:CGSizeMake(0.0, -1.0)];
        textShadowColor = cellEtchShadowColor;
        headerTextShadowColor = cellEtchShadowColor;
    }

    NSDictionary *textAttributes = @{
        UITextAttributeTextColor : textColor,
        UITextAttributeTextShadowColor : textShadowColor,
        UITextAttributeTextShadowOffset : textShadowOffset,
    };
    
    NSDictionary *highlightedTextAttributes = @{
        UITextAttributeTextColor : [UIColor lightGrayColor],
        UITextAttributeTextShadowColor : textShadowColor,
        UITextAttributeTextShadowOffset : [NSValue valueWithCGSize:CGSizeMake(0.0, 1.0)],
    };
    
    [MSTableViewCell.appearance setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    [MSTableViewCell.appearance setDetailTextAttributes:textAttributes forState:UIControlStateNormal];
    [MSTableViewCell.appearance setAccessoryTextAttributes:textAttributes forState:UIControlStateNormal];
    
    [MSTableViewCell.appearance setTitleTextAttributes:highlightedTextAttributes forState:UIControlStateHighlighted];
    [MSTableViewCell.appearance setDetailTextAttributes:highlightedTextAttributes forState:UIControlStateHighlighted];
    [MSTableViewCell.appearance setAccessoryTextAttributes:highlightedTextAttributes forState:UIControlStateHighlighted];
    
    [MSPlainTableViewHeaderView.appearance setTitleTextAttributes:textAttributes];
    
    self.tableViewController = [[MSExamplePlainTableViewController alloc] initWithNibName:nil bundle:nil];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.tableViewController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
