//
//  AlbumCoverModel.h
//  PGErpSystem
//
//  Created by 陈方舟 on 2018/11/2.
//  Copyright © 2018年 Qiekj. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlbumCoverModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) UIImage *coverIcon;

+ (id)modelWithDictionary:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
