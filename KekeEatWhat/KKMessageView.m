//
// Created by 凌空 on 16/1/7.
// Copyright (c) 2016 fharmony. All rights reserved.
//

#import "KKMessageView.h"

@interface KKMessageView ()

@end

@implementation KKMessageView
{

}

+ (instancetype)sharedView{
  static dispatch_once_t once_t;
  static KKMessageView *instance = nil;
  dispatch_once (&once_t, ^{
    instance = [[KKMessageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
  });
  return instance;
}

- (MBProgressHUD *)showHUDMessage:(NSString *)message
{
  [[UIApplication sharedApplication].keyWindow endEditing:YES];
  NSArray *windows = [UIApplication sharedApplication].windows;
  UIWindow *levelWindow = [UIApplication sharedApplication].keyWindow;
  for(UIWindow * window in windows)
  {
    if ([window isKindOfClass:NSClassFromString(@"UIRemoteKeyboardWindow")])
    {
      if(!window.hidden) levelWindow = window;
    }
  }
  return [self showHUDTips:message toView:levelWindow complete:nil];

}
- (MBProgressHUD *)showHUDTips:(NSString *)tips toView:(UIView *)toView complete:(void(^)())complete
{
  MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:toView animated:YES];
  [toView bringSubviewToFront:hud];
  hud.mode = MBProgressHUDModeText;
  hud.detailsLabelText = tips;
  hud.detailsLabelFont = [UIFont systemFontOfSize:16.0f];
  hud.margin = 25.0f;
  hud.removeFromSuperViewOnHide = YES;
  hud.completionBlock = complete;
  [hud hide:YES afterDelay:1.0];

  return hud;
}



@end