//
//  RCCropImageViewController.h
//  rad-contacts
//
//  Created by Ben Hjerrild on 12/7/14.
//  Copyright (c) 2014 Fretboard Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RCCropImageViewController;

@protocol RCCropImageViewControllerDelegate <NSObject>

- (void)cropImageViewController:(RCCropImageViewController *)cropImageViewController didFinishCropImage:(UIImage *)croppedImage;

@end

@interface RCCropImageViewController : UIViewController

- (instancetype)initWithImage:(UIImage *)image;

@property (nonatomic, weak) id<RCCropImageViewControllerDelegate> delegate;

@end
