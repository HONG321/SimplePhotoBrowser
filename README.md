# SimplePhotoBrowser
一款基于UICollectionViewController实现的图片查看器，集成方便。

主界面是基于瀑布流加载图片。只要点击图片，就可以跳转到图片查看器。
图片查看器的源码主要放在Tools文件夹下的CoPhotoBrowser。

只要传递相应的图片url数组即可加载。 可参考Controller文件夹下的LDWaterFallCollectionViewController类collectionView:didSelectItemAtIndexPath方法实现。

CoPhotoBrowserViewController *vc = [[CoPhotoBrowserViewController alloc] initWithUrls:photoArray.copy index:0];
[self presentViewController:vc animated:NO completion:nil];
