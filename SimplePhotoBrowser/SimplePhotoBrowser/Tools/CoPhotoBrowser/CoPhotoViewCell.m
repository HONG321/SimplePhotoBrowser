//
//  CoPhotoViewCell.m
//  Consumer
//
//  Created by HONG on 16/9/5.
//  Copyright © 2016年 Autodesk. All rights reserved.
//

#import "CoPhotoViewCell.h"
#import "UIImageView+WebCache.h"

@interface CoPhotoViewCell ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@end

@implementation CoPhotoViewCell

- (void)setImageURL:(NSURL *)imageURL{
    // 重设scrollView
    [self resetScrollView];
    
    [self.indicator startAnimating];
    
    _imageURL = imageURL;
    [self.imageView sd_setImageWithURL:imageURL placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self.indicator stopAnimating];
        [self.imageView sizeToFit];
        
        [self imagePosition:image];
    }];
}

// 重设scrollView内容参数
- (void)resetScrollView{
    self.scrollView.zoomScale = 1.0f;
    self.scrollView.contentInset = UIEdgeInsetsZero;
    self.scrollView.contentOffset = CGPointZero;
    self.scrollView.contentSize = CGSizeZero;
}

// 设置图片位置
- (void)imagePosition:(UIImage *)image{
    // 计算y值
    CGSize size = [self displaySize:image];
    
    // 判断是否是长图
    if(self.bounds.size.height < size.height){
        self.imageView.frame = CGRectMake(0, 0, size.width, size.height);
        self.scrollView.contentSize = size;
    }else {
        // 短图
        CGFloat y = (self.frame.size.height - size.height) * 0.5;
        self.imageView.frame = CGRectMake(0, y, size.width, size.height);
        
        // 设置scrollView的边距
        self.imageView.frame = CGRectMake(0, 0, size.width, size.height);
        self.scrollView.contentInset = UIEdgeInsetsMake(y, 0, 0, 0);
    }
}

/// 根据图像计算显示的尺寸
- (CGSize)displaySize:(UIImage *)image{
    CGFloat scale = image.size.height / image.size.width;
    CGFloat h = self.scrollView.bounds.size.width * scale;
    return CGSizeMake(self.scrollView.bounds.size.width, h);
}

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self addSubview:self.scrollView];
        self.scrollView.frame = [UIScreen mainScreen].bounds;
        self.scrollView.backgroundColor = [UIColor clearColor];
        self.scrollView.delegate = self;
        self.scrollView.minimumZoomScale = 1.0;
        self.scrollView.maximumZoomScale = 2.0;
        [self.scrollView addSubview:self.imageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage)];
        [self.scrollView addGestureRecognizer:tap];
        
        self.imageView.userInteractionEnabled = YES;
        
        [self addSubview:self.indicator];
        self.indicator.center = self.center;
    }
    return self;
}


- (void)clickImage{
    if([self.delegate respondsToSelector:@selector(photoViewCellDidTapImage)]){
        [self.delegate photoViewCellDidTapImage];
    }
}

#pragma mark - UIScrollView数据源
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    // 重新计算边距
    CGFloat offsetX = (scrollView.frame.size.width - self.imageView.frame.size.width) * 0.5;
    if(offsetX < 0) {
        offsetX = 0;
    }
    
    CGFloat offsetY = (scrollView.frame.size.height - self.imageView.frame.size.height) * 0.5;
    if(offsetY < 0){
        offsetY = 0;
    }
    
    // 重新设置边距
    scrollView.contentInset = UIEdgeInsetsMake(offsetY, offsetX, 0, 0);
}


- (UIScrollView *)scrollView{
    if(_scrollView == nil){
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    }
    return _scrollView;
}

- (UIImageView *)imageView{
    if(_imageView == nil){
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (UIActivityIndicatorView *)indicator{
    if(_indicator == nil){
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    }
    return _indicator;
}
@end
