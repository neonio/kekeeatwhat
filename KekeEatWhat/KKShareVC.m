//
// Created by 凌空 on 16/1/4.
// Copyright (c) 2016 fharmony. All rights reserved.
//

#import "KKShareVC.h"
#import "KKColorManager.h"
#import "KKConst.h"
#import "KKMessageView.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialSinaHandler.h"

#import "UMSocialQQHandler.h"
#import <UMengSocial/UMSocial.h>
#import <UMengSocial/UMSocialWechatHandler.h>
@interface KKShareVC ()<UMSocialUIDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *shareQRImgView;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

- (IBAction)shareBtnClick:(UIButton *)sender;


@end
@implementation KKShareVC
{

}

-(void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];

}
- (void)viewDidLoad
{

  [super viewDidLoad];
//  self.view.backgroundColor = [[KKColorManager sharedManager] getRandomNormalColor];
  self.shareQRImgView.layer.cornerRadius = 10;
  self.shareQRImgView.backgroundColor = [UIColor orangeColor];
  self.shareQRImgView.image = [self createNonInterpolatedUIImageFormCIImage:[self createQRForString:kAPPItunesURL] withSize:CGRectGetWidth (self.shareQRImgView.frame)];
  [self.backBtn addTarget:self action:@selector (backBtnClick) forControlEvents:UIControlEventTouchUpInside];
  [self bindSocialKey];
  [self handleSendProp];

}

-(void)backBtnClick
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)bindSocialKey
{
  [UMSocialWechatHandler setWXAppId:kWeChatAppID appSecret:kWeChatAppSecret url:kAPPItunesURL];
  [UMSocialSinaSSOHandler openNewSinaSSOWithRedirectURL:kSinaRedirectURL];
//  [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:kSinaAppID RedirectURL:kSinaRedirectURL];
  [UMSocialQQHandler setQQWithAppId:kQzoneAppID appKey:kQzoneAppSecret url:@"http://www.umeng.com/social"];
  [UMSocialQQHandler setSupportWebView:YES];

}

- (UIStatusBarStyle)preferredStatusBarStyle
{
  return UIStatusBarStyleLightContent;
}

- (void)handleSendProp{
  [UMSocialData defaultData].extConfig.qzoneData.url = kAPPItunesURL;
  [UMSocialData defaultData].extConfig.qzoneData.title = kShareTitle;
  [UMSocialData defaultData].extConfig.wechatSessionData.url = kAPPItunesURL;
  [UMSocialData defaultData].extConfig.wechatSessionData.title = kShareTitle;
  [UMSocialData defaultData].extConfig.wechatTimelineData.url = kAPPItunesURL;
  [UMSocialData defaultData].extConfig.wechatTimelineData.title = kShareTitle;
  [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeApp;


}

#pragma mark - UMShare
//
//- (void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
//{
//  if(response.responseCode == UMSResponseCodeSuccess){
//    NSLog (@"%@", @"OK");
//  }
//  else
//  {
//    NSLog (@"%@", @"NO");
//  }
//}


#pragma mark - QR

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size
{
  CGRect extent = CGRectIntegral(image.extent);
  CGFloat scale = MIN(size / CGRectGetWidth(extent), size / CGRectGetHeight(extent));
  // 创建bitmap;
  size_t width = (size_t)(CGRectGetWidth(extent) * scale);
  size_t height = (size_t)(CGRectGetHeight(extent) * scale);
  CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
  CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
  CIContext *context = [CIContext contextWithOptions:nil];
  CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
  CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
  CGContextScaleCTM(bitmapRef, scale, scale);
  CGContextDrawImage(bitmapRef, extent, bitmapImage);
  // 保存bitmap到图片
  CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
  CGContextRelease(bitmapRef);
  CGImageRelease(bitmapImage);
  return [UIImage imageWithCGImage:scaledImage];
}

- (CIImage *)createQRForString:(NSString *)qrString
{
  NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
  // 创建filter
  CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
  // 设置内容和纠错级别
  [qrFilter setValue:stringData forKey:@"inputMessage"];
  [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
  // 返回CIImage
  return qrFilter.outputImage;
}



- (IBAction)shareBtnClick:(UIButton *)sender
{
  switch (sender.tag)
  {
    case 0:
    {
      [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:kContent image:[UIImage imageNamed:kShareImg] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
        if (shareResponse.responseCode == UMSResponseCodeSuccess)
        {
          [[KKMessageView sharedView] showHUDMessage:@"分享成功"];
        }
        else
        {
          [[KKMessageView sharedView] showHUDMessage:@"您可以过一会儿再试试哦~~"];
        }
      }];
      break;
    }
    case 1:
    {
      [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:kContent image:[UIImage imageNamed:kShareImg] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess)
        {
          [[KKMessageView sharedView] showHUDMessage:@"分享成功"];
        }
        else
        {
          [[KKMessageView sharedView] showHUDMessage:@"您可以过一会儿再试试哦~~"];
        }
      }];
      break;
    }
    case 2:
    {
      [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:kContent image:[UIImage imageNamed:kShareImg] location:nil urlResource:nil
                                                                                                                                                   presentedController:self completion:^(
           UMSocialResponseEntity *response) {
         if (response.responseCode == UMSResponseCodeSuccess)
         {
           [[KKMessageView sharedView] showHUDMessage:@"分享成功"];
         }
         else
         {
           [[KKMessageView sharedView] showHUDMessage:@"您可以过一会儿再试试哦~~"];
         }
       }];
      break;
    }
    case 3:
    {
      [UMSocialData defaultData].extConfig.qzoneData.url = kAPPItunesURL;
      [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:kContent image:[UIImage imageNamed:kShareImg] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess)
        {
          [[KKMessageView sharedView] showHUDMessage:@"分享成功"];
        }
        else
        {
          [[KKMessageView sharedView] showHUDMessage:@"您可以过一会儿再试试哦~~"];
        }
      }];
      break;
    }
    default:
      break;
  }
}
@end