//
//  PhotoController.m
//  NCPhotoDemo
//
//  Created by 瑞琪 on 2016/11/30.
//  Copyright © 2016年 cn.rich. All rights reserved.
//

#import "PhotoController.h"
#import <Photos/Photos.h>

#import "AlbumHeadView.h"
#import "AlbumAlertView.h"

#import "PhotoAlbumCell.h"

#import "AlbumCoverModel.h"
#import "PhotoModel.h"

//#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
//#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define ITEMSIZE CGSizeMake(SCREEN_WIDTH/4, SCREEN_WIDTH/4)

@interface PhotoController () <UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate> {
    CGSize _itemSise;
}

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) AlbumHeadView *headView;
@property (nonatomic, strong) AlbumAlertView *alertView;
@property (nonatomic, strong) PHFetchResult *topLevelUserCollections;

@property (nonatomic, strong) NSMutableArray *coverArr;
@property (nonatomic, strong) NSMutableArray *photoArr;

@property (nonatomic, strong) PhotoModel *model;

@end

@implementation PhotoController

- (NSMutableArray *)coverArr {
    if (!_coverArr) {
        _coverArr = [NSMutableArray array];
    }
    return _coverArr;
}

- (NSMutableArray *)photoArr {
    if (!_photoArr) {
        _photoArr = [NSMutableArray array];
    }
    return _photoArr;
}

- (AlbumAlertView *)alertView {
    if (!_alertView) {
        _alertView = [[AlbumAlertView alloc] init];
        [self.view addSubview:_alertView];
    }
    return _alertView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setDefaultProps];
    [self setUI];
    [self fetchPhotos];
}

- (void)setDefaultProps {
    
}

#pragma mark - UI
- (void)setUI {
//    [self addHeadView];
    [self createCollectionView];
}

#pragma mark - HeadView
//- (void)addHeadView {
//    self.headView = [[AlbumHeadView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 46)];
//    [self.headView.cancelBtn addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.headView.continueBtn addTarget:self action:@selector(continueButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.headView addTarget:self action:@selector(changeAlbum)];
//    [self.view addSubview:self.headView];
//}
//
//- (void)cancelButtonClick {
//    [self.navigationController popViewControllerAnimated:YES];
//}
//
//- (void)continueButtonClick {
//    if (self.photoBlock && self.selectImageArr && self.selectImageArr.count > 0) {
//        self.photoBlock(self.selectImageArr);
//    }
//    [self.navigationController popViewControllerAnimated:YES];
//}
//
//- (void)changeAlbum {
//    NSMutableArray *albumCoverArr = [NSMutableArray array];
//    for (NSDictionary *dic in self.coverIocnArr) {
//        [albumCoverArr addObject:[AlbumCoverModel modelWithDictionary:dic]];
//    }
//    [self.alertView refreshAlert:albumCoverArr];
//    [self.alertView showAlert];
//
//    __weak typeof(self) weakSelf = self;
//    [self.alertView returnSelectedRow:^(NSInteger selectedRow) {
//        __strong typeof(self) strongSelf = weakSelf;
//        //        strongSelf.currentAlbum = strongSelf.photoArr[selectedRow][@"photos"];
//        //        [strongSelf.collectionView reloadData];
//        //        self.headView.title = strongSelf.photoArr[selectedRow][@"name"];
//        dispatch_async(dispatch_queue_create("photos_queue", DISPATCH_QUEUE_PRIORITY_DEFAULT), ^{
//            [strongSelf getUserFetchOptionsIsCoverIcon:NO];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                strongSelf.currentAlbum = strongSelf.photoArr[selectedRow];
//                [strongSelf.collectionView reloadData];
//                self.headView.title = strongSelf.coverIocnArr[selectedRow][@"name"];
//            });
//        });
//    }];
//}

#pragma mark - AlertView


#pragma mark - Block
- (void)returnPhotosBlock:(Block)block {
    self.photoBlock = block;
}

#pragma mark - 相册资源获取
- (void)fetchPhotos {
    dispatch_queue_t queue = dispatch_queue_create("photoQueue", DISPATCH_QUEUE_PRIORITY_DEFAULT);
    dispatch_async(queue, ^{
        //所有照片
        [self getAllFetchOptions];
        //封面
        [self getAlbumCover];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
            
            AlbumCoverModel *am = self.coverArr[0];
            self.headView.title = am.name;
            [self.alertView refreshAlert:self.coverArr];
        });
    });
}

//所有照片
- (void)getAllFetchOptions {
    //列出所有用户创建的相册
    //    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    //    PHAsset *asset11 = smartAlbums[0];
    
    self.topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    //    NSLog(@"相册数量---%ld", topLevelUserCollections.count);
    
    //获取所有资源的集合，并按资源的创建时间排序
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
    
    // 在资源的集合中获取第一个集合，并获取其中的图片
    PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
    
    if (assetsFetchResults != nil && assetsFetchResults.count > 0) {
        
        for (int i = 0; i<assetsFetchResults.count; i++) {
            PHAsset *asset = assetsFetchResults[i];
            
            PHImageRequestOptions *opt = [[PHImageRequestOptions alloc] init];
            opt.synchronous = YES;
            
            [imageManager requestImageForAsset:asset
                                    targetSize:ITEMSIZE
                                   contentMode:PHImageContentModeDefault
                                       options:opt
                                 resultHandler:^(UIImage *result, NSDictionary *info) {
                                     if (i == 0) {
                                         NSDictionary *coverDic = @{
                                                                    @"name": @"相机胶卷",
                                                                    @"coverIcon": result
                                                                    };
                                         [self.coverArr insertObject:[AlbumCoverModel modelWithDictionary:coverDic] atIndex:0];
                                     }
                                    
                                     NSDictionary *photoDic = @{
                                                                @"image": result
                                                                };
                                     [self.photoArr addObject:[PhotoModel modelWithDictionary:photoDic]];
                                 }];
        }
    }
}

//封面
- (void)getAlbumCover {
    if (!self.topLevelUserCollections || self.topLevelUserCollections.count == 0) return;
    for (int i = 0; i<self.topLevelUserCollections.count; i++) {
        PHCollection *collection = self.topLevelUserCollections[i];
        NSLog(@"相册名字---%@", collection.localizedTitle);
        if ([collection isKindOfClass:[PHAssetCollection class]]) {
            PHAssetCollection *assetCollction = (PHAssetCollection *)collection;
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollction options:nil];
            PHImageRequestOptions *opt = [[PHImageRequestOptions alloc] init];
            opt.synchronous = YES;
            PHImageManager *imageManeger = [[PHImageManager alloc] init];
            
            [imageManeger requestImageForAsset:fetchResult[0]
                                    targetSize:CGSizeMake(66, 66)
                                   contentMode:PHImageContentModeDefault
                                       options:opt
                                 resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                     NSDictionary *coverDic = @{
                                                                @"name": collection.localizedTitle,
                                                                @"coverIcon": result
                                                                };
                                     [self.coverArr addObject:[AlbumCoverModel modelWithDictionary:coverDic]];
                                 }];
        }
    }
}

//每个相册
- (void)getAlbumFetchOptions {
    [self.photoArr removeAllObjects];
    if (!self.topLevelUserCollections || self.topLevelUserCollections.count == 0) return;
    for (int i = 0; i<self.topLevelUserCollections.count; i++) {
        PHCollection *collection = self.topLevelUserCollections[i];
        if ([collection isKindOfClass:[PHAssetCollection class]]) {
            PHAssetCollection *assetCollction = (PHAssetCollection *)collection;
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollction options:nil];
            PHAsset *asset = nil;
            
            for (NSInteger j = 0; j<fetchResult.count; j++) {
                asset = fetchResult[j];
                PHImageRequestOptions *opt = [[PHImageRequestOptions alloc] init];
                opt.synchronous = YES;
                PHImageManager *imageManeger = [[PHImageManager alloc] init];
                [imageManeger requestImageForAsset:asset
                                        targetSize:ITEMSIZE
                                       contentMode:PHImageContentModeDefault
                                           options:opt
                                     resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                         NSDictionary *photoDic = @{
                                                                    @"image": result
                                                                    };
                                         [self.photoArr addObject:[PhotoModel modelWithDictionary:photoDic]];
                                     }];
            }
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
- (void)createCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.minimumInteritemSpacing = 0.0;
    flowLayout.minimumLineSpacing = 0.0;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.headView.frame.origin.y+self.headView.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT-self.headView.frame.origin.y-self.headView.frame.size.height) collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[PhotoAlbumCell class] forCellWithReuseIdentifier:@"PhotoAlbumCell"];
    [self.view addSubview:self.collectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //NSLog(@"item个数---%lu",(unsigned long)_assetsFetchResults.count);
    return self.photoArr.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return ITEMSIZE;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifierStr = @"PhotoAlbumCell";
    PhotoAlbumCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifierStr forIndexPath:indexPath];
    [self addTapGestureRecognizer:cell];
    
    PhotoModel *model = self.photoArr[indexPath.item];
    cell.image = model.image;
    
    cell.selectBtn.tag = indexPath.item;
    [cell.selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void)selectBtnClick:(UIButton *)sender {
    PhotoModel *model = self.photoArr[sender.tag];
    if (model.isSelected) {
        model.isSelected = NO;
        [sender setImage:[UIImage imageNamed:@"nc_unselect"] forState:UIControlStateNormal];
    } else {
        model.isSelected = YES;
        [sender setImage:[UIImage imageNamed:@"nc_select"] forState:UIControlStateNormal];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

