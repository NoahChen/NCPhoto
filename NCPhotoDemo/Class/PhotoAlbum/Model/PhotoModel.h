//
//  PhotoModel.h
//  NCPhotoDemo
//
//  Created by 企鹅iOS陈方舟 on 2018/12/11.
//  Copyright © 2018 cn.rich. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PhotoModel : NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) BOOL isSelected;

+ (id)modelWithDictionary:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
