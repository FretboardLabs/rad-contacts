//
//  RCContactsModel.h
//  rad-contacts
//
//  Reads the address book from the device and enumerates its contents.
//
//  Created by Ben Roth on 12/4/14.
//  Copyright (c) 2014 Fretboard Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString * const kRCContactsModelDidReloadNotification;

@interface RCContactsModel : NSObject

/**
 *  Accesses the singleton contacts model instance.
 */
+ (instancetype)sharedModel;

/**
 *  Read the device's address book.
 */
- (void)reload;

/**
 *  Ordered set of RCContacts representing contacts from the device's address book.
 */
@property (atomic, strong) NSOrderedSet *contacts;

@end
