//
//  KKChooseView.m
//  KekeEatWhat
//
//  Created by 凌空 on 16/1/7.
//  Copyright © 2016年 fharmony. All rights reserved.
//

#import "KKChooseView.h"

@interface KKChooseView ()

@property(nonatomic, weak) UIControl *bgView;
@end
@implementation KKChooseView



- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self)
  {
    self.layer.cornerRadius = 10.0f;
    self.clipsToBounds = YES;
  }
  return self;
}
- (instancetype)initWithTitle:(NSString *)string AndImage :(UIImage *)image success:(NSString *)successText fail:(NSString *)failText
{
  if (self = [[NSBundle mainBundle] loadNibNamed:@"KKChooseView" owner:self.delegate options:nil].firstObject)
  {
    self.displayMsLabel.text = string;
    self.infoTextfield.alpha = 0;
    [self.confirmBtn setTitle:successText forState:UIControlStateNormal];
    [self.cancelBtn setTitle:failText forState:UIControlStateNormal];
    [self.confirmBtn addTarget:self action:@selector (clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelBtn addTarget:self action:@selector (clickButton:) forControlEvents:UIControlEventTouchUpInside];

  }
  return self;

}
- (instancetype)initWithTitle:(NSString *)string AndImage :(UIImage *)image
{
  self = [self initWithTitle:string AndImage:image success:nil fail:nil];
  return self;

}

- (void)showInputLabelWithPlaceholder:(NSString *)placeholderStr AndTitle:(NSString *)title
{
  self.displayMsLabel.text        = title;
  self.infoTextfield.placeholder  = placeholderStr;
  [self.confirmBtn addTarget:self.delegate action:@selector (getTextfieldContent:) forControlEvents:UIControlEventTouchUpInside];
  [self.cancelBtn addTarget:self.delegate action:@selector (cancelOp) forControlEvents:UIControlEventTouchUpInside];
  [UIView animateWithDuration:0.5 animations:^{
    self.infoTextfield.alpha = 1.0;
  }];

}

- (void)show
{
  UIView * keywindow = [[UIApplication sharedApplication] keyWindow];
  [keywindow addSubview:self];
  //添加dismiss功能
  UIControl *dismissControl = [[UIControl alloc] initWithFrame:keywindow.frame];
  [dismissControl addTarget:self action:@selector (dismiss) forControlEvents:UIControlEventTouchUpInside];
  dismissControl.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0.3];
  self.bgView = dismissControl;
  [keywindow insertSubview:dismissControl belowSubview:self];
  self.frame = CGRectMake (0,0,CGRectGetWidth (keywindow.frame)*0.8f, CGRectGetHeight (keywindow.frame)*0.36f);
  self.center = CGPointMake (keywindow.center.x, 0.75f * keywindow.center.y);

}

- (void)cancelOp{
  [self dismiss];
}

-(void)getTextfieldContent
{
  if ([self.delegate respondsToSelector:@selector (getTextfieldContent:)])
  {
    [self.delegate getTextfieldContent:self.infoTextfield.text];
  }
  [self dismiss];
}


-(void)clickButton:(UIButton *)button{
  if ([self.delegate respondsToSelector:@selector(didClickButtonAtIndex:)]) {
    [self.delegate didClickButtonAtIndex:(NSUInteger) (button.tag - 1)];
  }


}

- (void)dismiss
{
  [self.bgView removeFromSuperview];
  [self removeFromSuperview];
}

@end
