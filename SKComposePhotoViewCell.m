//
//  SKComposePhotoViewCell.m
//  YQFDiscover
//
//  Created by 黄松凯 on 16/1/11.
//  Copyright © 2016年 SK. All rights reserved.
//

#import "SKComposePhotoViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>

#import "SKComposePhotoViewCell.h"
#import "JKImagePickerController.h"




@implementation SKComposePhotoViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self=[super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor bgColor];
        
        [self imageView];
    }
    return self;
}


- (void)setAsset:(JKAssets *)asset
{
if(_asset !=asset)
{
    _asset = asset;
    self.imageView.image = asset.photo;
}
}

- (UIImageView *)imageView
{
    if(_imageView==nil)
    {
        _imageView =[[UIImageView alloc]initWithFrame:self.contentView.bounds];
        _imageView.backgroundColor=[UIColor bgColor];
        _imageView.clipsToBounds = YES;
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _imageView.layer.cornerRadius = 5.0f;
        _imageView.layer.borderWidth = 0.5;
        _imageView.layer.borderColor = [UIColor bgColor].CGColor;
        
        
        UIButton *buttonClose = [[UIButton alloc]init];
        UIImageView *imgCloseButton = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        imgCloseButton.image = [UIImage imageNamed:@"compose_close"];
        [buttonClose addSubview:imgCloseButton];
        
        buttonClose.frame = CGRectMake(_imageView.frame.size.width-25, 0, 25, 25);
        
        self.deletePhotoBtn = buttonClose;
        
        [self.contentView addSubview:_imageView];
        [self.contentView addSubview:buttonClose];
  
        
    }
    return _imageView;
}

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com