//
//  AlbumAlertView.h
//  PGErpSystem
//
//  Created by 企鹅iOS陈方舟 on 2018/10/31.
//  Copyright © 2018 Qiekj. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SelectedRowBlock)(NSInteger selectedRow);

@interface AlbumAlertView : UIView

@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, copy) SelectedRowBlock block;

- (void)showAlert;

- (void)hideAlert;

- (void)refreshAlert:(NSArray *)arr;

- (void)returnSelectedRow:(SelectedRowBlock)block;

@end

NS_ASSUME_NONNULL_END
