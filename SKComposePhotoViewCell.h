//
//  SKComposePhotoViewCell.h
//  YQFDiscover
//
//  Created by 黄松凯 on 16/1/11.
//  Copyright © 2016年 SK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JKAssets.h"



@interface SKComposePhotoViewCell : UICollectionViewCell

@property(nonatomic,strong) JKAssets *asset;
@property(nonatomic,weak) UIButton *deletePhotoBtn;
@property(nonatomic,strong) NSIndexPath *indexPath;
@property(nonatomic,strong) UIImageView *imageView;




@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com