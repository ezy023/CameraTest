//
//  EZYDestinationImageStoreTestCase.m
//  CameraTest
//
//  Created by Erik Allar on 3/25/15.
//  Copyright (c) 2015 Erik Allar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "EZYDestinationImageStore.h"

@interface EZYDestinationImageStoreTestCase : XCTestCase

@property (nonatomic, strong) EZYDestinationImageStore *sharedImageStore;

@end

@implementation EZYDestinationImageStoreTestCase

- (void)setUp {
    [super setUp];
    _sharedImageStore = [EZYDestinationImageStore sharedDestinationImageStore];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testAddingImageToImageStoreWithKey
{
    NSString *imageKey = @"testImageKey";
    UIImage *imageToStore = [[UIImage alloc] init];
    
    [self.sharedImageStore addImage:imageToStore forKey:imageKey];
    UIImage *imageRetrievedFromCache = [[self.sharedImageStore getImageCacheDictionary] objectForKey:imageKey];
    
    XCTAssertEqual(imageToStore, imageRetrievedFromCache);

}

- (void)testImageForKeyRetrievesProperMessage
{
    NSString *imageKey = @"testImageKey";
    UIImage *imageToStore = [[UIImage alloc] init];
    
    [self.sharedImageStore addImage:imageToStore forKey:imageKey];
    
    UIImage *imageRetrievedFromMethod = [self.sharedImageStore imageForKey:imageKey];
    XCTAssertEqual(imageToStore, imageRetrievedFromMethod, @"Image For key should return the image if it exists");
}

- (void)testImageForKeyReturnsNilForNonExistantImage
{
    NSString *nonExistantImageKey = @"noImageKey";
    
    UIImage *nonImage = [self.sharedImageStore imageForKey:nonExistantImageKey];
    
    XCTAssertNil(nonImage, @"imageForKey should return nil if image doesn't exist in the cache");
}

- (void)testRemovingImage
{
    NSString *imageKey = @"testImageKey";
    UIImage *imageToStore = [[UIImage alloc] init];
    [self.sharedImageStore addImage:imageToStore forKey:imageKey];
    
    [self.sharedImageStore removeImageForKey:imageKey];

    XCTAssertNil([[self.sharedImageStore getImageCacheDictionary] objectForKey:imageKey]);
}

@end
