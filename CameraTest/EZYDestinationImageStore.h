//
//  EZYDestinationImageStore.h
//  CameraTest
//
//  Created by Erik Allar on 3/25/15.
//  Copyright (c) 2015 Erik Allar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface EZYDestinationImageStore : NSObject

+ (instancetype)sharedDestinationImageStore;

- (void)addImage:(UIImage *)image forKey:(NSString *)imageKey;
- (UIImage *)imageForKey:(NSString *)imageKey;
- (void)removeImageForKey:(NSString *)imageKey;
- (NSDictionary *)getImageCacheDictionary;

@end
