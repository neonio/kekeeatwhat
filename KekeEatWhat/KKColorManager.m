//
// Created by 凌空 on 16/1/2.
// Copyright (c) 2016 fharmony. All rights reserved.
//

#import "KKColorManager.h"
#import "UIColor+HexExt.h"
static NSString *const kNormalColorKey = @"NormalColor";

@interface KKColorManager ()
@property(nonatomic, strong) NSDictionary *colorMapper;
@end

@implementation KKColorManager
{

}
- (NSDictionary *)colorMapper
{
  if (!_colorMapper)
  {
    //加载所有
    NSString *colorFilePath = [[NSBundle mainBundle] pathForResource:@"Color" ofType:@"plist"];
    _colorMapper = [NSDictionary dictionaryWithContentsOfFile:colorFilePath];
  }
  return _colorMapper;
}

+ (instancetype)sharedManager{
  static dispatch_once_t once_t;
  static KKColorManager *manager = nil;
  dispatch_once (&once_t, ^{
    manager = [[KKColorManager alloc] init];
  });
  return manager;
}

- (UIColor *)getRandomNormalColor
{

  NSArray *normalColors = self.colorMapper[kNormalColorKey];
  NSUInteger colorIndex = arc4random () % normalColors.count;
  if (
      [self.colorMapper[kNormalColorKey][colorIndex] isKindOfClass:[NSString class]])
  {
    return [UIColor colorWithHexString:self.colorMapper[kNormalColorKey][colorIndex]];
  }
  return nil;
}

@end