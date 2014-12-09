//
//  RCContactsViewController.m
//  rad-contacts
//
//  Created by Ben Roth on 12/4/14.
//  Copyright (c) 2014 Fretboard Labs. All rights reserved.
//

#import "RCContactsViewController.h"
#import "RCContactsModel.h"
#import "RCContact.h"
#import "RCImagePickerViewController.h"

NSString * const kRCTableViewCellReuseIdentifier = @"RCTableViewCellReuseIdentifier";

@interface RCContactsViewController () <UISearchBarDelegate, RCImagePickerViewControllerDelegate>

@property (nonatomic, assign) RCContactsModel *contactsModel; // just a pointer to the singleton
@property (nonatomic, strong) RCContact *selectedContact;
@property (nonatomic, strong) UILocalizedIndexedCollation *collation;
@property (atomic, strong) NSOrderedSet *filteredContacts;
@property (atomic, strong) NSArray *sectionedContacts;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic) BOOL filtering;

- (void)onContactsReload;
- (void)updateFilteredContacts;
- (RCContact *)contactForIndexPath:(NSIndexPath *)indexPath;

@end

@implementation RCContactsViewController

- (id)init
{
    if (self = [super init]) {
        self.contactsModel = [RCContactsModel sharedModel];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onContactsReload) name:kRCContactsModelDidReloadNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Rad Contacts";
    self.edgesForExtendedLayout = [super edgesForExtendedLayout] ^ UIRectEdgeTop;
	
	self.collation = [UILocalizedIndexedCollation currentCollation];
	
	UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 40.0)];
	headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	
	self.searchBar = [[UISearchBar alloc] initWithFrame:headerView.bounds];
	_searchBar.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	_searchBar.delegate = self;

	[headerView addSubview:_searchBar];
	
    // table view of contacts
	self.tableView.tableHeaderView = headerView;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kRCTableViewCellReuseIdentifier];
	self.tableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
	self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
	self.tableView.tintColor = [UIColor blackColor];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // [super dealloc];
}

#pragma mark UITableView stuff

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_sectionedContacts && !_filtering)
        return _sectionedContacts.count;
	else if (_filteredContacts) {
		return 1;
	} else {
        return 0;
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_sectionedContacts && !_filtering)
        return ((NSArray *)_sectionedContacts[section]).count;
	else if (_filteredContacts) {
		return _filteredContacts.count;
	} else {
		return 0;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	if (_sectionedContacts && !_filtering) {
		return 30.0;
	} else {
		return 0.0;
	}
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
	if (!_filtering) {
		return [_collation sectionForSectionIndexTitleAtIndex:index];
	} else {
		return 0;
	}
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
	if (!_filtering) {
		return [_collation sectionIndexTitles];
	} else {
		return nil;
	}
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	if (!_filtering) {
		CGFloat cellInset = self.tableView.separatorInset.left;
		UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds) - cellInset, [self.tableView.delegate tableView:tableView heightForHeaderInSection:section])];
		sectionView.backgroundColor = [UIColor lightGrayColor];
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(cellInset, 0, CGRectGetWidth(self.view.bounds) - cellInset, [self.tableView.delegate tableView:tableView heightForHeaderInSection:section])];
		label.text = _collation.sectionIndexTitles[section];
		label.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin;
		[sectionView addSubview:label];
		return sectionView;
	} else {
		return nil;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kRCTableViewCellReuseIdentifier forIndexPath:indexPath];
	
	RCContact *contact = [self contactForIndexPath:indexPath];
	if (contact) {
		cell.textLabel.text = contact.name;
		NSLog(@"image %@", contact.contactImage);
		[cell.imageView setImage:contact.contactImage];
	}
	
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	RCImagePickerViewController *imagePickerViewController = [[RCImagePickerViewController alloc] init];
	imagePickerViewController.imageSelectionDelegate = self;
	[self.navigationController presentViewController:imagePickerViewController animated:YES completion:nil];
	self.selectedContact = [self contactForIndexPath:indexPath];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
	[self.searchBar resignFirstResponder];
}

#pragma mark UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	[self updateFilteredContacts];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	[self.searchBar resignFirstResponder];
}

#pragma mark RCImagePickerViewControllerDelegate

- (void)imagePickerViewController:(RCImagePickerViewController *)imagePickerViewController didSelectImage:(UIImage *)image
{
	_selectedContact.contactImage = image;
	self.selectedContact = nil;
	[self.tableView reloadData];
}

#pragma mark Helpers

- (void)onContactsReload
{
	dispatch_async(dispatch_get_main_queue(), ^{
		if (self.isViewLoaded) {
			[self updateFilteredContacts];
		}
	});
}

- (void)updateFilteredContacts
{
	if (_searchBar != nil && _searchBar.text != nil && ![_searchBar.text isEqualToString:@""]) {
		NSMutableArray *mutableSortedContacts = [[NSMutableArray alloc] init];
		for (RCContact *contact in _contactsModel.contacts) {
			if ([contact.name.lowercaseString containsString:_searchBar.text.lowercaseString]) {
				[mutableSortedContacts addObject:contact];
			}
		}
		self.filteredContacts = [[NSOrderedSet alloc] initWithArray:mutableSortedContacts];
		self.filtering = YES;
	} else {
		self.filteredContacts = _contactsModel.contacts;
		self.filtering = NO;
		
		NSInteger sectionCount = [[self.collation sectionTitles] count];
		NSMutableArray *sections = [NSMutableArray arrayWithCapacity:sectionCount];
		
		//create an array to hold the data for each section
		for(NSUInteger index = 0; index < sectionCount; index++)
		{
			[sections addObject:[[NSMutableArray alloc] init]];
		}
		
		for (RCContact *contact in _filteredContacts)
		{
			NSInteger index = [_collation sectionForObject:contact collationStringSelector:@selector(name)];
			[[sections objectAtIndex:index] addObject:contact];
		}
		
		self.sectionedContacts = [NSArray arrayWithArray:sections];
	}
	
	[self.tableView reloadData];
}

- (RCContact *)contactForIndexPath:(NSIndexPath *)indexPath
{
	RCContact *contact = nil;
	
	if (!_filtering && _sectionedContacts && indexPath.row < ((NSArray *)_sectionedContacts[indexPath.section]).count) {
		// cell displays the name of the corresponding contact
		contact = ((NSArray *)_sectionedContacts[indexPath.section])[indexPath.row];
	} else if (_filteredContacts && indexPath.row < _filteredContacts.count) {
		contact = _filteredContacts[indexPath.row];
	}
	return contact;
}

@end
