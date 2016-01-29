//
//  KKFeedbackViewController.m
//  KekeEatWhat
//
//  Created by 凌空 on 16/1/4.
//  Copyright © 2016年 fharmony. All rights reserved.
//

#import "KKFeedbackVC.h"
#import "KKColorManager.h"
#import "UMFeedback.h"
#import "KKMessageView.h"
#import "KKChooseView.h"

@interface KKFeedbackVC ()<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,KKChooseViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *bgImg;
@property (weak, nonatomic) IBOutlet UIButton *atBtn;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property(nonatomic, strong) UIImage *uploadImage;
@property(nonatomic, weak) KKChooseView *msView;

- (IBAction)sendBtn:(UIButton *)sender;
- (IBAction)attachmentBtn:(UIButton *)sender;
- (IBAction)cancelBtn:(UIButton *)sender;

@end

@implementation KKFeedbackVC

- (UIImage *)uploadImage
{
    if (!_uploadImage)
    {
        _uploadImage = [[UIImage alloc] init];

    }
    return _uploadImage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBasicAppearence];
    // Do any additional setup after loading the view.
}

- (void)setupBasicAppearence
{
    self.view.backgroundColor = [[KKColorManager sharedManager] getRandomNormalColor];
    self.bgImg.layer.cornerRadius = 4;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)sendBtn:(UIButton *)sender
{
    if (self.contentTextView.text.length > 4)
    {
        NSMutableDictionary *feedbackParams = [NSMutableDictionary dictionary];
        feedbackParams[@"content"] = self.contentTextView.text;
        if (self.uploadImage)
        {
            feedbackParams[@"UMFeedbackMediaTypeImage"] = self.uploadImage;
        }

        [[UMFeedback sharedInstance] post:feedbackParams completion:^(NSError *error) {
          if (!error)
          {
              KKChooseView *chooseView = [[KKChooseView alloc] initWithTitle:@"\n发送成功!\n您是否愿意提供联系方式以便获得最新反馈" AndImage:nil success:@"是" fail:@"否"];
              self.msView = chooseView;
              chooseView.delegate = self;
              [chooseView show];
          }
          else
          {
              [[KKMessageView sharedView] showHUDMessage:@"发生了一点点小问题,请稍后再试哦~"];
          }
        }];
    }
    else if (self.contentTextView.text.length == 0)
    {
        [[KKMessageView sharedView] showHUDMessage:@"请输入您的意见,我会认真查看的"];
    }
    else
    {
        return;

    }

}

#pragma mark - chooseview delegate
- (void)didClickButtonAtIndex:(NSUInteger)index
{
    if (index == 0)
    {
        [self.msView dismiss];
        [self dismissViewControllerAnimated:YES completion:nil];

    }
    else
    {
        [self.msView showInputLabelWithPlaceholder:@"请输入QQ、手机号 或者 邮箱 " AndTitle:@"我们会尽快给您反馈"];
        if (self.msView.infoTextfield.text.length > 0)
        {
            [self.msView dismiss];
            [self dismissViewControllerAnimated:YES completion:nil];
            [[KKMessageView sharedView] showHUDMessage:@"谢谢您的宝贵意见"];
        }

    }
}

- (IBAction)attachmentBtn:(UIButton *)sender {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        imagePickerController.delegate = self;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }


}




- (IBAction)cancelBtn:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - imagepicker
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *, id> *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    CGSize scaleFactor = (image.size.width > image.size.height) ? CGSizeMake(400, 400 * image.size.height / image.size.width) : CGSizeMake(400 * image.size.width / image.size.height, 400);
    self.uploadImage = [self imageWithImage:image scaledToSize:scaleFactor];
    [picker dismissViewControllerAnimated:YES completion:^{
      UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake (0, 0, 8, 8)];
      view1.backgroundColor = [UIColor colorWithRed:0.7 green:0.1 blue:0.1 alpha:1.0];
      view1.layer.cornerRadius = 4;
      [self.atBtn addSubview:view1];
      view1.center = CGPointMake ( 8, CGRectGetHeight (self.atBtn.frame)/2);
    }];
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)getTextfieldContent:(NSString *)string
{
}

-(void)cancelOp
{
    [self.msView dismiss];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
