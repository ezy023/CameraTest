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
    
    UIColor *navBarDarkBlue = [UIColor colorWithRed:0/255.0 green:39/255.0 blue:157/255.0 alpha:1.0];
    [navBar setBarTintColor:navBarDarkBlue];
    UIFont *newFont = [UIFont fontWithName:@"Futura-MediumItalic" size:24.0];
    NSDictionary *navigationBarTitleTextAttributes = @{NSFontAttributeName: newFont,
                                                       NSForegroundColorAttributeName: [UIColor whiteColor]};
    

    [navBar setTintColor:[UIColor whiteColor]];
    
    [navBar setTitleTextAttributes:navigationBarTitleTextAttributes];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)cameraPressed
{
    NSLog(@"Pressed the Camera Button");
}

@end
