//
//  EZYDestinationDataSource.h
//  CameraTest
//
//  Created by Erik Allar on 3/25/15.
//  Copyright (c) 2015 Erik Allar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EZYDestination.h"

@interface EZYDestinationDataSource : NSObject

@property (nonatomic, strong) NSArray *destinations;

+ (instancetype)sharedDatasource;

- (void)addDestinationToDataSource:(EZYDestination *)destination;
- (void)removeDestinationFromDataSource:(EZYDestination *)destination;
- (BOOL)saveItems;

@end
