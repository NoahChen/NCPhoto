//
//  PhotoModel.m
//  NCPhotoDemo
//
//  Created by 企鹅iOS陈方舟 on 2018/12/11.
//  Copyright © 2018 cn.rich. All rights reserved.
//

#import "PhotoModel.h"

@implementation PhotoModel

+ (id)modelWithDictionary:(NSDictionary *)dic {
    PhotoModel *model = [[PhotoModel alloc] init];
    [model setValuesForKeysWithDictionary:dic];
    return model;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
