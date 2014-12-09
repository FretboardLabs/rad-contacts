//
//  RCImagePickerViewController.h
//  rad-contacts
//
//  Created by Ben Hjerrild on 12/7/14.
//  Copyright (c) 2014 Fretboard Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RCImagePickerViewController;

@protocol RCImagePickerViewControllerDelegate <NSObject>

- (void)imagePickerViewController:(RCImagePickerViewController *)imagePickerViewController didSelectImage:(UIImage *)image;

@end

@interface RCImagePickerViewController : UIImagePickerController

@property (nonatomic, weak) id<RCImagePickerViewControllerDelegate> imageSelectionDelegate;

@end
