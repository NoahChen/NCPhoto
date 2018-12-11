//
//  PhotosCell.m
//  PGErpSystem
//
//  Created by 企鹅iOS陈方舟 on 2018/10/31.
//  Copyright © 2018 Qiekj. All rights reserved.
//

#import "PhotosCell.h"

@implementation PhotosCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.contentView.layer.borderWidth = 1.0;
        [self createSubView];
    }
    return self;
}

- (void)createSubView {
    self.previewImageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
    [self.contentView addSubview:self.previewImageView];
}

@end
