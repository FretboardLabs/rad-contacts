//
//  RCCropImageViewController.m
//  rad-contacts
//
//  Created by Ben Hjerrild on 12/7/14.
//  Copyright (c) 2014 Fretboard Labs. All rights reserved.
//

#import "RCCropImageViewController.h"
#import "UIImage+RCImage.h"

static CGSize const kCropSize = { 150, 150 };

@interface RCCropImageViewController ()

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *cropSquare;

@end

@implementation RCCropImageViewController

#pragma mark RCCropImageViewController

- (instancetype)initWithImage:(UIImage *)image
{
	self = [super init];
	if (self != nil) {
		self.image = image;
	}
	return self;
}

- (void)viewDidLoad
{
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"crop" style:UIBarButtonItemStylePlain target:self action:@selector(cropTapped)];
	
	self.imageView = [[UIImageView alloc] initWithImage:_image];
	_imageView.contentMode = UIViewContentModeScaleAspectFit;
	[self.view addSubview:_imageView];
	
	UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureChanged:)];
	[self.view addGestureRecognizer:panGestureRecognizer];
	
	self.cropSquare = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kCropSize.width, kCropSize.height)];
	_cropSquare.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:.5];
	[self.view addSubview:_cropSquare];
	
    [super viewDidLoad];
}

- (void)viewDidLayoutSubviews
{
	[super viewDidLayoutSubviews];
	self.imageView.frame = self.view.bounds;
}

#pragma mark Actions

- (void)cropTapped
{
	UIImage *fixedImage = [_image rcFixOrientation];
	CGFloat ratio = fixedImage.size.width / CGRectGetWidth(_imageView.frame);
	
	// calculate the offset because the image is centered --> fuck you math + coordinate systems
	// top padding above the centered image + image height + size of the crop rect = the offset for cropping
	CGFloat yOffset = (((CGRectGetHeight(_imageView.frame) * ratio) - fixedImage.size.height) / 2.0) + fixedImage.size.height - (CGRectGetHeight(_cropSquare.frame) * ratio);

	UIGraphicsBeginImageContext(CGSizeMake(kCropSize.width * ratio, kCropSize.height * ratio));
	CGContextRef currentContext = UIGraphicsGetCurrentContext();
	
	//create a rect with the size we want to crop the image to
	//the X and Y here are zero so we start at the beginning of our
	//newly created contextrect
	CGRect clippedRect = CGRectMake(0, 0, kCropSize.width * ratio, kCropSize.height * ratio);
	CGContextClipToRect(currentContext, clippedRect);
	
	//create a rect equivalent to the full size of the image
	//offset the rect by the X and Y we want to start the crop
	//from in order to cut off anything before them
	CGRect drawRect = CGRectMake(-CGRectGetMinX(_cropSquare.frame) * ratio, (CGRectGetMinY(_cropSquare.frame) * ratio) - yOffset, fixedImage.size.width, fixedImage.size.height);
	
	//draw the image to our clipped context using our offset rect
	CGContextDrawImage(currentContext, drawRect, fixedImage.CGImage);
	
	//pull the image from our cropped context
	UIImage *cropped = UIGraphicsGetImageFromCurrentImageContext();
	
	//pop the context to get back to the default
	UIGraphicsEndImageContext();
	
	// flip image
	cropped = [UIImage imageWithCGImage:cropped.CGImage scale:cropped.scale orientation:UIImageOrientationDownMirrored];
	[self.delegate cropImageViewController:self didFinishCropImage:cropped];
}

#pragma mark UIPanGestureRecognizer

- (void)panGestureChanged:(UIPanGestureRecognizer *)panGestureRecognizer
{
	_cropSquare.center = [panGestureRecognizer locationInView:self.view];
}

@end
