//
//  PostViewController.h
//  EltDoctor
//
//  Created by elt on 15/12/15.
//  Copyright © 2015年 elt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceholderTextView.h"
#import "SKComposephotosView.h"
@interface PostViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property(nonatomic,strong)UIScrollView* scrollView;
@property (nonatomic, strong) UITextField *postTitle;
@property (nonatomic, strong) PlaceholderTextView *content;
@property (nonatomic, strong) UIButton *subBt;
@property (nonatomic, strong) UIView *btBg;
@property (nonatomic, assign) CGRect viewFrame;

@property(nonatomic,strong)UIImageView* curImageView;
@property(nonatomic,assign)int uploadNum;
@property(nonatomic,strong)NSMutableArray* uploadData;
@property(nonatomic,assign)int cateid;
@property(nonatomic,assign)int keyboardHeight;
@property(nonatomic,strong) SKComposephotosView *photosView;
@end
