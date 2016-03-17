//
//  SKComposephotosView.m
//  YQFDiscover
//
//  Created by 黄松凯 on 16/1/11.
//  Copyright © 2016年 SK. All rights reserved.
//

#define photoViewCell @"photoViewCell"

#import "SKComposephotosView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "SKComposePhotoViewCell.h"
#import "JKImagePickerController.h"

@interface SKComposephotosView()<UICollectionViewDataSource,UICollectionViewDelegate,JKImagePickerControllerDelegate>

@end



@implementation SKComposephotosView


 -(UICollectionView *)collectionView
{
    if(_collectionView==nil)
    {
        UICollectionViewFlowLayout *layout =[[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 5.0;
        layout.minimumInteritemSpacing = 5.0;
        //layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.scrollDirection=UICollectionViewScrollDirectionVertical;
        int itemWidth=(SCREEN_WIDTH-22-30)/4;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH, 160) collectionViewLayout:layout];
        [_collectionView registerClass:[SKComposePhotoViewCell class] forCellWithReuseIdentifier:photoViewCell];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate=self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [self addSubview:_collectionView];
        _addButton.frame= CGRectMake(12, 10, itemWidth, itemWidth);
    }
    return _collectionView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self=[super initWithFrame:frame])
    {
        UIImage  *img = [UIImage imageNamed:@"uploadImg"];
        UIButton   *button = [UIButton buttonWithType:UIButtonTypeCustom];
        //CGFloat collectionY = CGRectGetMaxY(self.collectionView.frame);
        int itemWidth=(SCREEN_WIDTH-22-30)/4;
        button.frame = CGRectMake(12, 10, itemWidth, itemWidth);
        [button setBackgroundImage:img forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"uploadImg"] forState:UIControlStateHighlighted];
       // button.hidden = YES;
        self.addButton = button;
        [self addSubview:button];

    }
    return self;
}

-(void)runInMainQueue:(void (^)())queue{
    dispatch_async(dispatch_get_main_queue(), queue);
}

-(void)runInGlobalQueue:(void (^)())queue{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), queue);
}

-(void)setAssetsArray:(NSMutableArray *)assetsArray {
    
    _assetsArray = assetsArray;
    
    NSMutableArray *tempbox = [NSMutableArray array];
    for(JKAssets *asset in assetsArray){
        
        [tempbox addObject:asset.photo];
    }
    
    self.selectedPhotos = [NSArray arrayWithArray:tempbox];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  [self.assetsArray count];
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SKComposePhotoViewCell *cell = (SKComposePhotoViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:photoViewCell forIndexPath:indexPath];
    
    cell.asset = [self.assetsArray objectAtIndex:[indexPath row]];
    
    cell.deletePhotoBtn.tag = indexPath.row;
    cell.indexPath = indexPath;
    [cell.deletePhotoBtn addTarget:self action:@selector(deleteView:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;

}
- (void)deleteView:(id)sender{
    
    NSInteger deletedPhoto = ((UIButton *)sender).tag;
    for (SKComposePhotoViewCell *currentCell in [self.collectionView subviews]){
        
        if (deletedPhoto == currentCell.indexPath.row){
            
            if (self.assetsArray.count > 0){
                [self.assetsArray removeObjectAtIndex:deletedPhoto];
                [UIView animateWithDuration:1 animations:^{
                    
                    currentCell.frame = CGRectMake(currentCell.frame.origin.x, currentCell.frame.origin.y + 100, 0, 0);
                    [currentCell removeFromSuperview];
                }completion:^(BOOL finished) {
                    
                }];
                
            }
            
        }
        
        if (deletedPhoto < currentCell.indexPath.row){
            currentCell.deletePhotoBtn.tag -= 1;
        }
        
    }
    [self.collectionView reloadData];
    
    
    
}




- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    int itemWidth=(SCREEN_WIDTH-22-30)/4;
    return CGSizeMake(itemWidth, itemWidth);
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",(long)[indexPath row]);
    
}




@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com