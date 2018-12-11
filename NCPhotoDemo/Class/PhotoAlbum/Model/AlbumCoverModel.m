//
//  AlbumCoverModel.m
//  PGErpSystem
//
//  Created by 陈方舟 on 2018/11/2.
//  Copyright © 2018年 Qiekj. All rights reserved.
//

#import "AlbumCoverModel.h"

@implementation AlbumCoverModel

+ (id)modelWithDictionary:(NSDictionary *)dic {
    AlbumCoverModel *model = [[AlbumCoverModel alloc] init];
    [model setValuesForKeysWithDictionary:dic];
    return model;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
