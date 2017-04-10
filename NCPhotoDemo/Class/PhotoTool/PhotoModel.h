//
//  PhotoModel.h
//  NCPhotoDemo
//
//  Created by Noah.C on 2017/3/29.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PhotoModel : NSObject

+ (BOOL)openPhotoAlbumAvailable;

+ (BOOL)takePhotoAvailable;

+ (void)saveImage:(UIImage *)image compressionQuality:(CGFloat)compressionQuality;

+ (void)saveImages:(NSArray *)imageArr compressionQuality:(CGFloat)compressionQuality;

+ (UIImage *)wirteImageData:(int)num;

+ (BOOL)hasImageData:(NSString *)path;

+ (NSString *)getSearchPath:(int)num;

@end
