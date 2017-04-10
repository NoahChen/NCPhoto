//
//  PhotoAlbumController.m
//  NCPhotoDemo
//
//  Created by 瑞琪 on 2016/11/30.
//  Copyright © 2016年 cn.rich. All rights reserved.
//

#import "PhotoAlbumController.h"
#import "PhotoController.h"
#import "PhotoAlbumCell.h"
#import <Photos/Photos.h>

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define ITEMSIZE CGSizeMake(SCREEN_WIDTH/4, SCREEN_WIDTH/4)

@interface PhotoAlbumController () <UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate> {
    UICollectionView *_collectionView;
    PHFetchResult *_assetsFetchResults;
    PHCachingImageManager *_imageManager;
    CGSize _itemSise;
    NSMutableArray *_imageArr;
    NSMutableArray *_selectImageArr;
}

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) PHCachingImageManager *imageManager;

@end

@implementation PhotoAlbumController

- (NSMutableArray *)dataArr{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (PHCachingImageManager *)imageManager{
    if (_imageManager == nil) {
        _imageManager = [[PHCachingImageManager alloc] init];
    }
    return _imageManager;
}

- (void)viewWillAppear:(BOOL)animated{
    [self getNotificationCenter];
}

- (void)viewWillDisappear:(BOOL)animated{
//    [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%ld",(long)sender.tag]]
    for (int i = 0; i<_assetsFetchResults.count; i++) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"%d",i]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"相册";
    _imageArr = [NSMutableArray array];
    _selectImageArr = [NSMutableArray array];
    [self getNavigationBarButton];
    [self createCollectionView];
    [self getFetchOptions];
}

- (void)getNavigationBarButton{
    self.navigationItem.backBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClick)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnClick)];
}

- (void)rightBtnClick{
    if (_assetsFetchResults.count != 0) {
        int a = 0;
        for (int i = 0; i<_assetsFetchResults.count; i++) {
            NSNumber *selectNum = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%d",i]];
            if ([selectNum isEqual:@1]) {
                a = 1;
                break;
            }
        }
        if (a == 1) {
            //NSLog(@"图片选择数组---%@",_selectImageArr);
            if (self.photoBlock != nil) {
                self.photoBlock(_selectImageArr);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            NSLog(@"未选择图片");
        }
    }
}

- (void)leftBtnClick{
    if (_assetsFetchResults.count != 0) {
        for (int i = 0; i<_assetsFetchResults.count; i++) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"%d",i]];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 通知中心
- (void)getNotificationCenter{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(photoNotification:) name:@"photo" object:nil];
}

- (void)photoNotification:(NSNotification *)notify{
    if (notify.object) {
        if (self.photoBlock != nil) {
            //NSLog(@"通知---%@",notify.object);
            NSArray *photoNotifyArr = [NSArray arrayWithObject:notify.object];
            self.photoBlock(photoNotifyArr);
        }
        [self.navigationController popViewControllerAnimated:NO];
    }
}

#pragma mark - Block
- (void)returnPhotosBlock:(Block)block{
    self.photoBlock = block;
}

#pragma mark - 相册资源获取
- (void)getFetchOptions{
//    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
//    if (status == PHAuthorizationStatusRestricted ||
//        status == PHAuthorizationStatusDenied) {
//        NSLog(@"不行");
//        return;
//    }
    // 列出所有相册智能相册
    //PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    //PHAsset *asset00 = smartAlbums[0];
    
     //列出所有用户创建的相册
//    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
//    PHAsset *asset11 = smartAlbums[0];
    
     //获取所有资源的集合，并按资源的创建时间排序
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    _assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];

    // 在资源的集合中获取第一个集合，并获取其中的图片
    _imageManager = [[PHCachingImageManager alloc] init];
    
    if (_assetsFetchResults != nil) {
        for (int i = 0; i<_assetsFetchResults.count; i++) {
            PHAsset *asset = _assetsFetchResults[i];
            [_imageManager requestImageForAsset:asset
                                     targetSize:PHImageManagerMaximumSize
                                    contentMode:PHImageContentModeDefault
                                        options:nil
                                  resultHandler:^(UIImage *result, NSDictionary *info) {
                                      
                                      // 得到一张 UIImage，展示到界面上
                                      [_imageArr addObject:result];
                                      if (_imageArr.count == _assetsFetchResults.count) {
//                                          [self createCollectionView];
                                          [_collectionView reloadData];
                                      }
                                  }];
        }
    }
}

#pragma mark - 添加手势判断点击位置
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    NSLog(@"%@",NSStringFromClass([touch.view class]));
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UIButton"]) {
        return YES;
    }else {
        return NO;
    }
}

- (void)addTapGestureRecognizer:(PhotoAlbumCell *)view{
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] init];
    gestureRecognizer.delegate = self;
    [view addGestureRecognizer:gestureRecognizer];
}

#pragma mark - CollectionView
- (void)createCollectionView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.minimumInteritemSpacing = 0.0;
    flowLayout.minimumLineSpacing = 0.0;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[PhotoAlbumCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    [self.view addSubview:_collectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    //NSLog(@"item个数---%lu",(unsigned long)_assetsFetchResults.count);
    return _assetsFetchResults.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return ITEMSIZE;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifierStr = @"UICollectionViewCell";
    PhotoAlbumCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifierStr forIndexPath:indexPath];
    [self addTapGestureRecognizer:cell];
    //[self getPhotoManagerWith:indexPath.item imageView:cell.previewImageView];
    if (_imageArr.count == _assetsFetchResults.count) {
        cell.previewImageView.image = _imageArr[indexPath.item];
    }
    cell.selectBtn.tag = indexPath.item;
    [cell.selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)selectBtnClick:(UIButton *)sender {
    NSNumber *isSelect = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%ld",(long)sender.tag]];
    if (![isSelect isEqual:@1]) {
        [sender setBackgroundImage:[UIImage imageNamed:@"nc_select"] forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:[NSString stringWithFormat:@"%ld",(long)sender.tag]];
        [_selectImageArr addObject:_imageArr[sender.tag]];
        
    }else {
        [sender setBackgroundImage:[UIImage imageNamed:@"nc_unselect"] forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:[NSString stringWithFormat:@"%ld",(long)sender.tag]];
        [_selectImageArr removeObject:_imageArr[sender.tag]];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotoController *pc = [[PhotoController alloc] init];
    pc.photo = _imageArr[indexPath.item];
    pc.photoArr = _imageArr;
    [self presentViewController:pc animated:YES completion:nil];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"photo" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end




