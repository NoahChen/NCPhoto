//
//  AlbumHeadView.m
//  PGErpSystem
//
//  Created by 企鹅iOS陈方舟 on 2018/10/31.
//  Copyright © 2018 Qiekj. All rights reserved.
//

#import "AlbumHeadView.h"
#import "SelectAlbumBtn.h"

@interface AlbumHeadView ()

@property (nonatomic, strong) SelectAlbumBtn *selectAlbumBtn;

@end

@implementation AlbumHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    self.cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 0, 38, self.frame.size.height)];
    self.cancelBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self addSubview:self.cancelBtn];
    
    [self addSelectAlbumBtn];
    
    self.continueBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width-15-38, 0, 38, self.frame.size.height)];
    self.continueBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    [self.continueBtn setTitle:@"继续" forState:UIControlStateNormal];
    [self.continueBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [self addSubview:self.continueBtn];
}

- (void)addSelectAlbumBtn {
    CGFloat btnWidth = 120;
    self.selectAlbumBtn = [[SelectAlbumBtn alloc] initWithFrame:CGRectMake(self.center.x-btnWidth/2, 12, btnWidth, 23) title:@"相机胶卷" imageName:@""];
    [self addSubview:self.selectAlbumBtn];
}

- (void)setTitle:(NSString *)title {
    [self.selectAlbumBtn setTitle:title forState:UIControlStateNormal];
}

- (void)addTarget:(id)target action:(SEL)action {
    [self.selectAlbumBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

@end
