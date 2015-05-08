//
//  EZYImageStore.h
//  CameraTest
//
//  Created by Erik Allar on 3/24/15.
//  Copyright (c) 2015 Erik Allar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface EZYImageStoreFileSystem : NSObject

- (void)saveImage:(UIImage *)imageToSave toFileName:(NSString *)filename;
- (UIImage *)retrieveImageForFilename:(NSString *)filename;
- (BOOL)removeImageForFilename:(NSString *)filename;

@end
