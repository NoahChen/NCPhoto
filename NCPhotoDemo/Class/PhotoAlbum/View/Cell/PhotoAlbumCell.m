//
//  PhotoAlbumCell.m
//  NCPhotoDemo
//
//  Created by 瑞琪 on 2016/12/1.
//  Copyright © 2016年 cn.rich. All rights reserved.
//

#import "PhotoAlbumCell.h"

@interface PhotoAlbumCell ()

@property (nonatomic, strong) UIImageView *photoView;

@end

@implementation PhotoAlbumCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self createSubView];
    }
    return self;
}

- (void)createSubView {
    self.photoView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:self.photoView];
    
    self.selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-30, 5, 25, 25)];
    self.selectBtn.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0];
    self.selectBtn.layer.cornerRadius = 25/2.0;
    self.selectBtn.layer.masksToBounds = YES;
    [self.selectBtn setImage:[UIImage imageNamed:@"nc_unselect"] forState:UIControlStateNormal];
    [self addSubview:self.selectBtn];
}

- (void)setImage:(UIImage *)image {
    self.photoView.image = image;
}

@end
