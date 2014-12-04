//
//  RCContactsModel.m
//  rad-contacts
//
//  Created by Ben Roth on 12/4/14.
//  Copyright (c) 2014 Fretboard Labs. All rights reserved.
//

#import "RCContactsModel.h"
#import <AddressBook/AddressBook.h>

@interface RCContactsModel ()
{
    BOOL isLoading;
}

@property (nonatomic, assign) ABAddressBookRef addressBookRef;

@end

@implementation RCContactsModel

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
            
            // enumerate contacts from the address book and add them to our set by full name.
            NSArray *allContacts = (__bridge_transfer NSArray *) ABAddressBookCopyArrayOfAllPeople(_addressBookRef);
            
            for (NSUInteger contactIdx = 0; contactIdx < allContacts.count; contactIdx++) {
                ABRecordRef record = (__bridge ABRecordRef) allContacts[contactIdx];
                
                NSString *contactName = (__bridge NSString *)(ABRecordCopyValue(record, kABPersonFirstNameProperty));
                NSString *contactLastName = (__bridge NSString *)(ABRecordCopyValue(record, kABPersonLastNameProperty));
                
                if (contactLastName && contactLastName.length) {
                    contactName = [NSString stringWithFormat:@"%@ %@", contactName, contactLastName];
                }
                
                [newContacts addObject:contactName];
            }
            
            // don't need to CFRelease allContacts
            
            self.contacts = newContacts;
            isLoading = false;
            
            if (_delegate) {
                [_delegate contactsModelDidReload:self];
            }
        });
    }
}

@end
