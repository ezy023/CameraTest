//
//  AppDelegate.m
//  CameraTest
//
//  Created by Erik Allar on 3/23/15.
//  Copyright (c) 2015 Erik Allar. All rights reserved.
//

#import "AppDelegate.h"
#import "CameraNavControllerViewController.h"
#import "ViewController.h"
#import "EZYCollectionViewController.h"
#import "EZYImageStoreFileSystem.h"
#import "EZYDestinationDataSource.h"
#import <GoogleMaps/GoogleMaps.h>

static int const collectionCellWidth = 125;
static int const collectionCellHeight = 125;
static int const collectionCellInterLineSpacing = 0;

static NSString *const googleMapsAPIKey = @"AIzaSyDFrgUJZfDFjsPRNTuKavskH8Atkj-s4xI";

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [GMSServices provideAPIKey:googleMapsAPIKey];
    
//    ViewController *vc = [[ViewController alloc] init];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(collectionCellWidth, collectionCellHeight);
    flowLayout.minimumInteritemSpacing = collectionCellInterLineSpacing;
    flowLayout.minimumLineSpacing = collectionCellInterLineSpacing;
    EZYCollectionViewController *collectionVC = [[EZYCollectionViewController alloc] initWithCollectionViewLayout:flowLayout];
    
    CameraNavControllerViewController *camNav = [[CameraNavControllerViewController alloc] initWithRootViewController:collectionVC];
    self.window.rootViewController = camNav;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    BOOL success = [[EZYDestinationDataSource sharedDatasource] saveItems];
    if (success) {
        NSLog(@"Saved Destination Items");
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
