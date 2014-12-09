//
//  RCAppDelegate.m
//  rad-contacts
//
//  Created by Ben Roth on 12/4/14.
//  Copyright (c) 2014 Fretboard Labs. All rights reserved.
//

#import "RCAppDelegate.h"
#import "RCNavigationViewController.h"

@interface RCAppDelegate ()

@property (nonatomic, strong) RCNavigationViewController *vcRoot;

@end

@implementation RCAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    self.vcRoot = [[RCNavigationViewController alloc] init];
    self.window.rootViewController = _vcRoot;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
