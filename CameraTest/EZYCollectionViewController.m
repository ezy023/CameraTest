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
#import "EZYDestinationMapViewController.h"
#import "NSString+FontAwesome.h"

static const CGFloat CameraButtonWidth = 80.0;
static const CGFloat CameraButtonHeight = 80.0;
static const CGFloat CameraButtonBottomPadding = 30.0;

@interface EZYCollectionViewController ()

@property (nonatomic, strong) EZYImageStoreFileSystem *imageStore;
@property (nonatomic, strong) CLLocationManager *coreLocationManager;
@property (nonatomic, strong) UIButton *cameraButton;

@end

@implementation EZYCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Neat Places";
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.collectionView registerClass:[EZYCollectionViewCell class] forCellWithReuseIdentifier:@"CollectionCell"];
    
    _coreLocationManager = [[CLLocationManager alloc] init];
    self.coreLocationManager.delegate = self;
    self.coreLocationManager.distanceFilter = kCLDistanceFilterNone;
    self.coreLocationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [self addToolbarToCollection];
    [self customizeToolbarAppearance];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}

#pragma warn Change to tags nav button
- (UIBarButtonItem *)createCameraBarButtonItem
{
    UIBarButtonItem *camera = [[UIBarButtonItem alloc] init];
    NSDictionary *titleTextAttr = @{NSFontAttributeName: [UIFont fontWithName:@"FontAwesome" size:28.0],
                                    NSForegroundColorAttributeName: [UIColor whiteColor]};
    [camera setTitleTextAttributes:titleTextAttr forState:UIControlStateNormal];
    [camera setTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"fa-camera-retro"]];
    camera.target = self;
    camera.action = @selector(cameraBarButtonPressed);
    return camera;
}

#pragma Custom views
- (void)addToolbarToCollection
{
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 59.0f, [UIScreen mainScreen].bounds.size.width, 44.0f)];
    UIBarButtonItem *cameraButton = [self createCameraBarButtonItem];
    UIBarButtonItem *flexButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    toolbar.items = @[flexButton, cameraButton, flexButton];
    toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    [self.collectionView addSubview:toolbar];
}

- (void)customizeToolbarAppearance
{
    [UIToolbar appearance].barTintColor = [UIColor colorWithRed:6/255.0 green:52/255.0 blue:93/255.0 alpha:1.0];
    [UIToolbar appearance].translucent = NO;
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
    
    return cell;
}

- (void)deleteImageFromCollection
{
    NSLog(@"Delete this image");
}

#pragma marks UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    EZYDestination *destinationSelected = [[EZYDestinationDataSource sharedDatasource].destinations objectAtIndex:indexPath.row];
    NSLog(@"Selected destination: %@", destinationSelected);
    
    EZYDestinationMapViewController *mapViewController = [[EZYDestinationMapViewController alloc] initWithDestination:destinationSelected];
    [self.navigationController pushViewController:mapViewController animated:YES];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
    
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(delete:)) {
        return YES;
    }
    
    return NO;
}

- (void)removeCellAtIndexPath:(NSIndexPath *)indexPath
{
    EZYDestination *destinationToDelete = [[EZYDestinationDataSource sharedDatasource].destinations objectAtIndex:indexPath.row];
    [[EZYDestinationDataSource sharedDatasource] removeDestinationFromDataSource:destinationToDelete];
    [[EZYDestinationImageStore sharedDestinationImageStore] removeImageForKey:destinationToDelete.imageKey];
    [self.collectionView reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(removeCellAtIndexPath:)) {
        [self removeCellAtIndexPath:indexPath];
    }
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

#pragma mark UIImagePickerControllerDelegate -

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Dismissed the camera view controller");
    }];
    
    UIImage *editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    // Here we need to pass the UIImage to the Datastore which should store the image and create a thumbnail
    if (editedImage) {
        CLLocation *currentLocation = self.coreLocationManager.location; // This could be old, we should check the timestamp before using it.
        CLHeading *currentHeading = self.coreLocationManager.heading;
        NSString *imageKeyUUID = [NSUUID UUID].UUIDString;
        [[EZYDestinationImageStore sharedDestinationImageStore] addImage:editedImage forKey:imageKeyUUID];
        EZYDestination *newDestination = [[EZYDestination alloc] initWithImageKey:imageKeyUUID location:currentLocation heading:currentHeading];
        
        [[EZYDestinationDataSource sharedDatasource] addDestinationToDataSource:newDestination];
    }
    
    [self.collectionView reloadData];
}

#pragma mark CLLocationManagerDelegate - Locations -

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
}

#pragma mark CLLoactionManagerDelegate - Heading -

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
