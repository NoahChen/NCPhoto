//
//  PhotoManager.m
//  NCPhotoDemo
//
//  Created by 企鹅iOS陈方舟 on 2018/12/10.
//  Copyright © 2018 cn.rich. All rights reserved.
//

#import "PhotoManager.h"
#import <Photos/Photos.h>

@implementation PhotoManager

+ (void)photoAlbumAvailableResponse:(void (^)(BOOL))response {
    // 1.获取相册授权状态
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    
    if (status == PHAuthorizationStatusAuthorized) {
        response(YES);
    }
    else if (status == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                response(YES);
            } else {
                response(NO);
            }
        }];
    } else {
        response(NO);
    }
}

+ (void)takePhotoAvailableResponse:(void (^)(BOOL))response {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        // 1.获取相机授权状态
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        // 2.检测授权状态
        if (status == AVAuthorizationStatusAuthorized) {
            dispatch_async(dispatch_get_main_queue(), ^{
                response(YES);
            });
        }
        else if (status == AVAuthorizationStatusNotDetermined) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // 成功授权
                        response(YES);
                    });
                }else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // 拒绝授权
                        response(NO);
                    });
                }
            }];
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                response(NO);
            });
        }
    } else{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"没有检测到相机");
            response(NO);
        });
    }
}

@end
