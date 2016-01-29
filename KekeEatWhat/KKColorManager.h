//
// Created by 凌空 on 16/1/2.
// Copyright (c) 2016 fharmony. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface KKColorManager : NSObject
+ (instancetype)sharedManager;

- (UIColor *)getRandomNormalColor;
@end