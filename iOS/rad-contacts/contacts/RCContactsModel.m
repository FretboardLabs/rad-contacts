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
        CFErrorRef err = nil;
        self.addressBookRef = ABAddressBookCreateWithOptions(nil, &err);
        self.contacts = [NSOrderedSet orderedSet];
        isLoading = false;
        
        ABAddressBookRequestAccessWithCompletion(self.addressBookRef, ^(bool granted, CFErrorRef error) {
            if (self.addressBookRef && granted) {
                [self reload];
            }
        });
    }
    return self;
}

- (void) dealloc
{
    if (self.addressBookRef) {
        CFRelease(self.addressBookRef);
        self.addressBookRef = nil;
    }
    
    // [super dealloc];
}


#pragma mark internal

- (void)reload
{
    if (!isLoading) {
        isLoading = true;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSMutableOrderedSet *newContacts = [NSMutableOrderedSet orderedSet];
                
            NSArray *allContacts = (__bridge_transfer NSArray *) ABAddressBookCopyArrayOfAllPeople(self.addressBookRef);
            
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
