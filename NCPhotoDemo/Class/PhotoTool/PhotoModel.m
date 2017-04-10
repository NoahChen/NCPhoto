//
//  PhotoModel.m
//  NCPhotoDemo
//
//  Created by Noah.C on 2017/3/29.
//

#import "PhotoModel.h"

@implementation PhotoModel

+ (BOOL)openPhotoAlbumAvailable {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        return YES;
    }
    else{
        return NO;
    }
}

+ (BOOL)takePhotoAvailable {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return YES;
    }
    else{
        return NO;
    }
}

+ (void)saveImages:(NSArray *)imageArr compressionQuality:(CGFloat)compressionQuality {
    if (imageArr == nil) return;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        for (int i = 0; i<imageArr.count; i++) {
            NSString *imgPath = [self getSearchPath:i];
            if ([self hasImageData:imgPath] == YES) {
                [self removeImageDataWithPath:imgPath];
            }
            NSData *imgData = UIImageJPEGRepresentation(imageArr[i], compressionQuality);
            [imgData writeToFile:imgPath atomically:YES];
        }
    });
}

+ (void)saveImage:(UIImage *)image compressionQuality:(CGFloat)compressionQuality {
    if (image == nil) return;
    NSString *imgPath = [self getSearchPath:0];
    if ([self hasImageData:imgPath] == YES) {
        [self removeImageDataWithPath:imgPath];
    }
    NSData *imgData = UIImageJPEGRepresentation(image, compressionQuality);
    [imgData writeToFile:imgPath atomically:YES];
}

+ (BOOL)hasImageData:(NSString *)path {
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return YES;
    }else{
        return NO;
    }
}

+ (void)removeImageDataWithPath:(NSString *)path {
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

+ (UIImage *)wirteImageData:(int)num {
    NSString *imgPath = [self getSearchPath:num];
    if ([self hasImageData:imgPath] == YES) {
        NSData *imgData = [NSData dataWithContentsOfFile:imgPath];
        UIImage *img = [UIImage imageWithData:imgData];
        return img;
    }
    return nil;
}

+ (NSString *)getSearchPath:(int)num {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *imgPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"photo_%d", 10000+num]];
    return imgPath;
}

@end




