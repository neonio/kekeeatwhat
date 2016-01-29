//
// Created by 凌空 on 16/1/2.
// Copyright (c) 2016 fharmony. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KKFoodModel;
@class BMKUserLocation;


@interface KKDataManager : NSObject
@property(nonatomic, assign) BOOL isOpenLocationFunc;
@property(nonatomic, copy) NSMutableArray *locationDataArray;
@property(nonatomic, strong) BMKUserLocation *userLocation;
+ (instancetype)sharedManager;

- (NSUInteger)getCurrentTime;

- (NSUInteger)getTimeSection;

- (NSArray *)getCurrentTimeFoodArray;

- (KKFoodModel *)chooseFoodModel;

- (void)getUserLocation;

- (void)getNearbyPOIByKeyword:(NSString *)keyword;

- (void)saveFoodListInSection:(NSDictionary *)dictionary;

- (NSDictionary *)getLastDayRecord;

- (void)deleteFoodModel:(KKFoodModel *)foodModel;

- (void)addFoodModel:(KKFoodModel *)foodModel;

- (NSInteger)hotPref:(NSString *)locationName;
@end