//
//  EZYDestinationMapViewController.m
//  CameraTest
//
//  Created by Erik Allar on 3/29/15.
//  Copyright (c) 2015 Erik Allar. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import "EZYDestinationMapViewController.h"
#import "EZYDestinationImageStore.h"
#import "EZYImageIsolationViewController.h"

@interface EZYDestinationMapViewController ()

@property (nonatomic, strong) GMSMapView *mapView;
@property (nonatomic, strong) EZYDestination *destination;

@end

@implementation EZYDestinationMapViewController

- (instancetype)initWithDestination:(EZYDestination *)destination
{
    self = [super init];
    
    if (self) {
        _destination = destination;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [self setUpMapView];
    [self addButton];
    
}

- (void)addButton
{
    CGRect viewRect = CGRectMake([UIScreen mainScreen].bounds.size.width - 140, [UIScreen mainScreen].bounds.size.height - 140, 120, 120);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = viewRect;
    button.backgroundColor = [UIColor blueColor];
    UIImage *btnImage = [[EZYDestinationImageStore sharedDestinationImageStore] imageForKey:self.destination.imageKey];
    [button setImage:btnImage forState:UIControlStateNormal];
    [button addTarget:self action:@selector(imageTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.mapView addSubview:button];
}

//- (UIImage *)getScaledDownImage
//{
//    UIImage *storedDestinationImage = [[EZYDestinationImageStore sharedDestinationImageStore] imageForKey:self.destination.imageKey];
//    CGSize newImageSize = CGSizeMake(120, 120);
//    CGRect viewRect = CGRectMake([UIScreen mainScreen].bounds.size.width - 140, [UIScreen mainScreen].bounds.size.height - 140, 120, 120);
//    
//    UIGraphicsBeginImageContextWithOptions(newImageSize, NO, [UIScreen mainScreen].scale);
//    CGContextRef currentContext = UIGraphicsGetCurrentContext();
//    CGContextDrawImage(currentContext, viewRect, storedDestinationImage.CGImage);
//    
//    UIImage *processedImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    return processedImage;
//}

- (void)setUpMapView
{
    CLLocationCoordinate2D destinationLocation = self.destination.location.coordinate;
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:destinationLocation.latitude longitude:destinationLocation.longitude zoom:15];
    
    self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    
    // Create a marker to represent the location
    GMSMarker *destinationMarker = [[GMSMarker alloc] init];
    destinationMarker.position = destinationLocation;
    destinationMarker.title = @"Neat Spot!";
    destinationMarker.map = self.mapView;
    
    self.view = self.mapView;
}

- (void)imageTapped:(UITapGestureRecognizer *)sender
{
    NSLog(@"Image was tapped");

    UIImage *isoImage = [[EZYDestinationImageStore sharedDestinationImageStore] imageForKey:self.destination.imageKey];
    EZYImageIsolationViewController *imageIsoVC = [[EZYImageIsolationViewController alloc] initWithImage:isoImage];
//    [imageIsoVC.imageView setImage:isoImage];
//    imageIsoVC.imageView.backgroundColor = [UIColor orangeColor];
    [self presentViewController:imageIsoVC animated:YES completion:nil];
}

@end
