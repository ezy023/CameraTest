//
//  CameraNavControllerViewController.m
//  CameraTest
//
//  Created by Erik Allar on 3/23/15.
//  Copyright (c) 2015 Erik Allar. All rights reserved.
//

#import "CameraNavControllerViewController.h"

@interface CameraNavControllerViewController ()

@end

@implementation CameraNavControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UINavigationBar *navBar = [UINavigationBar appearance];
    
    UIColor *navBarDarkBlue = [UIColor colorWithRed:6/255.0 green:52/255.0 blue:93/255.0 alpha:1.0];
    [navBar setBarTintColor:navBarDarkBlue];
    UIFont *newFont = [UIFont fontWithName:@"Futura-Medium" size:24.0];
    NSDictionary *navigationBarTitleTextAttributes = @{NSFontAttributeName: newFont,
                                                       NSForegroundColorAttributeName: [UIColor whiteColor]};
    

    [navBar setTintColor:[UIColor whiteColor]];
    [navBar setTranslucent:NO];
    [navBar setTitleTextAttributes:navigationBarTitleTextAttributes];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)cameraPressed
{
    NSLog(@"Pressed the Camera Button");
}

@end
