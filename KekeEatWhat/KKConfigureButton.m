//
//  KKConfigureButton.m
//  KekeEatWhat
//
//  Created by 凌空 on 16/1/3.
//  Copyright © 2016年 fharmony. All rights reserved.
//

#import "KKConfigureButton.h"


@implementation KKConfigureButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
     Drawing code
}
*/

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self)
  {
    self.layer.cornerRadius = 16;
    self.layer.borderWidth = 2.0f;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    UILabel *titleLabel = [[UILabel alloc] init];
    switch (self.tag)
    {
      case 1:
      {
        titleLabel.text = @"偏好设置";
        break;
      }
      case 2:
      {
        titleLabel.text = @"历史选择";
        break;

      }
      case 3:
      {
        titleLabel.text = @"意见反馈";
        break;
      }
      case 4:
      {
        titleLabel.text = @"分享";
        break;
      }
      case 5:
      {

        titleLabel.text = @"关于我";
        break;
      }
      default:
        break;
    }
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];

  }
  return self;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  for (UIView *view in self.subviews)
  {
    if ([view isKindOfClass:[UILabel class]])
    {
      view.frame = CGRectMake (0, self.frame.size.height - 30, self.frame.size.width,24);
    }
  }
}

@end
