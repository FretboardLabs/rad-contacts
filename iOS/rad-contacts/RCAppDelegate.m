//
//  RCAppDelegate.m
//  rad-contacts
//
//  Created by Ben Roth on 12/4/14.
//  Copyright (c) 2014 Fretboard Labs. All rights reserved.
//

#import "RCAppDelegate.h"
#import "RCViewController.h"

@interface RCAppDelegate ()

@property (nonatomic, strong) RCViewController *vcContacts;

@end

@implementation RCAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.vcContacts = [[RCViewController alloc] init];
    self.window.rootViewController = _vcContacts;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
