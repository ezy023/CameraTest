//
//  EZYImageIsolationViewController.m
//  CameraTest
//
//  Created by Erik Allar on 3/30/15.
//  Copyright (c) 2015 Erik Allar. All rights reserved.
//

#import "EZYImageIsolationViewController.h"
#import "EZYDestinationImageStore.h"
#import "NSString+FontAwesome.h"
#import "UIColor+EZYColors.h"

static NSString *const googleMapsAppURLScheme = @"comgooglemaps://";
static NSInteger const mapZoomWhenOpeningInGMaps = 15;

@implementation EZYImageIsolationViewController

- (instancetype)initWithDestination:(EZYDestination *)destination
{
    self = [super init];
    
    if (self) {
        self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.view.backgroundColor = [UIColor navigationNavyBlue];
        
        _currentDestination = destination;
        
        CGRect imageViewRect = CGRectMake(0, 75, [UIScreen mainScreen].bounds.size.width, 400);
        _imageView = [[UIImageView alloc] initWithFrame:imageViewRect];
        UIImage *image = [[EZYDestinationImageStore sharedDestinationImageStore] imageForKey:self.currentDestination.imageKey];
        [self.imageView setImage:image];
        self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:self.imageView];
    
        // Create dismiss button
        _dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _dismissButton.frame = CGRectMake(0, 0, 100, 50);
        _dismissButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_dismissButton.titleLabel setFont:[UIFont fontWithName:@"FontAwesome" size:48.0]];
        [_dismissButton setTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"fa-times-circle-o"] forState:UIControlStateNormal];
        [_dismissButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_dismissButton sizeToFit];
        [self.dismissButton addTarget:self action:@selector(dismissButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.dismissButton];
        
        // Create open in google maps button
        _openInGMapsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _openInGMapsButton.frame = CGRectMake(0, 0, 100, 50);
        _openInGMapsButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_openInGMapsButton.titleLabel setFont:[UIFont fontWithName:@"FontAwesome" size:48.0]];
        [_openInGMapsButton setTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"fa-location-arrow"] forState:UIControlStateNormal];
        [_openInGMapsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_openInGMapsButton addTarget:self action:@selector(openInGMapsButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_openInGMapsButton];
        
        
        
        // Adding Constraints
        NSLayoutConstraint *navConstraint = [NSLayoutConstraint constraintWithItem:self.openInGMapsButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.dismissButton attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
        NSDictionary *variables = @{@"imageView": self.imageView,
                                    @"dismissButton": self.dismissButton,
                                    @"openInGMapsButton": self.openInGMapsButton};

        
        NSArray *imageViewHorizConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==3)-[imageView]-(==3)-|" options:0 metrics:nil views:variables];
        NSArray *vertConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-75-[imageView(400)]-100-[dismissButton(50)]-(>=30)-|" options:0 metrics:nil views:variables];
        NSArray *buttonConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-75-[dismissButton]->=50-[openInGMapsButton]-75-|" options:0 metrics:nil views:variables];
        
        [self.view addConstraints:imageViewHorizConstraints];
        [self.view addConstraints:vertConstraints];
        [self.view addConstraints:buttonConstraints];
        [self.view addConstraint:navConstraint];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

# pragma mark UIStatusBarStyle Preference
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)dismissButtonPressed
{
    NSLog(@"Pressed dismiss");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)openInGMapsButtonPressed
{
    BOOL googleMapsIsInstalled = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:googleMapsAppURLScheme]];
    if (googleMapsIsInstalled) {
        NSString *mapParams = [NSString stringWithFormat:@"?daddr=%f,%f&zoom=%ld", self.currentDestination.location.coordinate.latitude, self.currentDestination.location.coordinate.longitude, mapZoomWhenOpeningInGMaps];
        NSString *completeGoogleMapsURL = [googleMapsAppURLScheme stringByAppendingString:mapParams];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:completeGoogleMapsURL]];
        
    } else {
        UIAlertController *gmapsAlertController = [UIAlertController alertControllerWithTitle:@"Google Maps" message:@"Oh G-dangit, it looks like you don't have Google Maps installed. You can install it from the App Store to get directions to this destination" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
        [gmapsAlertController addAction:dismissAction];
        [self presentViewController:gmapsAlertController animated:YES completion:nil];
    }
}

@end
