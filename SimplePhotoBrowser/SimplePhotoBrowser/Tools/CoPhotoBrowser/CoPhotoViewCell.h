//
//  CoPhotoViewCell.h
//  Consumer
//
//  Created by HONG on 16/9/5.
//  Copyright © 2016年 Autodesk. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotoViewCellDelegate <NSObject>

- (void)photoViewCellDidTapImage;

@end

@interface CoPhotoViewCell : UICollectionViewCell
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, weak) id<PhotoViewCellDelegate> delegate;
@end
