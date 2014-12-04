//
//  RCNavigationViewController.m
//  rad-contacts
//
//  Created by Ben Roth on 12/4/14.
//  Copyright (c) 2014 Fretboard Labs. All rights reserved.
//

#import "RCNavigationViewController.h"
#import "RCContactsViewController.h"

@interface RCNavigationViewController ()
{
    
}

@property (nonatomic, strong) RCContactsViewController *vcContacts;

@end

@implementation RCNavigationViewController

- (id) init
{
    RCContactsViewController *vcContacts = [[RCContactsViewController alloc] init];
    if (self = [super initWithRootViewController:vcContacts]) {
        self.vcContacts = vcContacts;
    }
    return self;
}

@end
