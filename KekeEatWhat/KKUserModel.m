//
// Created by 凌空 on 16/1/2.
// Copyright (c) 2016 fharmony. All rights reserved.
//

#import "KKUserModel.h"
#import "KKConst.h"

@implementation KKUserModel
{

}
- (instancetype)init
{
  self = [super init];
  if (self)
  {
    self.canEatHot = YES;
    self.isMale = YES;
    self.location = @"福建省";
  }
  return self;
}


+ (instancetype)sharedUser{
  static dispatch_once_t once_t;
  static KKUserModel *userModel = nil;
  dispatch_once (&once_t, ^{
    userModel = [[KKUserModel alloc] init];
  });
  return userModel;
}

- (void)saveLocationInfo:(NSString *)provinceLocation{
  [[NSUserDefaults standardUserDefaults] setObject:provinceLocation forKey:@"userLocation"];
}

- (void)saveUserModel{
  NSDictionary *userModel = @{
      @"isMale" : @(self.isMale),
      @"location" : self.location,
      @"canEatHot":@(self.canEatHot)

  };
  NSString *documentFolder = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
  NSString *filePath = [documentFolder stringByAppendingPathComponent:kUserPlist];
  [userModel writeToFile:filePath atomically:NO];
}

- (KKUserModel *)getUserModel{
  NSString *documentFolder = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
  NSString *filePath = [documentFolder stringByAppendingPathComponent:kUserPlist];
  NSFileManager *fileManager = [NSFileManager defaultManager];
  if ([fileManager fileExistsAtPath:filePath])
  {
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:filePath];
    self.location = dictionary[@"location"];
    self.isMale = [dictionary[@"isMale"] boolValue];
    self.canEatHot = [dictionary[@"canEatHot"] boolValue];
    return self;
  }
  else
  {
    return self;
  }

}

@end