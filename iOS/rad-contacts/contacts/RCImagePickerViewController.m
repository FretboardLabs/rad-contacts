//
//  RCImagePickerViewController.m
//  rad-contacts
//
//  Created by Ben Hjerrild on 12/7/14.
//  Copyright (c) 2014 Fretboard Labs. All rights reserved.
//

#import "RCImagePickerViewController.h"
#import "RCCropImageViewController.h"

@interface RCImagePickerViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, RCCropImageViewControllerDelegate>

@end

@implementation RCImagePickerViewController

#pragma mark RCImagePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.delegate = self;
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
	RCCropImageViewController *cropImageViewController = [[RCCropImageViewController alloc] initWithImage:image];
	cropImageViewController.delegate = self;
	[self pushViewController:cropImageViewController animated:YES];
}

#pragma mark RCCropImageViewControllerDelegate

- (void)cropImageViewController:(RCCropImageViewController *)cropImageViewController didFinishCropImage:(UIImage *)croppedImage
{
	[self.imageSelectionDelegate imagePickerViewController:self didSelectImage:croppedImage];
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end
