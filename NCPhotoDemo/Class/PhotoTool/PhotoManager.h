//
//  PhotoManager.h
//  NCPhotoDemo
//
//  Created by 企鹅iOS陈方舟 on 2018/12/10.
//  Copyright © 2018 cn.rich. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PhotoManager : NSObject

/** 是否允许打开相册 */
+ (void)photoAlbumAvailableResponse:(void(^)(BOOL isEnabled))response;

/** 是否允许拍照 */
+ (void)takePhotoAvailableResponse:(void(^)(BOOL isEnabled))response;

@end

NS_ASSUME_NONNULL_END
