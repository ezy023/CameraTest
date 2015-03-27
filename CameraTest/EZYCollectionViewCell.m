//
//  EZYCollectionViewCell.m
//  CameraTest
//
//  Created by Erik Allar on 3/24/15.
//  Copyright (c) 2015 Erik Allar. All rights reserved.
//

#import "EZYCollectionViewCell.h"

@implementation EZYCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
//        NSURL *url = [NSURL URLWithString:@"http://tms.visioncritical.com/sites/default/files/tweet-this_0.png"];
//        NSData *imageData = [NSData dataWithContentsOfURL:url];
//        UIImage *image = [UIImage imageWithData:imageData];
        _imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
//        _imageView = [[UIImageView alloc] initWithImage:image];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_imageView];
    }
    
    return self;
}

@end
