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

@end
