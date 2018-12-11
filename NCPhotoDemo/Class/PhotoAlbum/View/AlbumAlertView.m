//
//  AlbumAlertView.m
//  PGErpSystem
//
//  Created by 企鹅iOS陈方舟 on 2018/10/31.
//  Copyright © 2018 Qiekj. All rights reserved.
//

#import "AlbumAlertView.h"
#import "AlbumCell.h"
#import "AlbumCoverModel.h"

#define VIEW_HEIGHT 285
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface AlbumAlertView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation AlbumAlertView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor lightGrayColor];
        self.frame = CGRectMake(0, -VIEW_HEIGHT, SCREEN_WIDTH, VIEW_HEIGHT);
        self.isShow = NO;
        [self setUI];
    }
    return self;
}

- (void)showAlert {
    if (!self.isShow) {
        CGRect viewFrame = self.frame;
        viewFrame.origin.y = 46;
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = viewFrame;
        } completion:^(BOOL finished) {
            self.isShow = YES;
        }];
    }
}

- (void)hideAlert {
    if (self.isShow) {
        CGRect viewFrame = self.frame;
        viewFrame.origin.y = -VIEW_HEIGHT;
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = viewFrame;
        } completion:^(BOOL finished) {
            self.isShow = NO;
        }];
    }
}

- (void)refreshAlert:(NSArray *)arr {
    self.dataArr = arr;
    [self.tableView reloadData];
}

- (void)returnSelectedRow:(SelectedRowBlock)block {
    self.block = block;
}

- (void)setUI {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, VIEW_HEIGHT)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 95;
    self.tableView.separatorColor = [UIColor grayColor];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.showsVerticalScrollIndicator = NO;
    [self addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"AlbumCell";
    AlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AlbumCell" owner:self options:nil] firstObject];
    }
    AlbumCoverModel *model = self.dataArr[indexPath.row];
    cell.titleLabel.text = model.name;
    cell.photoView.image = model.coverIcon;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.block) {
        self.block(indexPath.row);
    }
    [self hideAlert];
}

@end
