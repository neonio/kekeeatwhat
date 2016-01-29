//
// Created by 凌空 on 16/1/2.
// Copyright (c) 2016 fharmony. All rights reserved.
//

#import "UIColor+HexExt.h"
#import "UIColor+Wonderful.h"

@implementation UIColor (HexExt)

+ (UIColor *)colorWithHexString:(NSString *)rgb{

  @autoreleasepool {
    NSString *plainNumber = [[rgb stringByReplacingOccurrencesOfString:@"#" withString:@""]
                                  stringByReplacingOccurrencesOfString:@"0x" withString:@""];

    if ([plainNumber length] == 3) {
      NSString *r = [plainNumber substringWithRange:NSMakeRange(0, 1)];
      NSString *g = [plainNumber substringWithRange:NSMakeRange(1, 1)];
      NSString *b = [plainNumber substringWithRange:NSMakeRange(2, 1)];
      plainNumber = [NSString stringWithFormat:@"%@%@%@%@%@%@",r,r,g,g,b,b];
    }

    if ([plainNumber length] == 6) {
      plainNumber = [plainNumber stringByAppendingString:@"ff"];
    }

    unsigned int hexValue;
    [[NSScanner scannerWithString:plainNumber] scanHexInt:&hexValue];

    float r = ((hexValue >> 24) & 0xFF) / 255.0f;
    float g = ((hexValue >> 16) & 0xFF) / 255.0f;
    float b = ((hexValue >> 8 ) & 0xFF) / 255.0f;
    float a = ((hexValue >> 0 ) & 0xFF) / 255.0f;

    return [UIColor colorWithRed:r green:g blue:b alpha:a];
  }
}

+ (NSArray *)colorComponent:(UIColor *)color
{
  NSMutableArray *colorArray      = [NSMutableArray array];
  CGColorRef     colorRef         = color.CGColor;
  NSInteger      numberComponents = (NSInteger) CGColorGetNumberOfComponents (colorRef);
  const CGFloat  *components      = CGColorGetComponents (colorRef);
  for (int       i                = 0; i < numberComponents; i++)
  {
    [colorArray addObject:@(components[i])];
  }
  return colorArray;
}

+ (NSInteger)colorComponentNumber:(UIColor *)color
{

  CGColorRef     colorRef         = color.CGColor;
  NSInteger      numberComponents = (NSInteger) CGColorGetNumberOfComponents (colorRef);
  return numberComponents;
}

+ (NSString *)colorHexStringFromUIColor:(UIColor *)color
{
  NSArray *array = [self colorComponent:color];
  float r = 1 - [array[0] floatValue];
  float g = 1 - [array[1] floatValue];
  float b = 1 - [array[2] floatValue];
  NSString *hex = [NSString stringWithFormat:@"#0x%x%x%x", (int) (r * 255), (int) (g * 255), (int)(b * 255) ];
  return hex;
}


+ (NSArray *)hslarryColorMapper:(UIColor *)color{
  NSArray *array = [self colorComponent:color];
  if (array.count != 4)
  {

    return @[@(0),@(0),array[0]];
  }
  else
  {
    float h = 0, s, v;

    float r,g,b;
    r                  = [array[0] floatValue];
    g                  = [array[1] floatValue];
    b                  = [array[2] floatValue];
    float maxJ = MAX (MAX (r, g), b);
    float minJ = MIN (MIN (r, g), b);
    float delta = maxJ - minJ;
    if (r == g && g == b)
    {
      h = 0;
      s = 0;
    }
    else
    {
      if (maxJ == r)
      {
        h = (g - b) / delta;
      }
      else if (maxJ == g)
      {
        h = 2 + (b - r) / delta;

      }
      else if (maxJ == b)
      {
        h = 4 + (r - g) / delta;
      }


      h *= 60;
      if (h < 0)
      {
        h += 360;
      }
      h = h/360;
      s = ((maxJ - minJ) / maxJ);
      v = maxJ;

      return @[@(h),@(s),@(v)];
    }


  }

  return nil;
}



@end