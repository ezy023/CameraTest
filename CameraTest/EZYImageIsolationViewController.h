//
//  EZYImageIsolationViewController.h
//  CameraTest
//
//  Created by Erik Allar on 3/30/15.
//  Copyright (c) 2015 Erik Allar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface EZYImageIsolationViewController : UIViewController

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *dismissButton;

- (instancetype)initWithImage:(UIImage *)image;

@end
