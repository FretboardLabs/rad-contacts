//
//  RCContactsViewController.m
//  rad-contacts
//
//  Created by Ben Roth on 12/4/14.
//  Copyright (c) 2014 Fretboard Labs. All rights reserved.
//

#import "RCContactsViewController.h"

NSString * const kRCTableViewCellReuseIdentifier = @"RCTableViewCellReuseIdentifier";

@interface RCContactsViewController ()

@end

@implementation RCContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Rad Contacts";
    self.edgesForExtendedLayout = [super edgesForExtendedLayout] ^ UIRectEdgeTop;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kRCTableViewCellReuseIdentifier];
}


#pragma mark UITableView stuff

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kRCTableViewCellReuseIdentifier forIndexPath:indexPath];
    
    return cell;
}

@end
