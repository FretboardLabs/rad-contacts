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

@property (nonatomic, strong) RCContactsViewController *vContacts;

@end

@implementation RCNavigationViewController

- (id) init
{
    RCContactsViewController *vContacts = [[RCContactsViewController alloc] init];
    if (self = [super initWithRootViewController:vContacts]) {
        self.vContacts = vContacts;
    }
    return self;
}

@end
