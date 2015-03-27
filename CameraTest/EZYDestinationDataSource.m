//
//  EZYDestinationDataSource.m
//  CameraTest
//
//  Created by Erik Allar on 3/25/15.
//  Copyright (c) 2015 Erik Allar. All rights reserved.
//

#import "EZYDestinationDataSource.h"
#import "EZYDestination.h"

static NSString *const archiveDirectoryPath = @"destinations.archive";

@implementation EZYDestinationDataSource

+ (instancetype)sharedDatasource
{
    static EZYDestinationDataSource *sharedDataSource = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDataSource = [[EZYDestinationDataSource alloc] initPrivate];
    });
    
    return sharedDataSource;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"BAD INIT" reason:@"Do not use this initializer for singleton class" userInfo:nil];
    
    return self;
}

- (instancetype)initPrivate
{
    self = [super init];
    
    
    if (self) {
        _destinations = [NSKeyedUnarchiver unarchiveObjectWithFile:[self archivePath]];
        if (_destinations.count == 0) {
            _destinations = @[];
        }
    }
    return self;
}

- (void)addDestinationToDataSource:(EZYDestination *)destination
{
    NSMutableArray *mutableDestinations = [self.destinations mutableCopy];
    [mutableDestinations addObject:destination];
    self.destinations = [NSArray arrayWithArray:mutableDestinations];
    NSLog(@"Added Destination");
}

- (NSString *)archivePath
{
    NSArray *directoriesArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = directoriesArray[0];
    return [documentsDirectory stringByAppendingPathComponent:archiveDirectoryPath];
}

- (BOOL)saveItems
{
    NSString *archivePath = [self archivePath];
    
    BOOL result = [NSKeyedArchiver archiveRootObject:self.destinations toFile:archivePath];
    
    return result;
}

@end
