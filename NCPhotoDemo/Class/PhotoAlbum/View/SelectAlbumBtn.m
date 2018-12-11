//
//  SelectAlbumBtn.m
//  PGErpSystem
//
//  Created by 企鹅iOS陈方舟 on 2018/10/31.
//  Copyright © 2018 Qiekj. All rights reserved.
//

#import "SelectAlbumBtn.h"

@implementation SelectAlbumBtn

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title imageName:(NSString *)imageName {
    if (self = [super initWithFrame:frame]) {
        
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        self.imageView.contentMode = UIViewContentModeCenter;
        self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake(102, 0, contentRect.size.width-102, contentRect.size.height);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake(0, 0, 102, contentRect.size.height);
}

@end
