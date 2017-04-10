//
//  PhotoController.m
//  NCPhotoDemo
//
//  Created by 瑞琪 on 2016/11/30.
//  Copyright © 2016年 cn.rich. All rights reserved.
//

#import "PhotoController.h"

static BOOL _isPush;

@interface PhotoController () <UIGestureRecognizerDelegate, UIScrollViewDelegate>{
    UIScrollView *_scrollView;
    UIImageView *_photoView;
    UIView *_selectView;
}

@end

@implementation PhotoController

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _isPush = YES;
    [self createUI];
    [self addGestureRecognizer];
}

- (void)createUI{
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(self.view.frame.size.width*self.photoArr.count, 0);
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    [self.view addSubview:_scrollView];
    
    for (int i = 0; i<self.photoArr.count; i++) {
        _photoView = [[UIImageView alloc] initWithFrame:CGRectMake(_scrollView.frame.size.width*i, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
        _photoView.tag = 100+i;
        _photoView.backgroundColor = [UIColor blackColor];
        _photoView.image = self.photoArr[i];
        _photoView.contentMode = UIViewContentModeScaleAspectFit;
        [_scrollView addSubview:_photoView];
        
        if (self.photo == self.photoArr[i]) {
            [self currentOffsetWithIndex:i];
        }
    }
    
    _selectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    _selectView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [self.view addSubview:_selectView];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 70, _selectView.frame.size.height)];
    backBtn.backgroundColor = [UIColor clearColor];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_selectView addSubview:backBtn];
    
    UIButton *chooseBtn = [[UIButton alloc] initWithFrame:CGRectMake(_selectView.frame.size.width-80, 0, 70, _selectView.frame.size.height)];
    chooseBtn.backgroundColor = [UIColor clearColor];
    [chooseBtn setTitle:@"选择" forState:UIControlStateNormal];
    [chooseBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [chooseBtn addTarget:self action:@selector(chooseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_selectView addSubview:chooseBtn];
}

- (void)currentOffsetWithIndex:(NSInteger)index{
    _scrollView.contentOffset = CGPointMake(self.view.frame.size.width*index, 0);
}

#pragma mark - 手势
- (void)addGestureRecognizer{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeState:)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}

- (void)changeState:(UITapGestureRecognizer *)sender{
    __block CGPoint center = _selectView.center;
    [UIView animateWithDuration:0.5 animations:^{
        if (_isPush == YES) {
            center.y = -_selectView.frame.size.height/2;
            _selectView.center = center;
            _isPush = NO;
        }else{
            center.y = _selectView.frame.size.height/2;
            _selectView.center = center;
            _isPush = YES;
        }
    }];
}

#pragma mark - 按钮点击事件
- (void)backBtnClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)chooseBtnClick{
    NSInteger index = _scrollView.contentOffset.x/self.view.frame.size.width;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"photo" object:self.photoArr[index]];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    __block CGPoint center = _selectView.center;
    [UIView animateWithDuration:0.5 animations:^{
        if (_isPush == YES) {
            center.y = -_selectView.frame.size.height/2;
            _selectView.center = center;
            _isPush = NO;
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

