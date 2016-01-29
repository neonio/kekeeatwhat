//
// Created by 凌空 on 16/1/7.
// Copyright (c) 2016 fharmony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface KKMessageView : UIWindow

+ (instancetype)sharedView;

- (MBProgressHUD *)showHUDMessage:(NSString *)message;

- (MBProgressHUD *)showHUDTips:(NSString *)tips toView:(UIView *)toView complete:(void (^) ())complete;
@end