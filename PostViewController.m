//
//  PostViewController.m
//  EltDoctor
//
//  Created by elt on 15/12/15.
//  Copyright © 2015年 elt. All rights reserved.
//

#import "PostViewController.h"
#import "JKImagePickerController.h"
@interface PostViewController ()<JKImagePickerControllerDelegate>

@end

@implementation PostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    _uploadNum=0;
    _uploadData=[NSMutableArray new];
    self.navigationItem.titleView = [Utils getTitleLabel:@"发布话题"];
    [self.navigationController.navigationBar setBarTintColor:[UIColor navbarColor]];
    [Utils setBackBt:self.navigationItem con:self.navigationController];
    _scrollView= [[UIScrollView alloc] initWithFrame: self.view.frame];
    
    _scrollView.showsVerticalScrollIndicator=NO;
    //设置允许滚动的范围
    _scrollView.contentSize=CGSizeMake(0,SCREEN_HEIGHT+1);
    
    [self.view addSubview:_scrollView];
    [self initView];
    //添加手势，点击屏幕其他区域关闭键盘的操作
}
-(void)initView{
    self.view.backgroundColor=[UIColor bgColor];
    _postTitle=[[UITextField alloc]initWithFrame:CGRectMake(20, 15, SCREEN_WIDTH-40, 40)];
    _postTitle.backgroundColor=[UIColor whiteColor];
    _postTitle.returnKeyType=UIReturnKeyDone;
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 40)];
    paddingView.backgroundColor=[UIColor whiteColor];
    _postTitle.leftView = paddingView;
    _postTitle.leftViewMode = UITextFieldViewModeAlways;
    
    _postTitle.placeholder=@"标题";
    _postTitle.delegate=self;
    [_scrollView addSubview:_postTitle];

    _content = [PlaceholderTextView new];
    [_content setFrame:CGRectMake(20, 70, SCREEN_WIDTH-40, 150)];
    _content.delegate=self;
    _content.placeholder = @"内容";
    _content.font = [UIFont systemFontOfSize:17];
    _content.translatesAutoresizingMaskIntoConstraints = NO;

    [_scrollView addSubview:_content];
    
    _photosView =[[SKComposephotosView alloc]init];
    _photosView.frame=CGRectMake(20, 235, 250, 250);
    [_photosView.addButton addTarget:self action:@selector(addButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_photosView];
    
    //[self createUpload];
    _btBg=[[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-124, SCREEN_WIDTH, 60)];
    _btBg.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_btBg];
    _subBt=[[UIButton alloc]initWithFrame:CGRectMake(20, 10, SCREEN_WIDTH-40, 40)];
    _subBt.tag=1;
    [_subBt addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    [_subBt setTitle: @"立即发布" forState: UIControlStateNormal];
    [_subBt setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    _subBt.titleLabel.font = [UIFont systemFontOfSize: 16.0];
    _subBt.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _subBt.layer.cornerRadius=7;
    _subBt.layer.masksToBounds=YES;
    _subBt.backgroundColor=[UIColor colorWithHex:0xe67628];
    [_subBt setBackgroundImage:[Utils imageWithColor:[UIColor grayColor]] forState:UIControlStateHighlighted];
    [_btBg addSubview:_subBt];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
}
#pragma mark JKImagePickerView的协议方法
//点击取消时会销毁当前的照片控制器
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - JKImagePickerControllerDelegate
/*- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAsset:(JKAssets *)asset isSource:(BOOL)source
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}*/


- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAssets:(NSArray *)assets isSource:(BOOL)source
{
    CGSize size;
    if(source)size=CGSizeMake(800, 800);else size=CGSizeMake(600, 600);
    self.photosView.assetsArray = [NSMutableArray arrayWithArray:assets];
    [_uploadData removeAllObjects];
    for(JKAssets *asset in assets){
        UIImage *newImg= [Utils thumbnailWithImageWithoutScale:asset.photo size:size];
        [_uploadData addObject:newImg];
    }
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        if ([self.photosView.assetsArray count] > 0){
            
            self.photosView.addButton.hidden = NO;
        }
        [self.photosView.collectionView reloadData];
    }];
}
- (void)addButtonClicked:(id)sender {
    NSLog(@"click upload");
    JKImagePickerController *imagePickerController = [[JKImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.showsCancelButton = YES;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.minimumNumberOfSelection = 1;
    imagePickerController.maximumNumberOfSelection = 9;
    imagePickerController.selectedAssetArray = self.photosView.assetsArray;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    [self presentViewController:navigationController animated:YES completion:NULL];
}
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    _keyboardHeight = keyboardRect.size.height;
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    if((textView.frame.origin.y+64+textView.frame.size.height)>(SCREEN_HEIGHT-_keyboardHeight)){
        NSTimeInterval animationDuration=0.30f;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        int scy=(textView.frame.origin.y+64+textView.frame.size.height)-(SCREEN_HEIGHT-_keyboardHeight);
        CGRect rect=CGRectMake(0.0f,-scy,SCREEN_WIDTH,SCREEN_HEIGHT);
        _scrollView.frame=rect;
        [UIView commitAnimations];
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect=CGRectMake(0.0f,0.0f,SCREEN_WIDTH,SCREEN_HEIGHT);
    _scrollView.frame=rect;
    [UIView commitAnimations];
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightButton addTarget:self action:@selector(finish:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    return YES;
}
-(void)finish:(id)sender{
    self.navigationItem.rightBarButtonItem = nil;
    [_content resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//上传图片
-(void)save:(id)sender{
    if([_postTitle.text isEqualToString:@""]){
        MBProgressHUD *HUD = [Utils createHUD];
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.labelText = @"请输入标题";
        [HUD hide:YES afterDelay:1];
        return;
    }
    if([_content.text isEqualToString:@""]){
        MBProgressHUD *HUD = [Utils createHUD];
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.labelText = @"请输入内容";
        [HUD hide:YES afterDelay:1];
        return;
    }
    MBProgressHUD *HUD = [Utils createHUD];
    HUD.labelText = @"正在提交...";
    // 1. Create `AFHTTPRequestSerializer` which will create your request.
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"uid"] =[userDefaultes stringForKey:@"uid"];
    params[@"title"] =_postTitle.text;
    params[@"content"] =_content.text;
    params[@"cateid"] =[NSString stringWithFormat:@"%d",_cateid];
    // 2. Create an `NSMutableURLRequest`.
    NSMutableURLRequest *request =
    [serializer multipartFormRequestWithMethod:@"POST" URLString:[NSString stringWithFormat:@"%@/DoctorForum/addPosts",API] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for(int i=0;i<_uploadData.count;i++){
            UIImage *resource=_uploadData[i];
            //上传图片
            if ([resource isKindOfClass:[UIImage class]]) {
                NSLog(@"上传图片");
                //把图片转换成NSData类型的数据
                NSData *imageData = UIImagePNGRepresentation(resource);
                //把图片拼接到数据中
                [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"file%d",i] fileName:@"123.png" mimeType:@"image/png"];
            }
        }
    } error:nil];
    
    // 3. Create and use `AFHTTPRequestOperationManager` to create an `AFHTTPRequestOperation` from the `NSMutableURLRequest` that we just created.
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    AFHTTPRequestOperation *operation =[manager HTTPRequestOperationWithRequest:request
                                                                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                                            NSLog(@"dic%@",responseObject);
                                                                            int code=[responseObject[@"code"]intValue];
                                                                            NSString *message=responseObject[@"message"];
                                                                            HUD.mode = MBProgressHUDModeCustomView;
                                                                            if (code == 1) {
                                                                                HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-done"]];
                                                                                HUD.labelText = @"保存成功";
                                                                                [self.navigationController popToRootViewControllerAnimated:YES];
                                                                            } else {
                                                                                HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                                                                                HUD.labelText = message;
                                                                            }
                                                                            [HUD hide:YES afterDelay:1];
                                                                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                            HUD.mode = MBProgressHUDModeCustomView;
                                                                            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HUD-error"]];
                                                                            HUD.labelText = @"网络异常，保存失败";
                                                                            [HUD hide:YES afterDelay:1];
                                                                        }];
    
    // 4. Set the progress block of the operation.
    [operation setUploadProgressBlock:^(NSUInteger __unused bytesWritten,
                                        long long totalBytesWritten,
                                        long long totalBytesExpectedToWrite) {
        int percent=totalBytesWritten*1.0/totalBytesExpectedToWrite*100;
        NSLog(@"%d",percent);
        
        HUD.labelText = [NSString stringWithFormat:@"上传图片:%d%%",percent];
        
        //NSLog(@"Wrote %lld/%lld", totalBytesWritten, totalBytesExpectedToWrite);
    }];
    
    // 5. Begin!
    [operation start];
}
-(void)createUpload{
    if(_uploadNum==3)return;
    int j=_uploadNum%3;
    int k=_uploadNum/3;
    UIImageView *upItem=[[UIImageView alloc]initWithFrame:CGRectMake(20+j*90, 235+k*90, 80, 80)];
    [upItem setImage:[UIImage imageNamed:@"uploadImg"]];
    upItem.userInteractionEnabled=YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uploadClicked:)];
    [upItem addGestureRecognizer:singleTap];
    [_scrollView addSubview:upItem];
    _uploadNum++;
}
-(void)uploadClicked:(UIGestureRecognizer *)recognizer{
    JKImagePickerController *imagePickerController =[[JKImagePickerController alloc]init];
    imagePickerController.delegate=self;
    imagePickerController.showsCancelButton = YES;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.minimumNumberOfSelection = 1;
    imagePickerController.maximumNumberOfSelection = 9;
    imagePickerController.selectedAssetArray= _photosView.assetsArray;
    UINavigationController *navVc = [[UINavigationController alloc]initWithRootViewController:imagePickerController];
    [self presentViewController:navVc animated:YES completion:NULL];
    
    /*UIImageView *view=(UIImageView *)recognizer.view;
    _curImageView=view;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle: UIAlertControllerStyleActionSheet];
    UIAlertAction *takeAction = [UIAlertAction actionWithTitle:@"打开照相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {[self takePhoto];}];
    UIAlertAction *localAction = [UIAlertAction actionWithTitle:@"从手机相册获取" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {[self LocalPhoto];}];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [alertController addAction:localAction];
    [alertController addAction:takeAction];
    [self presentViewController:alertController animated:YES completion:nil];*/
}
//开始拍照
-(void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else{
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}

//打开本地相册
-(void)LocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil)
        {
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        else
        {
            data = UIImagePNGRepresentation(image);
        }
        //关闭相册界面
        [self dismissViewControllerAnimated:YES completion:NULL];
        UIImage *newImg= [Utils thumbnailWithImageWithoutScale:image size:CGSizeMake(200, 200)];
        _curImageView.image=newImg;
        [_uploadData addObject:newImg];
        [self createUpload];
    }
}
-(BOOL) textFieldShouldReturn : (UITextField*) textField {
    [textField resignFirstResponder];
    return YES;
}
@end
