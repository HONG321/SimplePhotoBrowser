//
//  CoPhotoBrowserViewController.m
//  Consumer
//
//  Created by HONG on 16/9/5.
//  Copyright © 2016年 Autodesk. All rights reserved.
//

#import "CoPhotoBrowserViewController.h"
#import "CoPhotoViewCell.h"

@interface CoPhotoBrowserViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,PhotoViewCellDelegate>
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) UICollectionView *collectionView;

// 照片的缩放比例
@property (nonatomic, assign) CGFloat photoScale;
@end

@implementation CoPhotoBrowserViewController

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self prepareLayout];
    
    // 跳转到用户选定的页面
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.currentIndex inSection:0];
    
    if(self.currentIndex>=self.imageURLs.count){
        [self.collectionView scrollsToTop];
        return;
    }
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

- (void)prepareLayout{
    self.layout.itemSize = self.collectionView.bounds.size;
    self.layout.minimumInteritemSpacing = 0;
    self.layout.minimumLineSpacing = 0;
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView.pagingEnabled = YES;
}

- (void)loadView{
    // 将视图的大小“设大”
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    screenBounds.size.width += 20;
    
    self.view = [[UIView alloc] initWithFrame:screenBounds];
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.collectionView];

    self.collectionView.frame = self.view.bounds;
    
    [self prepareCollectionView];
}

static NSString *CoPhotoBrowserCellReuseIdentifier = @"CoPhotoBrowserCellReuseIdentifier";
- (void)prepareCollectionView{
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[CoPhotoViewCell class] forCellWithReuseIdentifier:CoPhotoBrowserCellReuseIdentifier];
}

- (void)close{
    [UIView animateWithDuration:0.25 animations:^{
        self.collectionView.alpha = 0;
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}


// 返回当前显示图片的索引
- (NSInteger)currentImageIndex{
    return self.collectionView.indexPathsForVisibleItems.lastObject.item;
}

// 获得当前显示的 图像视图
- (UIImageView *)currentImageView{
    NSIndexPath *indexPath = self.collectionView.indexPathsForVisibleItems.lastObject;
    CoPhotoViewCell *cell = (CoPhotoViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    return cell.imageView;
}

- (instancetype)initWithUrls:(NSArray *)urls index:(NSInteger)index{
    if(self =[super initWithNibName:nil bundle:nil]){
        self.imageURLs = urls;
        self.currentIndex = (int)index;
    }
    return self;
}

#pragma mark - UICollectionView数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageURLs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CoPhotoViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CoPhotoBrowserCellReuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.imageURL = self.imageURLs[indexPath.item];
    cell.delegate = self;
    return cell;
}


#pragma mark - 代理方法
// 点击关闭
- (void)photoViewCellDidTapImage{
    [self close];
}


#pragma mark - 懒加载控件
- (UICollectionViewFlowLayout *)layout{
    if(_layout == nil){
        _layout = [[UICollectionViewFlowLayout alloc] init];
    }
    return _layout;
}

- (UICollectionView *)collectionView{
    if(_collectionView == nil){
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
    }
    return _collectionView;
}

@end
