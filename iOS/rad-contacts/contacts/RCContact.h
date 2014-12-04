//
//  RCContact.h
//  rad-contacts
//
//  Created by Ben Roth on 12/4/14.
//  Copyright (c) 2014 Fretboard Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

@interface RCContact : NSObject

@property (nonatomic, assign) ABRecordID contactId;
@property (nonatomic, strong) NSString *name;

@end
