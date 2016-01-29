//
// Created by 凌空 on 16/1/2.
// Copyright (c) 2016 fharmony. All rights reserved.
//

#import "KKMainSceneVC.h"
#import "KKFoodModel.h"
#import "MJExtension.h"
#import "KKDataManager.h"
#import "KKLocationView.h"
#import "BMKMapManager.h"
#import <BaiduMapKit/BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapKit/BaiduMapAPI_Search/BMKPoiSearch.h>
#import <BaiduMapKit/BaiduMapAPI_Utils/BMKGeometry.h>
#import "POP.h"
#import "KKConst.h"
#import "KKLocationView.h"
#import "BMKPoiSearchType.h"
#import "UIColor+HexExt.h"
#import "KKMessageView.h"
#import "BMKMapView.h"
#import "KKChooseView.h"
#import "KKBDMapVC.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "AFNetworkReachabilityManager.h"
//#import "LocationView.h"

@interface KKMainSceneVC ()<UITableViewDataSource,UITableViewDelegate,KKChooseViewDelegate>

- (IBAction)mainIconBtnClick:(UIButton *)sender;
- (IBAction)showFoodInfoView:(UIButton *)sender;



@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descIntroLocationY;
@property (weak, nonatomic) IBOutlet UIButton *mainIconBtn;
@property (weak, nonatomic) IBOutlet UILabel *iconNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectedItemLeft;
@property (weak, nonatomic) IBOutlet UIButton *selectedItemMid;
@property (weak, nonatomic) IBOutlet UIButton *selectedItemRight;
@property (weak, nonatomic) IBOutlet UIView *bottomSection;
@property(nonatomic, assign) NSUInteger currentIndex;
@property(nonatomic, assign) NSUInteger shakeTimes;
@property(nonatomic, strong) NSMutableDictionary *currentFoodList;
@property(nonatomic, strong) UIImageView *imgView ;
@property(nonatomic, assign) BOOL canShakeCell;
@property(nonatomic, weak) KKChooseView *chooseView;
@property(nonatomic, assign) NSUInteger canContinueShake;
@end

@implementation KKMainSceneVC
{

}

- (void)viewDidAppear:(BOOL)animated
{


  [super viewDidAppear:animated];
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  dateFormatter.dateFormat = @"MMdd";
  NSDictionary *dictionary = [[KKDataManager sharedManager] getLastDayRecord];


  if (![[dateFormatter stringFromDate:[NSDate date]] isEqualToString:dictionary[@"today"][@"date"]])
  {
    [self resetEverything];
  }
  if (![self.currentFoodList[kTimeSection] isEqualToNumber:@(-1)])
  {
    if (![self.currentFoodList[kTimeSection] isEqualToNumber:@([[KKDataManager sharedManager] getTimeSection])])
    {
      [self resetEverything];
    }
  }


//  [view1 show];

}

- (void)fromBG{

  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  dateFormatter.dateFormat = @"MMdd";
  NSDictionary *dictionary = [[KKDataManager sharedManager] getLastDayRecord];

  if (![dictionary[@"today"][@"date"] isEqualToString:[dateFormatter stringFromDate:[NSDate date]]])
  {
    NSString *tempFolder   = NSSearchPathForDirectoriesInDomains (NSLibraryDirectory, NSUserDomainMask, YES).lastObject;
    NSString *foodFilePath = [tempFolder stringByAppendingString:@"/info.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:foodFilePath])
    {
      NSMutableDictionary *fileDict = [NSMutableDictionary dictionaryWithContentsOfFile:foodFilePath];
      fileDict[@"lastDay"] = fileDict[@"today"];
      [fileDict writeToFile:foodFilePath atomically:YES];
    }
  }




  if (![[dateFormatter stringFromDate:[NSDate date]] isEqualToString:dictionary[@"today"][@"date"]])
  {
    [self resetEverything];
  }
  if (![self.currentFoodList[kTimeSection] isEqualToNumber:@(-1)])
  {
    if (![self.currentFoodList[kTimeSection] isEqualToNumber:@([[KKDataManager sharedManager] getTimeSection])])
    {
      [self resetEverything];
    }
  }
}

- (void)resetEverything
{

  self.currentFoodList = nil;
//  @property (weak, nonatomic) IBOutlet NSLayoutConstraint *descIntroLocationY;
  [self.mainIconBtn setBackgroundImage:[UIImage imageNamed:@"icon_0"] forState:UIControlStateNormal];
  for (UIView *view in self.bottomSection.subviews)
  {
    if ([view isKindOfClass:[UIImageView class]])
    {
      [view removeFromSuperview];
    }
  }
    [self setupFirstShot ];
  self.chooseView = nil;
  self.canContinueShake = YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
}


- (void)viewDidLoad
{
  [super viewDidLoad];
  self.currentIndex = 0;
  self.canContinueShake = YES;
  [self setupFirstShot];
  [[AFNetworkReachabilityManager sharedManager] startMonitoring];



}
-(void)canShake{
  [self becomeFirstResponder];
}

//初始化
-(void)setupFirstShot
{
  [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
  self.canShakeCell = YES;
  self.selectedItemLeft.alpha = 0;
  self.selectedItemMid.alpha = 0;
  self.selectedItemRight.alpha = 0;
  self.descIntroLocationY.constant = CGRectGetHeight (self.view.frame)/12;
  [self.iconNameLabel layoutIfNeeded];
  self.shakeTimes = 1;
  self.iconNameLabel.text = @"摇一摇~";

  //delete button
//  UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//  [deleteBtn setBackgroundImage:[UIImage imageNamed:@"deleteBtn"] forState:UIControlStateNormal];
//  deleteBtn.frame = CGRectMake (0, 0, 48, 48);
//  deleteBtn.layer.cornerRadius = CGRectGetWidth (deleteBtn.frame) / 2;
//  deleteBtn.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0.3];
//
//  self.
//  [self.mainIconBtn addTarget:self action:@selector (restoreFoodModel) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupFoodSelection
{
  self.canShakeCell = NO;

  POPBasicAnimation *opacityFadeAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
  opacityFadeAnimation.fromValue = @(0.2);
  opacityFadeAnimation.toValue = @(1);
//  opacityFadeAnimation.beginTime = CACurrentMediaTime () + 1.5;
  opacityFadeAnimation.duration = 3.0;

  POPBasicAnimation *opacityFadeOutAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
  opacityFadeAnimation.toValue = @(0);
  opacityFadeAnimation.duration = 0.3;



  self.mainIconBtn.enabled = NO;
  self.imgView.frame = CGRectMake (0, 0, 380, 380);
  self.imgView.center = self.mainIconBtn.center;
  [self.view addSubview:self.imgView];

  POPSpringAnimation *mainIconExpandeAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
  mainIconExpandeAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake (0, 0)];
  mainIconExpandeAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake (1, 1)];
  //注意一定要加CACurrentMediaTime哦
  if (self.shakeTimes==1)
  {
    mainIconExpandeAnimation.beginTime = CACurrentMediaTime()+2.4;
  }
  else
  {
    mainIconExpandeAnimation.beginTime = CACurrentMediaTime()+2.0;

  }
  mainIconExpandeAnimation.springBounciness = 20;
  mainIconExpandeAnimation.springSpeed = 110;
  mainIconExpandeAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {
    self.canShakeCell = YES;
    self.mainIconBtn.enabled = YES;
    [self.imgView stopAnimating];
  };

  POPSpringAnimation *mainIconAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
  mainIconAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake (1, 1)];
  mainIconAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake (0, 0)];
  mainIconAnimation.beginTime = CACurrentMediaTime ();
  mainIconAnimation.springBounciness = 10;
  mainIconAnimation.springSpeed = 110;


  mainIconAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished) {

    //设置名称动画
    self.iconNameLabel.alpha = 0;
    [UIView animateKeyframesWithDuration:0.4 delay:1.0 options:nil animations:^{
      self.iconNameLabel.alpha = 1.0;
    }completion:nil];


    [self.mainIconBtn pop_addAnimation:mainIconExpandeAnimation forKey:@"ExpandIcon"];

    //请求数据
    if (self.shakeTimes <= 4)
    {
      KKFoodModel *foodModel = [self requiredFoodModel];
      NSArray *array = self.currentFoodList[kChosenFood];
      [self restoreFoodModel:foodModel WithIndex:array.count];
      self.currentFoodList[kTimeSection] = @([[KKDataManager sharedManager] getTimeSection]);
      [[KKDataManager sharedManager] saveFoodListInSection:self.currentFoodList];
    }
    else
    {
      KKFoodModel *foodModel = [self requiredFoodModel];

    }

  };

  [self.mainIconBtn pop_addAnimation:mainIconAnimation forKey:@"StrinkIcon"];
  [self.imgView startAnimating];

  if (self.shakeTimes == 1)
  {
    POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewAlpha];
    springAnimation.springSpeed      = 10;
    springAnimation.springBounciness = 150;
    springAnimation.toValue          = @(1);
    springAnimation.completionBlock  = ^(POPAnimation *anim, BOOL finished) {
    };
    POPSpringAnimation *riseupAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    riseupAnimation.fromValue = @(self.selectedItemLeft.center.y + 40);
    riseupAnimation.toValue = @(self.selectedItemLeft.center.y+9.2);
    riseupAnimation.springBounciness = 60;
    riseupAnimation.springSpeed = 210;

    [self.selectedItemLeft pop_addAnimation:riseupAnimation forKey:@"riseup"];
    [self.selectedItemMid pop_addAnimation:riseupAnimation forKey:@"riseup"];
    [self.selectedItemRight pop_addAnimation:riseupAnimation forKey:@"riseup"];

    [self.selectedItemRight pop_addAnimation:springAnimation forKey:@"alphaChange"];
    [self.selectedItemMid pop_addAnimation:springAnimation forKey:@"alphaChange"];
    [self.selectedItemLeft pop_addAnimation:springAnimation forKey:@"alphaChange"];
    self.descIntroLocationY.constant = CGRectGetHeight (self.view.frame) / 24;
    [UIView animateWithDuration:1.0 animations:^{
      [self.iconNameLabel layoutIfNeeded];
    }];

  }

}

- (void)restoreFoodModel:(KKFoodModel *)foodModel WithIndex:(NSUInteger)index{
  UIImageView *foodImageView = [[UIImageView alloc] initWithFrame:CGRectMake (0, 0, (CGFloat) (CGRectGetWidth (self.selectedItemLeft.frame)*0.9), (CGFloat) (CGRectGetHeight (self.selectedItemLeft.frame)*0.9))];
  foodImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_%d",foodModel.iconType]];

  switch (index)
  {
    case 1:
    {
      foodImageView.center = CGPointMake (self.selectedItemLeft.center.x-2, self.selectedItemLeft.center.y+1);
      break;
    }
    case 2:
    {
      foodImageView.center = CGPointMake (self.selectedItemMid.center.x-1, self.selectedItemMid.center.y+1);
      break;
    }
    case 3:
    {
      foodImageView.center = CGPointMake (self.selectedItemRight.center.x, self.selectedItemRight.center.y+1);
      break;
    }
    default:
    {
      break;
    }
  }
  foodImageView.layer.opacity = 0;
  [self.bottomSection insertSubview:foodImageView belowSubview:self.selectedItemMid];

  POPBasicAnimation *opAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
  opAnimation.toValue = @(1);
  opAnimation.fromValue = @(0);
  opAnimation.duration = 1.6;
  opAnimation.beginTime = CACurrentMediaTime () + 2.4;
  [foodImageView.layer pop_addAnimation:opAnimation forKey:@"kPOPLayerOpacity"];


}

#pragma mark - shake logic


- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
  //todo:setshakesupport是否是设定过一次之后就无法修改
  if (self.canShakeCell)
  {
    [self currentLogic];
  }
}


- (void)currentLogic
{
  switch (self.shakeTimes)
  {
    case 1:
    {

      [self setupFoodSelection];
      self.shakeTimes += 1;
      break;
    }
    case 2:
    {

      [self setupFoodSelection];
      self.shakeTimes += 1;
      break;
    }
    case 3:
    {

      [self setupFoodSelection];
      self.shakeTimes += 1;
      break;
    }
    default:
    {

      if (self.canContinueShake)
      {
        KKChooseView *isShareView = [[KKChooseView alloc] initWithTitle:@"已经随机给您挑选了本时段的三种美味,继续摇动选出的美味将不会被记录哦~科科~" AndImage:nil success:@"继续" fail:@"放弃"];
        self.chooseView = isShareView;
        isShareView.delegate = self;
        [isShareView show];
        self.shakeTimes += 1;
      }
      else
      {
        [self setupFoodSelection];
        self.shakeTimes += 1;
      }
      break;
    }
  }
}

- (KKFoodModel *)requiredFoodModel
{

  NSUInteger currentTimeSection = [KKDataManager sharedManager].getTimeSection;
  if (![@(currentTimeSection) isEqualToNumber:self.currentFoodList[kTimeSection]])
  {
    NSMutableArray *array = self.currentFoodList[kChosenFood];
    KKFoodModel *foodModel = [[KKFoodModel alloc] init];
    foodModel = [[KKDataManager sharedManager] chooseFoodModel];
      if(foodModel)
      {
        foodModel = [[KKDataManager sharedManager] chooseFoodModel];
      }

    [self.mainIconBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"icon_%d", foodModel.iconType]] forState:UIControlStateNormal];
    self.iconNameLabel.text = foodModel.foodName;
    [UIView animateWithDuration:0.4 animations:^{
      self.view.backgroundColor = foodModel.bgColor;
    }];

    if (array.count <= 3)
    {
      [array addObject:foodModel];
    }

    self.currentFoodList[kTimeSection] = @(currentTimeSection);
    return foodModel;
  }
  else
  {
    NSMutableArray *array = self.currentFoodList[kChosenFood];
    KKFoodModel *foodModel = [[KKFoodModel alloc] init];
    foodModel = [[KKDataManager sharedManager] chooseFoodModel];
    if(foodModel)
    {
      foodModel = [[KKDataManager sharedManager] chooseFoodModel];
    }
    if(foodModel)
    {
      foodModel = [[KKDataManager sharedManager] chooseFoodModel];
    }
    if(foodModel)
    {
      foodModel = [[KKDataManager sharedManager] chooseFoodModel];
    }

    [self.mainIconBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"icon_%d", foodModel.iconType]] forState:UIControlStateNormal];
    self.iconNameLabel.text = foodModel.foodName;
    [UIView animateWithDuration:0.4 animations:^{
      self.view.backgroundColor = foodModel.bgColor;
    }];

    if (array.count <= 3)
    {
      [array addObject:foodModel];
    }
    return foodModel;
  }

}


- (IBAction)mainIconBtnClick:(UIButton *)sender {
  [self currentLogic];
}

- (IBAction)showFoodInfoView:(UIButton *)sender
{

  [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
    if (status==AFNetworkReachabilityStatusUnknown||status==AFNetworkReachabilityStatusNotReachable)
    {
      [[KKMessageView sharedView] showHUDMessage:@"与外界断开连接..."];
    }
  }];
  NSArray *currentFoodList = self.currentFoodList[kChosenFood];
  //刷新view页面,避免显示上一次的查询的信息
  self.infoDataList = nil;
  if (sender.tag < currentFoodList.count)
  {
    KKLocationView *kkLocationView = [[NSBundle mainBundle] loadNibNamed:@"Location" owner:self options:nil].lastObject;

    kkLocationView.frame                        = self.view.frame;
    kkLocationView.foodInfoTableView.dataSource = self;
    kkLocationView.foodInfoTableView.delegate   = self;

    switch (sender.tag)
    {
      case 0:
      {
        if (currentFoodList.count >= 1)
        {

          KKFoodModel *model = currentFoodList[0];
          [[KKDataManager sharedManager] getNearbyPOIByKeyword:model.foodName];
          kkLocationView.foodModel = model;
          [kkLocationView setupViewAppearance];
        }
        break;
      }
      case 1:
      {
        if (currentFoodList.count >= 2)
        {
          KKFoodModel *model       = currentFoodList[1];
          [[KKDataManager sharedManager] getNearbyPOIByKeyword:model.foodName];
          kkLocationView.foodModel = model;
          [kkLocationView setupViewAppearance];
        }
        break;
      }
      case 2:
      {
        if (currentFoodList.count == 3)
        {
          KKFoodModel *model       = currentFoodList[2];
          [[KKDataManager sharedManager] getNearbyPOIByKeyword:model.foodName];
          kkLocationView.foodModel = model;
          [kkLocationView setupViewAppearance];
        }
        break;
      }
      default:
      {
        break;
      }
    }
    self.kkLocationView                         = kkLocationView;
    [self.view addSubview:kkLocationView];
  }

}





- (UIImageView *)imgView
{
  if (!_imgView)
  {
    _imgView = [[UIImageView alloc] init];
    NSMutableArray *animateImgs = [NSMutableArray array];
    for (int i = 0; i <= 68; ++i)
    {
      UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"Ani_%d", i] ofType:@"png"]];
      [animateImgs addObject:image];
    }
    _imgView.animationImages = animateImgs;
    _imgView.animationRepeatCount = 1;
    _imgView.animationDuration = 2.6;
  }
  return _imgView;
}




- (NSMutableDictionary *)currentFoodList
{
  if (!_currentFoodList)
  {
    _currentFoodList = [NSMutableDictionary dictionary];
    _currentFoodList[kTimeSection] = @(-1);
    _currentFoodList[kChosenFood]  = [NSMutableArray array];
  }
  return _currentFoodList;
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
  return UIStatusBarStyleLightContent;
}

#pragma mark - locationInfodelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (self.infoDataList.count == 0)
  {
    return 0;
  }
  else
  {
    return 64;
  }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.infoDataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (self.infoDataList.count == 0)
  {
    return nil;
  }
  UITableViewCell *cell          = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"locationInfo"];
  BMKPoiInfo      *poiInfo       = (BMKPoiInfo *) (self.infoDataList[(NSUInteger) indexPath.row]);
  UILabel         *distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake (0, 0, 100, 40)];
  distanceLabel.center = CGPointMake (CGRectGetWidth (self.view.frame) - 60, cell.center.y + 10);
  BMKMapPoint        pointA = BMKMapPointForCoordinate (poiInfo.pt);
  BMKMapPoint        pointB = BMKMapPointForCoordinate ([KKDataManager sharedManager].userLocation.location.coordinate);
  CLLocationDistance dis    = BMKMetersBetweenMapPoints (pointA, pointB);
  distanceLabel.text      = [NSString stringWithFormat:@"%.2lfm", dis];
  distanceLabel.font      = [UIFont systemFontOfSize:12];
  distanceLabel.textColor = [UIColor colorWithHexString:@"#B2B2B2"];
  [cell.contentView addSubview:distanceLabel];
  cell.textLabel.text            = poiInfo.name;
  cell.textLabel.textColor       = [UIColor colorWithHexString:@"#3C3E3F"];
  cell.detailTextLabel.text      = [NSString stringWithFormat:@"Tel: %@", poiInfo.phone];
  cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"#B2B2B2"];
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  BMKPoiInfo *poiInfo = (BMKPoiInfo *) (self.infoDataList[(NSUInteger) indexPath.row]);
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
  KKBDMapVC *kkbdMapVC = [[KKBDMapVC alloc] init];
  BMKMapPoint pointA = BMKMapPointForCoordinate (poiInfo.pt);
  BMKMapPoint pointB = BMKMapPointForCoordinate ([KKDataManager sharedManager].userLocation.location.coordinate);
  kkbdMapVC.pointA = pointA;
  kkbdMapVC.pointB = pointB;
  [self presentViewController:kkbdMapVC animated:YES completion:nil];

}

#pragma mark - lazy load
- (NSMutableArray *)infoDataList
{
  if (!_infoDataList)
  {
    _infoDataList = [NSMutableArray array];

  }
  return _infoDataList;
}


#pragma mark - choosen food view
//是否能够继续摇动手机
- (void)didClickButtonAtIndex:(NSUInteger)index
{
  if (index == 0)
  {
    [self.chooseView dismiss];
  }
  else
  {
    self.canContinueShake = NO;
    [self.chooseView dismiss];
  }
}


- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  [self.imgView removeFromSuperview];
  self.imgView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(fromBG)
                                               name:UIApplicationDidBecomeActiveNotification object:nil];
}




- (void)dealloc{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}



@end