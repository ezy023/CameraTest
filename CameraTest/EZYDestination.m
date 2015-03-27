//
//  EZYDestination.m
//  CameraTest
//
//  Created by Erik Allar on 3/25/15.
//  Copyright (c) 2015 Erik Allar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "EZYDestination.h"

static NSString *const imageKeyCoderKey = @"imageKey";
static NSString *const locationCoderKey = @"location";
static NSString *const headingCoderKey = @"heading";

@implementation EZYDestination

- (instancetype)initWithImageKey:(NSString *)imageKey location:(CLLocation *)location heading:(CLHeading *)heading
{
    self = [super init];
    
    if (self) {
        _imageKey = imageKey;
        _location = location;
        _heading = heading;
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self) {
        _imageKey = [aDecoder decodeObjectForKey:imageKeyCoderKey];
        _location = [aDecoder decodeObjectForKey:locationCoderKey];
        _heading = [aDecoder decodeObjectForKey:headingCoderKey];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.imageKey forKey:imageKeyCoderKey];
    [aCoder encodeObject:self.location forKey:locationCoderKey];
}

- (NSString *)description
{
    NSString *descriptionString = [NSString stringWithFormat:@"<EZYDestination imageKey: %@, location: %@", self.imageKey, self.location];
    return descriptionString;
}

@end
