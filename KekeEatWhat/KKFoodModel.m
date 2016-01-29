//
// Created by 凌空 on 16/1/2.
// Copyright (c) 2016 fharmony. All rights reserved.
//

#import "KKFoodModel.h"
#import "MJExtension.h"
#import "UIColor+HexExt.h"
@implementation KKFoodModel
{

}
MJExtensionCodingImplementation
- (NSString *)description
{
  NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass ([self class])];
  [description appendFormat:@"self.foodName=%@", self.foodName];
  [description appendFormat:@", self.rate=%u", self.rate];
  [description appendFormat:@", self.backgroundColor=%@", self.backgroundColor];
  [description appendFormat:@", self.isHot=%d", self.isHot];
  [description appendFormat:@", self.location=%d", self.location];
  [description appendFormat:@", self.iconType=%u", self.iconType];
  [description appendFormat:@", self.bgColor=%@", self.bgColor];
  [description appendString:@">"];
  return description;
}


- (UIColor *)bgColor
{
  if (!_bgColor)
  {
    _bgColor = [UIColor colorWithHexString:_backgroundColor];
  }
  return _bgColor;
}

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
  return @{
      @"iconType" : @"icontype",
      @"foodName" : @"name"
  };
}


@end