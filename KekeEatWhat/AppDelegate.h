//
//  AppDelegate.h
//  KekeEatWhat
//
//  Created by 凌空 on 16/1/2.
//  Copyright © 2016年 fharmony. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapKit/BaiduMapAPI_Base/BMKMapManager.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic, strong) BMKMapManager *mapManager;
@property(nonatomic, assign) BOOL isGeoAuth;
@end

