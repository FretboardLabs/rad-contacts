//
//  RCContactsModel.h
//  rad-contacts
//
//  Reads the address book from the device and enumerates its contents by contact name.
//
//  Created by Ben Roth on 12/4/14.
//  Copyright (c) 2014 Fretboard Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RCContactsModel;

@protocol RCContactsDelegate <NSObject>

- (void)contactsModelDidReload: (RCContactsModel *)model;

@end

@interface RCContactsModel : NSObject

/**
 *  Read the device's address book.
 */
- (void)reload;

/**
 *  Ordered set of NSStrings representing names from the device's address book.
 */
@property (atomic, strong) NSOrderedSet *contacts;

@property (nonatomic, assign) id<RCContactsDelegate> delegate;

@end
