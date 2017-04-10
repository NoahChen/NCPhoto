//
//  PhotoAlbumCell.m
//  NCPhotoDemo
//
//  Created by 瑞琪 on 2016/12/1.
//  Copyright © 2016年 cn.rich. All rights reserved.
//

#import "PhotoAlbumCell.h"

@implementation PhotoAlbumCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self createSubView];
    }
    return self;
}

- (void)createSubView{
    self.previewImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:self.previewImageView];
    
    self.selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-30, 5, 25, 25)];
    self.selectBtn.backgroundColor = [UIColor clearColor];
    self.selectBtn.layer.cornerRadius = 25/2.0;
    self.selectBtn.layer.masksToBounds = YES;
    [self.selectBtn setBackgroundImage:[UIImage imageNamed:@"nc_unselect"] forState:UIControlStateNormal];
    [self addSubview:self.selectBtn];
}


@end
