//
//  ViewController.m
//  CameraTest
//
//  Created by Erik Allar on 3/23/15.
//  Copyright (c) 2015 Erik Allar. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIBarButtonItem *cameraButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(cameraPressed)];
    
    self.navigationItem.rightBarButtonItem = cameraButton;
    
    self.view.backgroundColor = [UIColor greenColor];
    self.title = @"ViewController";
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 200, [UIScreen mainScreen].bounds.size.width, 300)];
//    imageView.backgroundColor = [UIColor purpleColor];
    _imageView.contentMode = UIViewContentModeScaleAspectFill; // fill fill the image on the screen. fit fits it to the rect
    [self.view addSubview:_imageView];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cameraPressed
{
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.delegate = self;

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imgPicker animated:YES completion:nil];
    } else {
        NSLog(@"The device does not have a camera");
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Dismissed the camera view controller");
    }];
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    NSString *imageMetadata = [info objectForKey:UIImagePickerControllerMediaMetadata];
    UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    NSLog(@"Media Type: %@", mediaType);
    NSLog(@"Metadata: %@", imageMetadata);
    
    if (originalImage) {
        self.imageView.image = originalImage;
    }
    
}

@end
