//
//  EZYCollectionViewController.m
//  CameraTest
//
//  Created by Erik Allar on 3/24/15.
//  Copyright (c) 2015 Erik Allar. All rights reserved.
//

#import "EZYCollectionViewController.h"
#import "EZYCollectionViewCell.h"
#import "EZYImageStoreFileSystem.h"
#import "EZYDestination.h"
#import "EZYDestinationDataSource.h"
#import "EZYDestinationImageStore.h"

@interface EZYCollectionViewController ()

@property (nonatomic, strong) EZYImageStoreFileSystem *imageStore;
@property (nonatomic, strong) CLLocationManager *coreLocationManager;

@end

@implementation EZYCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Collection";
    [self addCameraButtonToNavView];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor blueColor];
    
    [self.collectionView registerClass:[EZYCollectionViewCell class] forCellWithReuseIdentifier:@"CollectionCell"];
    
    _coreLocationManager = [[CLLocationManager alloc] init];
    self.coreLocationManager.delegate = self;
    self.coreLocationManager.distanceFilter = kCLDistanceFilterNone;
    self.coreLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}

- (void)addCameraButtonToNavView
{
    UIBarButtonItem *cameraButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(cameraBarButtonPressed)];
    self.navigationItem.rightBarButtonItem = cameraButton;

}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [EZYDestinationDataSource sharedDatasource].destinations.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EZYCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
    EZYDestination *destinationAtIndex = [[EZYDestinationDataSource sharedDatasource].destinations objectAtIndex:indexPath.row];
    cell.imageView.image = [[EZYDestinationImageStore sharedDestinationImageStore] imageForKey:destinationAtIndex.imageKey];
    cell.contentView.backgroundColor = [UIColor greenColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    EZYDestination *destinationSelected = [[EZYDestinationDataSource sharedDatasource].destinations objectAtIndex:indexPath.row];
    NSLog(@"Selected destination: %@", destinationSelected);
    
#pragma warn REMOVE CODE
    CLLocationCoordinate2D selectDestLocationCords = destinationSelected.location.coordinate;
    NSString *alertMessage = [NSString stringWithFormat:@"Lat: %f Long: %f \nHeading: %f", selectDestLocationCords.latitude, selectDestLocationCords.longitude, destinationSelected.heading.trueHeading];
    
    UIAlertController *destinationSelectionAlert = [UIAlertController alertControllerWithTitle:@"Destination" message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Neat" style:UIAlertActionStyleDefault handler:nil];
    [destinationSelectionAlert addAction:dismissAction];
    
    [self presentViewController:destinationSelectionAlert animated:YES completion:nil];
    
}

- (void)cameraBarButtonPressed
{
    UIImagePickerController *cameraController = [[UIImagePickerController alloc] init];
    cameraController.delegate = self;
    cameraController.allowsEditing = YES; // The editing rect in the cameraView does not stay when moved around unless you zoom. Know iOS bug
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        cameraController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:cameraController animated:YES completion:^{
            NSLog(@"Presented Camera from Collection View");
        }];
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No Camera" message:@"There is no camera available" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [self dismissViewControllerAnimated:YES completion:^{
                NSLog(@"Dismissed Alert View");
            }];
        }];
        
        [alertController addAction:dismissAction];
        [self presentViewController:alertController animated:YES completion:^{
            NSLog(@"Presented Alert View");
        }];
    }
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Dismissed the camera view controller");
    }];
    
    UIImage *editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    // Here we need to pass the UIImage to the Datastore which should store the image and create a thumbnail
    if (editedImage) {
//        CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:41.8369 longitude:87.6847]; // Chicago :D
        CLLocation *currentLocation = self.coreLocationManager.location; // This could be old, we should check the timestamp before using it.
        CLHeading *currentHeading = self.coreLocationManager.heading;
        NSString *imageKeyUUID = [NSUUID UUID].UUIDString;
        [[EZYDestinationImageStore sharedDestinationImageStore] addImage:editedImage forKey:imageKeyUUID];
        EZYDestination *newDestination = [[EZYDestination alloc] initWithImageKey:imageKeyUUID location:currentLocation heading:currentHeading];
        
        [[EZYDestinationDataSource sharedDatasource] addDestinationToDataSource:newDestination];
    }
    
    [self.collectionView reloadData];
}

#pragma mark CLLocationManagerDelegate - Locations

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    // This is the delegate method called when the authorization of Location services changes
    NSLog(@"Location Manager Auth Status Changed");
    
    if (status == kCLAuthorizationStatusNotDetermined) {
        if ([self.coreLocationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.coreLocationManager requestWhenInUseAuthorization];
        }
    }

    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [manager startUpdatingLocation];
        [manager startUpdatingHeading];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations;
{
    // This method is called when -startUpdatingLocation is called and the location manager starts to update locations
    NSLog(@"Updating Locations: Most Recent Location is %@", locations[locations.count - 1]);
}

#pragma mark CLLoactionManagerDelegate - Heading

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    // This method is called when -startUpdatingHeading is called and the location manager starts to update the heading (compass direction)
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Location Manager failed with error %@", error.localizedDescription);
    
    if (error.code == kCLErrorDenied) {
        NSLog(@"User denied use of location services.");
        NSLog(@"Stopping location services...");
        [self.coreLocationManager stopUpdatingLocation];
        [self.coreLocationManager stopUpdatingHeading];
    }
}

@end
