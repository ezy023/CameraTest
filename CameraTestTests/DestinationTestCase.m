//
//  DestinationTestCase.m
//  CameraTest
//
//  Created by Erik Allar on 3/25/15.
//  Copyright (c) 2015 Erik Allar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "EZYDestination.h"

@interface DestinationTestCase : XCTestCase

@property (nonatomic, strong) EZYDestination *destination;

@end

@implementation DestinationTestCase

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDestinationInitialized
{
    _destination = [[EZYDestination alloc] init];
    XCTAssertNotNil(self.destination);
}

- (void)testDestinationInitializesWithImageKeyLocationAndHeading
{
    NSString *testImageKey = [NSUUID UUID].UUIDString;
    CLLocation *testLocation = [[CLLocation alloc] init];
    CLHeading *testHeading = [[CLHeading alloc] init];
    _destination = [[EZYDestination alloc] initWithImageKey:testImageKey location:testLocation heading:testHeading];
    
    XCTAssertTrue(self.destination.imageKey == testImageKey);
    XCTAssertTrue(self.destination.location == testLocation);
    XCTAssertTrue(self.destination.heading == testHeading);
}

@end
