//
// Created by 凌空 on 16/1/2.
// Copyright (c) 2016 fharmony. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSObject+MJCoding.h"


@interface KKFoodModel : NSObject

@property(nonatomic, copy) NSString *foodName;
@property(nonatomic, assign) NSUInteger rate;
@property(nonatomic, copy) NSString *backgroundColor;
@property(nonatomic, assign) BOOL isHot;
@property(nonatomic, assign) NSInteger location;
@property(nonatomic, assign) NSUInteger iconType;
@property(nonatomic, strong) UIColor *bgColor;

- (NSString *)description;

@end