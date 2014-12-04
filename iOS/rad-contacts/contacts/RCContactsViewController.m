//
//  RCContactsViewController.m
//  rad-contacts
//
//  Created by Ben Roth on 12/4/14.
//  Copyright (c) 2014 Fretboard Labs. All rights reserved.
//

#import "RCContactsViewController.h"
#import "RCContact.h"

NSString * const kRCTableViewCellReuseIdentifier = @"RCTableViewCellReuseIdentifier";

@interface RCContactsViewController ()

@property (nonatomic, strong) RCContactsModel *contactsModel;

@end

@implementation RCContactsViewController

- (id)init
{
    if (self = [super init]) {
        self.contactsModel = [[RCContactsModel alloc] init];
        _contactsModel.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Rad Contacts";
    self.edgesForExtendedLayout = [super edgesForExtendedLayout] ^ UIRectEdgeTop;
    
    // table view of contacts
    self.tableView.allowsSelection = false;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kRCTableViewCellReuseIdentifier];
}


#pragma mark UITableView stuff

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_contactsModel)
        return 1;
    else
        return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_contactsModel && section == 0)
        return _contactsModel.contacts.count;
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kRCTableViewCellReuseIdentifier forIndexPath:indexPath];
    
    if (_contactsModel && indexPath.row < _contactsModel.contacts.count) {
        // cell displays the name of the corresponding contact
        RCContact *contact = [_contactsModel.contacts objectAtIndex:indexPath.row];
        cell.textLabel.text = contact.name;
    }
    
    return cell;
}


#pragma mark RCContactsModel

- (void)contactsModelDidReload:(RCContactsModel *)model
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.isViewLoaded) {
            [self.tableView reloadData];
        }
    });
}

@end
