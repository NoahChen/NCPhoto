//
//  AlbumHeadView.h
//  PGErpSystem
//
//  Created by 企鹅iOS陈方舟 on 2018/10/31.
//  Copyright © 2018 Qiekj. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlbumHeadView : UIView

@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *continueBtn;
@property (nonatomic, copy) NSString *title;

- (void)addTarget:(id)target action:(SEL)action;

@end

NS_ASSUME_NONNULL_END
