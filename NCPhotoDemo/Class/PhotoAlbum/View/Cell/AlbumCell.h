//
//  AlbumCell.h
//  PGErpSystem
//
//  Created by 企鹅iOS陈方舟 on 2018/10/31.
//  Copyright © 2018 Qiekj. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlbumCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

NS_ASSUME_NONNULL_END
