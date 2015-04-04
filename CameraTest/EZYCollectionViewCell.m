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
        _imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_imageView];
    }
    
    return self;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(delete:)) {
        return YES;
    }
    
    return NO;
}

- (void)delete:(id)sender
{
    UICollectionView *collectionView = (UICollectionView *) self.superview;
    if ([collectionView isKindOfClass:[UICollectionView class]]) {
        id <UICollectionViewDelegate> collectionViewDelegate = collectionView.delegate;
        if ([collectionViewDelegate respondsToSelector:@selector(collectionView:performAction:forItemAtIndexPath:withSender:)]) {
            [collectionViewDelegate collectionView:collectionView performAction:@selector(removeCellAtIndexPath:) forItemAtIndexPath:[collectionView indexPathForCell:self] withSender:sender];
        }
    }
}


@end

