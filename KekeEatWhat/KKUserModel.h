//
// Created by 凌空 on 16/1/2.
// Copyright (c) 2016 fharmony. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface KKUserModel : NSObject
@property(nonatomic, assign) BOOL isMale;
@property(nonatomic, assign) BOOL canEatHot;
@property(nonatomic, copy) NSString *location;


+ (instancetype)sharedUser;

- (void)saveLocationInfo:(NSString *)provinceLocation;

- (void)saveUserModel;

- (KKUserModel *)getUserModel;
@end