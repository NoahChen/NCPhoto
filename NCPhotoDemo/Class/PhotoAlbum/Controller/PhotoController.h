//
//  PhotoController.h
//  NCPhotoDemo
//
//  Created by 瑞琪 on 2016/11/30.
//  Copyright © 2016年 cn.rich. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^Block)(NSArray *photoArr);

@interface PhotoController : UIViewController

@property (nonatomic, copy) Block photoBlock;

- (void)returnPhotosBlock:(Block)block;

@end
