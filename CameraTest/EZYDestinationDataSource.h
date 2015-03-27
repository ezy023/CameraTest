//
//  EZYDestinationDataSource.h
//  CameraTest
//
//  Created by Erik Allar on 3/25/15.
//  Copyright (c) 2015 Erik Allar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EZYDestinationDataSource : NSObject

@property (nonatomic, strong) NSArray *destinations;

+ (instancetype)sharedDatasource;

- (void)addDestinationToDataSource:()destination;
- (BOOL)saveItems;

@end
