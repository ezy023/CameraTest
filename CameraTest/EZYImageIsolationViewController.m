//
//  EZYImageIsolationViewController.m
//  CameraTest
//
//  Created by Erik Allar on 3/30/15.
//  Copyright (c) 2015 Erik Allar. All rights reserved.
//

#import "EZYImageIsolationViewController.h"
#import "NSString+FontAwesome.h"

@implementation EZYImageIsolationViewController

- (instancetype)initWithImage:(UIImage *)image
{
    self = [super init];
    
    if (self) {
        self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.view.backgroundColor = [UIColor colorWithRed:6/255.0 green:52/255.0 blue:93/255.0 alpha:1.0];
        
        CGRect imageViewRect = CGRectMake(0, 75, [UIScreen mainScreen].bounds.size.width, 400);
        _imageView = [[UIImageView alloc] initWithFrame:imageViewRect];
        [self.imageView setImage:image];
        self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:self.imageView];
    
        _dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _dismissButton.frame = CGRectMake(0, 0, 100, 50);
        _dismissButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_dismissButton.titleLabel setFont:[UIFont fontWithName:@"FontAwesome" size:48.0]];
        [_dismissButton setTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"fa-times-circle-o"] forState:UIControlStateNormal];
        [_dismissButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_dismissButton sizeToFit];
        [self.dismissButton addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.dismissButton];

        // Adding Constraints
        NSLayoutConstraint *buttonHorizConstraint = [NSLayoutConstraint constraintWithItem:self.dismissButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
        NSDictionary *variables = @{@"imageView": self.imageView,
                                    @"dismissButton": self.dismissButton};

        
        NSArray *imageViewHorizConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(==0)-[imageView]-(==0)-|" options:0 metrics:nil views:variables];
        NSArray *vertConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-75-[imageView(400)]-100-[dismissButton(50)]-(>=30)-|" options:0 metrics:nil views:variables];
        
        [self.view addConstraints:imageViewHorizConstraints];
        [self.view addConstraints:vertConstraints];
        [self.view addConstraint:buttonHorizConstraint];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

# pragma mark UIStatusBarStyle Preference
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)buttonPressed
{
    NSLog(@"Pressed dismiss");
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
