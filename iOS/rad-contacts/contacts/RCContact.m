//
//  RCContact.m
//  rad-contacts
//
//  Created by Ben Roth on 12/4/14.
//  Copyright (c) 2014 Fretboard Labs. All rights reserved.
//

#import "RCContact.h"

@implementation RCContact

- (id)initWithAddressBookRecord:(ABRecordRef)record
{
    if (self = [super init]) {
        NSString *contactName = (__bridge NSString *)(ABRecordCopyValue(record, kABPersonFirstNameProperty));
        NSString *contactLastName = (__bridge NSString *)(ABRecordCopyValue(record, kABPersonLastNameProperty));
        ABRecordID contactId = ABRecordGetRecordID(record);
        
        if (contactLastName && contactLastName.length) {
            contactName = [NSString stringWithFormat:@"%@ %@", contactName, contactLastName];
		} else if (contactName.length == 0) {
			return nil;
		}
		
        // build an RCContact with this name and id.
        if (contactId != kABRecordInvalidID) {
            self.name = contactName;
            self.contactId = contactId;
			self.contactImage = nil;
        } else {
            return nil;
        }
    }
    return self;
}

@end
