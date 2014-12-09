//
//  RCContactsModel.m
//  rad-contacts
//
//  Created by Ben Roth on 12/4/14.
//  Copyright (c) 2014 Fretboard Labs. All rights reserved.
//

#import "RCContactsModel.h"
#import "RCContact.h"
#import <AddressBook/AddressBook.h>
#import <UIKit/UIKit.h>

NSString * const kRCContactsModelDidReloadNotification = @"RCContactsModelDidReloadNotification";

@interface RCContactsModel ()
{
    BOOL isLoading;
}

@property (nonatomic, assign) ABAddressBookRef addressBookRef;

@end

@implementation RCContactsModel

+ (instancetype)sharedModel
{
    static RCContactsModel *theModel = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if (!theModel) {
            theModel = [[RCContactsModel alloc] init];
        }
    });
    return theModel;
}

- (id)init
{
    if (self = [super init]) {
        self.contacts = [NSOrderedSet orderedSet];
        isLoading = false;
        
        // get an address book instance, ignoring the case where permission was denied
        CFErrorRef err = nil;
        self.addressBookRef = ABAddressBookCreateWithOptions(nil, &err);
        
        if (_addressBookRef && err == nil) {
            ABAddressBookRequestAccessWithCompletion(self.addressBookRef, ^(bool granted, CFErrorRef error) {
                if (granted) {
                    [self reload];
                }
            });
        }
    }
    return self;
}

- (void) dealloc
{
    if (_addressBookRef) {
        CFRelease(_addressBookRef);
        self.addressBookRef = nil;
    }
    
    // [super dealloc];
}

- (void)reload
{
    if (!isLoading) {
        isLoading = true;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSMutableOrderedSet *newContacts = [NSMutableOrderedSet orderedSet];
            
            // enumerate contacts from the address book and add them to our set.
            NSArray *allContacts = (__bridge_transfer NSArray *) ABAddressBookCopyArrayOfAllPeople(_addressBookRef);
            
            for (NSUInteger contactIdx = 0; contactIdx < allContacts.count; contactIdx++) {
                ABRecordRef record = (__bridge ABRecordRef) allContacts[contactIdx];
                RCContact *newContact = [[RCContact alloc] initWithAddressBookRecord:record];
                if (newContact)
                    [newContacts addObject:newContact];
            }
            
            // don't need to CFRelease allContacts
            
            self.contacts = newContacts;
			
			// sort an array of contacts
			NSArray *sortedContactsArray;
			sortedContactsArray = [self.contacts.array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
				if ([obj1 isKindOfClass:[RCContact class]] && [obj2 isKindOfClass:[RCContact class]]) {
					RCContact *contact1 = (RCContact *)obj1;
					RCContact *contact2 = (RCContact *)obj2;
					return [contact1.name caseInsensitiveCompare:contact2.name];
				} else {
					return NSOrderedSame;
				}
			}];
			self.contacts = [[NSOrderedSet alloc] initWithArray:sortedContactsArray];
			
            isLoading = false;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kRCContactsModelDidReloadNotification object:nil];
        });
    }
}

@end
