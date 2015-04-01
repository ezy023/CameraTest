//
//  EZYDestinationMapViewController.h
//  CameraTest
//
//  Created by Erik Allar on 3/29/15.
//  Copyright (c) 2015 Erik Allar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EZYDestination.h"

@interface EZYDestinationMapViewController : UIViewController <UIGestureRecognizerDelegate>

- (instancetype)initWithDestination:(EZYDestination *)destination;

@end
