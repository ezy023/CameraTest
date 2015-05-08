//
//  EZYImageStore.m
//  CameraTest
//
//  Created by Erik Allar on 3/24/15.
//  Copyright (c) 2015 Erik Allar. All rights reserved.
//

#import "EZYImageStoreFileSystem.h"

@implementation EZYImageStoreFileSystem

- (void)saveImage:(UIImage *)imageToSave toFileName:(NSString *)filename
{
    // First get a data representation of the image
    NSData *imageData = UIImagePNGRepresentation(imageToSave);
    
    NSString *writePath = [self createDocumentPathForFilename:filename];
    // I'll need to save this file path to the image object so that I can retrieve it later.
    [imageData writeToFile:writePath atomically:YES];
    NSLog(@"Wrote image file to %@", writePath);
    
}

- (NSString *)createDocumentPathForFilename:(NSString *)filename
{
    // Find User directories and expand the ~ at the beginning
    NSArray *directorySearchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [directorySearchPaths objectAtIndex:0];
    NSString *imageDirectoryPath = [documentsPath stringByAppendingPathComponent:@"/Images"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:imageDirectoryPath]) {
        NSError *directoryCreationError;
        [[NSFileManager defaultManager] createDirectoryAtPath:imageDirectoryPath withIntermediateDirectories:NO attributes:nil error:&directoryCreationError];
        if (directoryCreationError) {
            NSLog(@"Error creating directory: %@", directoryCreationError.description);
        }
    }
    
    NSString *filePath = [imageDirectoryPath stringByAppendingPathComponent:filename];
    return filePath;
}

- (UIImage *)retrieveImageForFilename:(NSString *)filename
{
    NSString *readPath = [self createDocumentPathForFilename:filename];
    NSData *imageData = [NSData dataWithContentsOfFile:readPath];
    UIImage *image = [UIImage imageWithData:imageData];

    return image;
}

- (BOOL)removeImageForFilename:(NSString *)filename
{
    NSString *deletePath = [self createDocumentPathForFilename:filename];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:deletePath]) {
        NSLog(@"There is no file with the specified name."); // TODO Look up proper error handling methods
    }
    
    NSError *deleteFileError;
    BOOL success = [[NSFileManager defaultManager] removeItemAtPath:deletePath error:&deleteFileError];
    
    if (deleteFileError) {
        NSLog(@"Error removing file at path %@. Description: %@", deletePath, deleteFileError.description);
    }
    
    return success;
    
    
}

@end
