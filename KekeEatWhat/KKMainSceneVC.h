//
// Created by 凌空 on 16/1/2.
// Copyright (c) 2016 fharmony. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KKLocationView;
@class BMKMapManager;


@interface KKMainSceneVC : UIViewController
@property(nonatomic, strong) NSMutableArray *infoDataList;
@property(nonatomic, weak) KKLocationView *kkLocationView;


@end