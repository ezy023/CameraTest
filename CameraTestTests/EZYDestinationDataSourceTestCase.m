//
//  EZYDestinationDataSourceTestCase.m
//  CameraTest
//
//  Created by Erik Allar on 3/25/15.
//  Copyright (c) 2015 Erik Allar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "EZYDestinationDataSource.h"

@interface EZYDestinationDataSourceTestCase : XCTestCase

@property (nonatomic, strong) EZYDestinationDataSource *destinationDataSource;

@end

@implementation EZYDestinationDataSourceTestCase

- (void)setUp {
    [super setUp];
    _destinationDataSource = [EZYDestinationDataSource sharedDatasource];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDestinationDatasourceInitializes
{
    EZYDestinationDataSource *testDestinationDataSource = [EZYDestinationDataSource sharedDatasource];
    XCTAssertNotNil(testDestinationDataSource, @"EZYDestinationDataSource should not be nil upon instantiation");
}

- (void)testDestinationDatasourceInitializesWithEmptyArray
{
    EZYDestinationDataSource *testDestinationDataSource = [EZYDestinationDataSource sharedDatasource];
    XCTAssertEqual(@[], testDestinationDataSource.destinations, @"EZYDestinationDataSource should initialize with an empty array for the destinations property");
}

- (void)testAddDestinationToDataSourceAddsOperation
{
    
}

@end
