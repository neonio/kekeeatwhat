//
// Created by 凌空 on 16/1/2.
// Copyright (c) 2016 fharmony. All rights reserved.
//


#import "MJExtension.h"
#import "KKDataManager.h"
#import "KKConst.h"
#import "KKFoodModel.h"
#import "KKUserModel.h"
#import "KKMainSceneVC.h"
#import "KKLocationView.h"
#import "BMKUserLocation.h"
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>
#import <BaiduMapAPI_Search/BMKPoiSearch.h>
@interface KKDataManager ()<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKPoiSearchDelegate>
@property(nonatomic, strong) BMKLocationService *userLocationService;
@property(nonatomic, strong) BMKGeoCodeSearch *geoCodeSearch;
@property(nonatomic, strong) BMKPoiSearch *poiSearch;



@end
@implementation KKDataManager
{

}
- (BMKPoiSearch *)poiSearch
{

  if (self.isOpenLocationFunc)
  {
    if (_poiSearch)
    {
      _poiSearch.delegate = self;
    }
    else
    {
      _poiSearch = [[BMKPoiSearch alloc] init];
      _poiSearch.delegate = self;
    }
    return _poiSearch;
  }
  else
  {
    return nil;
  }
}

- (BMKGeoCodeSearch *)geoCodeSearch
{
  if (self.isOpenLocationFunc)
  {
    if (_geoCodeSearch)
    {
      _geoCodeSearch.delegate = self;
    }
    else
    {
      _geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    }
    return _geoCodeSearch;
  }
  else
  {
    return nil;
  }
}



- (BMKUserLocation *)userLocation
{
  if (!_userLocation)
  {
    _userLocation = [[BMKUserLocation alloc] init];
  }
  return _userLocation;
}

- (NSMutableArray *)locationDataArray
{
  if (!_locationDataArray)
  {
    _locationDataArray = [NSMutableArray array];
  }
  return _locationDataArray;
}

- (BMKLocationService *)userLocationService
{
  if (self.isOpenLocationFunc)
  {

    if (!_userLocationService)
    {
      _userLocationService = [[BMKLocationService alloc] init];
      _userLocationService.delegate = self;
      [_userLocationService startUserLocationService];
    }
    return _userLocationService;
  }
  else
  {
    return nil;
  }
}

+ (instancetype)sharedManager{
  static dispatch_once_t once_t;
  static KKDataManager *instance = nil;
  dispatch_once (&once_t, ^{
    instance = [[KKDataManager alloc] init];
    instance.isOpenLocationFunc = NO;

  });
  return instance;
}

- (NSUInteger)getCurrentTime{
  NSDate *currentDate = [NSDate date];
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  formatter.dateFormat = @"HH";
  NSString *hourStr = [formatter stringFromDate:currentDate];
  return (NSUInteger) hourStr.integerValue;
}

// 1:宵夜 2:早餐 3:午餐 4:晚餐 5:宵夜

- (NSUInteger)getTimeSection
{
  NSUInteger time = self.getCurrentTime;
  if (time < kBreakfastStartTime)
  {
//    宵夜
    return 5;
  }
  else if (time < kNoonStartTime)
  {
//    早餐
    return 1;
  }
  else if (time < kAfternoonTeaStartTime)
  {
//    午餐
    return 2;
  }
  else if (time < kSupperStartTime)
  {
//    下午茶
    return 3;
  }
  else if (time < kEveningStartTime)
  {
//    晚餐
    return 4;
  }
  else
  {
    return 5;
  }
}

- (NSArray *)getCurrentTimeFoodArray
{
  NSMutableArray *foodModelArray = [NSMutableArray array];
  NSString     *foodModelFile = [[NSBundle mainBundle] pathForResource:@"Food" ofType:@"plist"];
  if (foodModelFile)
  {
    NSDictionary *foodModels    = [NSDictionary dictionaryWithContentsOfFile:foodModelFile];
    NSUInteger time = [self getTimeSection];

    switch (time)
    {
      case 1:
      {
        foodModelArray = [KKFoodModel mj_objectArrayWithKeyValuesArray:foodModels[@"Food"][0][kBreakfast]];
        break;
      }
      case 2:
      {
        foodModelArray = [KKFoodModel mj_objectArrayWithKeyValuesArray:foodModels[@"Food"][0][kLunchsupper]];
        [foodModelArray addObjectsFromArray:self.decorateUserDefinedFood];
        break;
      }
      case 3:
      {
        foodModelArray = [KKFoodModel mj_objectArrayWithKeyValuesArray:foodModels[@"Food"][0][kAfternoonTea]];
        break;
      }
      case 5:
      {
        foodModelArray = [KKFoodModel mj_objectArrayWithKeyValuesArray:foodModels[@"Food"][0][kEvening]];
//        [foodModelArray arrayByAddingObjectsFromArray:self.decorateUserDefinedFood];
        break;
      }
      case 4:
      {
        foodModelArray = [KKFoodModel mj_objectArrayWithKeyValuesArray:foodModels[@"Food"][0][kLunchsupper]];
        [foodModelArray addObjectsFromArray:self.decorateUserDefinedFood];
        break;
      }
      default:
      {
        break;
      }

    }

  }
  return foodModelArray;
}
//用户定义的列表
- (NSArray *)decorateUserDefinedFood
{
  NSString *docFolder = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
  NSString *fileURL = [docFolder stringByAppendingPathComponent:kUserPlist];
  NSDictionary *userDefinedFood = [NSDictionary dictionaryWithContentsOfFile:fileURL];
  NSArray *userDefinedFoodArray = [KKFoodModel mj_objectArrayWithKeyValuesArray:userDefinedFood[kUserDefineFood]];
  return userDefinedFoodArray;
}

- (KKFoodModel *)chooseFoodModel
{

  //todo:should be reconstruct list
  BOOL canEatHot = [KKUserModel sharedUser].canEatHot;
  BOOL isMale = [KKUserModel sharedUser].isMale;
  NSString *locationStr = [KKUserModel sharedUser].location;
  NSString *location= [KKUserModel sharedUser].location;
  NSInteger locationPref = [self hotPref:locationStr];


  NSArray *foodList = self.getCurrentTimeFoodArray;
  NSUInteger sum = 0;
  for (KKFoodModel *foodModel in foodList)
  {
    //eat hot fix
//    if (foodModel.location!=0&&locationPref!=foodModel.location)
//    {
//      foodModel.rate -= 1;
//    }

    if (foodModel.isHot)
    {
      if (!canEatHot)
      {
        foodModel.rate -= 1;
      }
    }
    if ([self isFemailPref:foodModel] && (isMale))
    {
      foodModel.rate -= 1;
    }

    //is male fix

    sum += foodModel.rate;
  }
  NSInteger choosedIndex = arc4random () % sum;
  for (KKFoodModel *foodModel in foodList)
  {
    //eat hot fix
    if (foodModel.isHot)
    {
      if (!canEatHot)
      {
        foodModel.rate -= 1;
      }
    }
//    if (foodModel.location!=0&&locationPref!=foodModel.location)
//    {
//      foodModel.rate -= 1;
//    }

    if ([self isFemailPref:foodModel] && (isMale))
    {
      foodModel.rate -= 1;
    }

    choosedIndex -= foodModel.rate;
    if (choosedIndex < 0)
    {

      return foodModel;
    }

  }
  return foodList[(NSUInteger) choosedIndex];
}


- (void)removeFoodModelFromPlistWithModel:(KKFoodModel *)foodModel
{

}

- (BOOL)addFoodModelToFoodList:(KKFoodModel *)foodModel
{

  return NO;
}

- (void)getUserLocation
{
  if (self.userLocationService)
  {
    [self.userLocationService startUserLocationService];
  }
  else
  {
    self.userLocationService          = [[BMKLocationService alloc] init];
    self.userLocationService.delegate = self;
  }
}

- (void)getNearbyPOIByKeyword:(NSString *)keyword
{
  BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
  [self.userLocationService startUserLocationService];
  option.location = self.userLocation.location.coordinate;
  option.sortType = BMK_POI_SORT_BY_DISTANCE;
//  option.radius = 2000;
  option.pageCapacity = 8;
  option.keyword = keyword;

  BOOL flag = [self.poiSearch poiSearchNearBy:option];

}

//poi detail
- (void)getPOIDetailBy:(NSString *)puid{
    BMKPoiDetailSearchOption* option = [[BMKPoiDetailSearchOption alloc] init];
    option.poiUid = puid;
    BOOL flag = [self.poiSearch poiDetailSearch:option];
    if (flag) {
        //success
    }else{
        //fail
    }
}

#pragma mark - baidumapkit delegate

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{

  self.userLocation = userLocation;
  BMKReverseGeoCodeOption *reverseGeoCodeOption = [[BMKReverseGeoCodeOption alloc] init];
  reverseGeoCodeOption.reverseGeoPoint = userLocation.location.coordinate;
  BOOL isSuccess = [self.geoCodeSearch reverseGeoCode:reverseGeoCodeOption];
  [self.userLocationService stopUserLocationService];
}

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
  if (error == BMK_SEARCH_NO_ERROR)
  {

    [[KKUserModel sharedUser] saveLocationInfo:result.addressDetail.province];
  }

}

- (void)onGetPoiDetailResult:(BMKPoiSearch *)searcher result:(BMKPoiDetailResult *)poiDetailResult errorCode:(BMKSearchErrorCode)errorCode{
    if(errorCode == BMK_SEARCH_NO_ERROR){

//                 poiDetailResult.phoner
    }
}

- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult *)poiResult errorCode:(BMKSearchErrorCode)errorCode
{

  if (errorCode == BMK_SEARCH_NO_ERROR)
  {
    KKMainSceneVC *mainSceneVC = (KKMainSceneVC *) [UIApplication sharedApplication].keyWindow.rootViewController;
    mainSceneVC.infoDataList = [poiResult.poiInfoList mutableCopy];
      for (BMKPoiInfo *poiInfo in poiResult.poiInfoList) {
          [self getPOIDetailBy:poiInfo.uid];
//          [mainSceneVC.kkLocationView setDataBy:poiInfo.uid];
      }
    [mainSceneVC.kkLocationView.foodInfoTableView reloadData];
  }
  else if (errorCode == BMK_SEARCH_AMBIGUOUS_KEYWORD){
    //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
    // result.cityList;
  } else
  {
    KKMainSceneVC *mainSceneVC = (KKMainSceneVC *) [UIApplication sharedApplication].keyWindow.rootViewController;
    mainSceneVC.infoDataList = nil;
    [mainSceneVC.kkLocationView.foodInfoTableView reloadData];
  }

}

#pragma mark - history func



- (void)saveFoodListInSection:(NSDictionary *)dictionary
{
  NSFileManager   *fileManager   = [NSFileManager defaultManager];
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  dateFormatter.dateFormat = @"MMdd";
  NSString *tempFolder   = NSSearchPathForDirectoriesInDomains (NSLibraryDirectory, NSUserDomainMask, YES).lastObject;
  NSString *foodFilePath = [tempFolder stringByAppendingString:@"/info.plist"];
  NSString *theSection = [NSString stringWithFormat:@"%d", [dictionary[kTimeSection] integerValue]];
  NSMutableArray *chosenFoodList = [NSMutableArray array];
    for(KKFoodModel *model in dictionary[kChosenFood]){
      NSDictionary *singleModel = [model mj_keyValuesWithIgnoredKeys:@[@"bgColor"]];

        [chosenFoodList addObject:singleModel];
    }
    


  if ([fileManager fileExistsAtPath:foodFilePath])
  {
    NSMutableDictionary *fileDict = [NSMutableDictionary dictionaryWithContentsOfFile:foodFilePath];
    NSString *fileLastRecordDate = fileDict[@"today"][@"date"];

    if ([fileLastRecordDate isEqualToString:[dateFormatter stringFromDate:[NSDate date]]])
    {
      fileDict[@"today"][@"values"] = @{
          theSection:chosenFoodList
      };
    }
    else
    {
      fileDict[@"lastDay"] = fileDict[@"today"];
      fileDict[@"today"] = @{
          @"date": [dateFormatter stringFromDate:[NSDate date]],
          @"values": @{
              theSection:chosenFoodList
          }
      };
    }
    [fileDict writeToFile:foodFilePath atomically:YES];

  }
  else
  {
    NSDictionary *date = @{
        @"today": @{
            @"date": [dateFormatter stringFromDate:[NSDate date]],
            @"values": @{
                theSection :chosenFoodList
            }

        },
        @"lastDay":@{

        }
    };

      BOOL isSuccess = [date writeToFile:foodFilePath atomically:NO];

  }
}
- (NSDictionary *)getLastDayRecord{
  NSString *tempFolder   = NSSearchPathForDirectoriesInDomains (NSLibraryDirectory, NSUserDomainMask, YES).lastObject;
  NSString *foodFilePath = [tempFolder stringByAppendingString:@"/info.plist"];
  NSMutableDictionary *returnDic = [NSMutableDictionary dictionary];
  NSDictionary *dataDic = [NSDictionary dictionaryWithContentsOfFile:foodFilePath];
  NSFileManager *fileManager = [NSFileManager defaultManager];
  if ([fileManager fileExistsAtPath:foodFilePath])
  {
    if (dataDic.allKeys.count >= 1)
    {
      return dataDic;
    }
    else
    {
      return nil;
    }


  }
  else
  {
    return nil;
  }
}

//- (void)deleteFoodModel:(KKFoodModel *)foodModel{
//  NSString *tempFolder = [NSBundle mainBundle].resourcePath;
//  NSString *systemFilePath = [tempFolder stringByAppendingPathComponent:@"Food.plist"];
//  NSFileManager *fileManager = [NSFileManager defaultManager];
//  if ([fileManager fileExistsAtPath:systemFilePath])
//  {
//    NSDictionary *buildInDict = [NSMutableDictionary dictionaryWithContentsOfFile:systemFilePath];
//    NSArray *timeSection = buildInDict[@"Food"];
//    for (NSDictionary *dictionary in timeSection)
//    {
//      if (dictionary.allKeys.count > 0)
//      {
//        for (NSString *key in dictionary.allKeys)
//        {
//          NSArray *foodList = dictionary[key];
//          for (NSDictionary *eachFoodDict in foodList)
//          {
//            if ([eachFoodDict[@"name"] isEqualToString:foodModel.foodName])
//            {
//              eachFoodDict[@"rate"] = @(0);
//
//            }
//
//          }
//        }
//      }
//    }
//
//  }
//}

- (void)addFoodModel:(KKFoodModel *)foodModel{

  NSString *tempFolder = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
  NSString *userFilePath = [tempFolder stringByAppendingPathComponent:kUserPlist];
  NSFileManager *fileManager = [NSFileManager defaultManager];

  if ([fileManager fileExistsAtPath:userFilePath])
  {
    NSMutableDictionary *userDict = [NSMutableDictionary dictionaryWithContentsOfFile:userFilePath];
    NSMutableDictionary *foodDict = foodModel.mj_keyValues;
    foodDict[@"bgColor"] = nil;
    NSMutableArray *array = userDict[kUserDefineFood];
    [array addObject:foodDict];
    [userDict writeToFile:userFilePath atomically:NO];
  }
  else
  {
    NSMutableDictionary *userDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *foodDict = foodModel.mj_keyValues;
    foodDict[@"bgColor"] = nil;
    NSArray *array = @[foodDict];
    userDict[kUserDefineFood] = array;
    [userDict writeToFile:userFilePath atomically:NO];
  }


}



- (NSInteger)hotPref:(NSString *)locationName
{
  NSArray *eatHotProvince = @[@"贵州省", @"云南省", @"湖南省", @"广西省", @"湖北省", @"重庆市", @"吉林省", @"黑龙江省", @"辽宁省", @"江西省", @"四川省"];
  NSArray *notEatHotProvince = @[@"福建省",@"广东省",@"江苏省",@"上海市",@"安徽省",@"浙江省"];
  if ([eatHotProvince containsObject:locationName])
  {
    return 2;
  }
  else if ([notEatHotProvince containsObject:locationName])
  {
    return 1;
  }
  else
  {
    return 0;
  }

}

-(BOOL)isFemailPref:(KKFoodModel *)foodModel
{
//  奶茶 布丁 水果沙拉 沙拉 酸辣粉 麻辣烫 冒菜
  NSArray *array = @[@"奶茶", @"布丁", @"水果沙拉", @"沙拉", @"酸辣粉", @"麻辣烫", @"冒菜"];
  if ([array containsObject:foodModel.foodName])
  {
    return YES;
  }
  else
  {
    return NO;
  }

}




@end