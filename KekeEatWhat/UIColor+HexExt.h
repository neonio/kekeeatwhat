//
// Created by 凌空 on 16/1/2.
// Copyright (c) 2016 fharmony. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexExt)
+ (UIColor *)colorWithHexString:(NSString *)rgb;

+ (NSArray *)colorComponent:(UIColor *)color;


+ (NSString *)colorHexStringFromUIColor:(UIColor *)color;

+ (NSArray *)hslarryColorMapper:(UIColor *)color;
@end