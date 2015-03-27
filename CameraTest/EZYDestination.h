//
//  EZYDestination.h
//  CameraTest
//
//  Created by Erik Allar on 3/25/15.
//  Copyright (c) 2015 Erik Allar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>

@interface EZYDestination : NSObject <NSCoding>

@property (nonatomic, strong) NSString *imageKey;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) CLHeading *heading;

- (instancetype)initWithImageKey:(NSString *)imageKey location:(CLLocation *)location heading:(CLHeading *)heading;

@end
