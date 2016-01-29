//
//  KKLocationView.m
//  KekeEatWhat
//
//  Created by 凌空 on 16/1/5.
//  Copyright © 2016年 fharmony. All rights reserved.
//

#import "KKLocationView.h"
#import "KKFoodModel.h"
#import "KKDataManager.h"

@interface KKLocationView ()
@property (weak, nonatomic) IBOutlet UIImageView *foodIcon;
@property (weak, nonatomic) IBOutlet UILabel *foodNameLabel;
@property (weak, nonatomic) IBOutlet UIView *foodBGView;
@property (weak, nonatomic) IBOutlet UIView *outlineView;

- (IBAction)deleteBtn:(UIButton *)sender;

@end
@implementation KKLocationView


- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self)
  {


  }
  return self;
}



- (void)setupViewAppearance{
  self.outlineView.layer.cornerRadius = 16;
  self.outlineView.clipsToBounds = YES;
  self.foodBGView.backgroundColor = self.foodModel.bgColor;
  self.foodNameLabel.text = self.foodModel.foodName;

  self.foodIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_%d", self.foodModel.iconType]];
  self.foodIcon.contentMode = UIViewContentModeScaleAspectFill;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
  [self removeFromSuperview];
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//
//- (IBAction)deleteBtn:(UIButton *)sender
//{
//  [[KKDataManager sharedManager] deleteFoodModel:nil];
//
//}
@end
