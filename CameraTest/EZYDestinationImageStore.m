//
//  EZYDestinationImageStore.m
//  CameraTest
//
//  Created by Erik Allar on 3/25/15.
//  Copyright (c) 2015 Erik Allar. All rights reserved.
//

#import "EZYDestinationImageStore.h"
#import "EZYImageStoreFileSystem.h"

@interface EZYDestinationImageStore ()

@property (nonatomic, strong) NSMutableDictionary *imageCacheDictionary;
@property (nonatomic, strong) EZYImageStoreFileSystem *fileSystemImageStore;

@end

#pragma mark Initializers -

@implementation EZYDestinationImageStore

+ (instancetype)sharedDestinationImageStore
{
    static EZYDestinationImageStore *sharedDestinationImageStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDestinationImageStore = [[EZYDestinationImageStore alloc] initPrivate];
    });
    
    return sharedDestinationImageStore;
}

- (instancetype)initPrivate
{
    self = [super init];
    
    if (self) {
        _imageCacheDictionary = [NSMutableDictionary dictionary];
        _fileSystemImageStore = [[EZYImageStoreFileSystem alloc] init];
    }
    
    return self;
}

#pragma mark Adding Images -
- (void)addImage:(UIImage *)image forKey:(NSString *)imageKey
{
    // Write the file to disk
    [self.fileSystemImageStore saveImage:image toFileName:imageKey];
    
    [self.imageCacheDictionary setObject:image forKey:imageKey];
    
    
}

#pragma mark Retrieving Items -

- (UIImage *)imageForKey:(NSString *)imageKey
{
    UIImage *imageToReturn = self.imageCacheDictionary[imageKey];
    
    if (!imageToReturn) {
        // Try loading from the filesystem
        UIImage *imageFromFileSystem = [self.fileSystemImageStore retrieveImageForFilename:imageKey];
        
        if (!imageFromFileSystem) {
            return nil;
        }
        
        [self.imageCacheDictionary setObject:imageFromFileSystem forKeyedSubscript:imageKey];
        
        imageToReturn = imageFromFileSystem;
    }
    
    return imageToReturn;
}

- (NSDictionary *)getImageCacheDictionary
{
    return [NSDictionary dictionaryWithDictionary:self.imageCacheDictionary];
}

#pragma mark Removing Items
- (void)removeImageForKey:(NSString *)imageKey
{
    if (self.imageCacheDictionary[imageKey]) {
        [self.imageCacheDictionary removeObjectForKey:imageKey];
        [self.fileSystemImageStore removeImageForFilename:imageKey];
    }
}


@end
