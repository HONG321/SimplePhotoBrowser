//
//  CoPhotoBrowserViewController.h
//  Consumer
//
//  Created by HONG on 16/9/5.
//  Copyright © 2016年 Autodesk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoPhotoBrowserViewController : UIViewController
// 图像的数据
@property (nonatomic,strong) NSArray *imageURLs;
// 用户选中照片的索引
@property (nonatomic,assign) int currentIndex;

- (instancetype)initWithUrls:(NSArray *)urls index:(NSInteger)index;

// 返回当前显示图片的索引
- (NSInteger)currentImageIndex;
// 获得当前显示的 图像视图
- (UIImageView *)currentImageView;
@end
