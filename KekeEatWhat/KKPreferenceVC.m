//
// Created by 凌空 on 16/1/14.
// Copyright (c) 2016 fharmony. All rights reserved.
//

#import "KKPreferenceVC.h"
#import "KKColorManager.h"
#import "POP.h"
#import "KKUserModel.h"
#import "KKDataManager.h"
#import "AppDelegate.h"
#import "KKChooseView.h"
#import "CoreLocation/CLLocationManager.h"
#import "KKMessageView.h"

@interface KKPreferenceVC ()<KKChooseViewDelegate,CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *sexBtn;
@property (weak, nonatomic) IBOutlet UIButton *hotBtn;
@property (weak, nonatomic) IBOutlet UIButton *locationBtn;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property(nonatomic, weak) KKChooseView *chooseView;

@end


@implementation KKPreferenceVC
{

}
- (void)viewWillAppear:(BOOL)animated
{
  KKUserModel *userModel = [KKUserModel sharedUser].getUserModel;
  self.sexBtn.selected = !userModel.isMale;
  self.hotBtn.selected = !userModel.canEatHot;
  //用appdelegate的全局变量
  AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
  self.hotBtn.selected = !appDelegate.isGeoAuth;




}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  POPSpringAnimation *smallerAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
  smallerAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake (1, 1)];
  smallerAnimation.springBounciness = 16;
  smallerAnimation.springSpeed = 12;


  POPSpringAnimation *biggerAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
  biggerAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake (1.1, 1.1)];
  biggerAnimation.beginTime = CACurrentMediaTime () + 1.0;
  biggerAnimation.springBounciness = 16;
  biggerAnimation.springSpeed = 12;
  biggerAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
    [self.sexBtn.layer pop_addAnimation:smallerAnimation forKey:@"smaller"];
  };

  [self.sexBtn.layer pop_addAnimation:biggerAnimation forKey:@"bigger"];

}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.view.backgroundColor = [[KKColorManager sharedManager] getRandomNormalColor];
  [self.sexBtn addTarget:self action:@selector (animateMove:) forControlEvents:UIControlEventTouchUpInside];
  [self.hotBtn addTarget:self action:@selector (animateMove:) forControlEvents:UIControlEventTouchUpInside];
  [self.locationBtn addTarget:self action:@selector (animateMove:) forControlEvents:UIControlEventTouchUpInside];
  [self.backBtn addTarget:self action:@selector (backVC) forControlEvents:UIControlEventTouchUpInside];

}


- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  KKUserModel *userModel = [KKUserModel sharedUser];
  userModel.isMale = !self.sexBtn.selected;
  userModel.canEatHot = !self.hotBtn.selected;

  if (self.hotBtn.selected)
  {
    userModel.location = @"福建省";
  }
  else
  {

  }
  [[KKUserModel sharedUser] saveUserModel];
}

- (void)backVC
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)animateMove:(UIButton *)button{


    __weak KKPreferenceVC *wself = self;
    POPBasicAnimation *stageAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotationY];
    stageAnimation.toValue = @(0);
    stageAnimation.duration = 0.5;
    stageAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    stageAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
      if ([button isEqual:self.locationBtn])
      {

        if (((![CLLocationManager locationServicesEnabled]) ||
            ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted)
                || ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied))&&(!button.selected)){
          KKChooseView *chooseView = [[KKChooseView alloc] initWithTitle:@"定位功能没有打开!\n是否跳转到设置页面?" AndImage:nil success:@"确定" fail:@"取消"];
          wself.chooseView = chooseView;
          [chooseView show];
          chooseView.delegate = wself;
        }

      }
    };


    POPBasicAnimation *revertAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotationY];
    revertAnimation.toValue = @(M_PI/2-0.00001);
    revertAnimation.duration = 0.5;
    revertAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    revertAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
      button.selected = !button.isSelected;
      [button.layer pop_addAnimation:stageAnimation forKey:@"stage"];
    };
    [button.layer pop_addAnimation:revertAnimation forKey:@"fade"];
  }

- (BOOL)prefersStatusBarHidden
{
  return YES;
}


- (void)didClickButtonAtIndex:(NSUInteger)index
{
  [self.chooseView dismiss];
  [self dismissViewControllerAnimated:YES completion:nil];

  if (index == 1)
  {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]])
    {
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
    else
    {
      [[KKMessageView sharedView] showHUDMessage:@"请进入设置页面手动打开定位功能"];
    }
  }
}




@end