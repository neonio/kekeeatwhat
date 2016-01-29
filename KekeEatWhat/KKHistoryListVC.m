//
// Created by 凌空 on 16/1/6.
// Copyright (c) 2016 fharmony. All rights reserved.
//

#import <MJExtension/NSObject+MJKeyValue.h>
#import "KKHistoryListVC.h"
#import "KKHistoryCell.h"
#import "KKColorManager.h"
#import "KKDataManager.h"
#import "KKFoodModel.h"
#import "UIColor+HexExt.h"

static NSString *const cellID = @"historyCell";

@interface KKHistoryListVC ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation KKHistoryListVC
{

}

- (void)viewDidLoad
{

  [super viewDidLoad];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.view.backgroundColor = [UIColor colorWithHexString:@"#53555F"];
  self.tableView.separatorColor = [UIColor colorWithHue:0 saturation:0 brightness:0.8 alpha:1];
  UIControl *headerView = [[UIControl alloc] initWithFrame:CGRectMake (0, 0, CGRectGetWidth (self.view.frame), 120)];
  [headerView addTarget:self action:@selector (back) forControlEvents:UIControlEventTouchUpInside];
  headerView.backgroundColor = [UIColor colorWithHexString:@"#53555F"];
  UILabel *label = [[UILabel alloc] initWithFrame:headerView.frame];
  //


  label.text = [self getHistoryDate];
  label.textAlignment = NSTextAlignmentRight;
  label.font = [UIFont systemFontOfSize:24];
  label.textColor = [UIColor whiteColor];
  [headerView addSubview:label];
  [label sizeToFit];
  self.tableView.tableHeaderView = headerView;
  label.center = CGPointMake (headerView.center.x+24,headerView.center.y);
  UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
  [btn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
  btn.userInteractionEnabled = NO;
  btn.frame = CGRectMake (0, 0, 20, 20);
  btn.center = CGPointMake (32, headerView.center.y);
  [headerView addSubview:btn];

  //删除多余分割线
  UIView *view = [UIView new];
  view.backgroundColor = [UIColor clearColor];
  [self.tableView setTableFooterView:view];
}
//获取历史时间
- (NSString *)getHistoryDate
{
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  dateFormatter.dateFormat = @"yyyy";
  NSDate *curDate = [NSDate date];
  NSDictionary *recordDic = [NSDictionary dictionaryWithDictionary:[[KKDataManager sharedManager] getLastDayRecord]];
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSString *tempFolder   = NSSearchPathForDirectoriesInDomains (NSLibraryDirectory, NSUserDomainMask, YES).lastObject;
  NSString *foodFilePath = [tempFolder stringByAppendingString:@"/info.plist"];
  NSString *restoreDate = recordDic[@"lastDay"][@"date"];
  if ((![fileManager fileExistsAtPath:foodFilePath]) || restoreDate.length == 0)
  {
    return @"暂时没有记录哦~";

  }
  NSString *theDay = [NSString stringWithFormat:@"%@-%@", [dateFormatter stringFromDate:curDate], restoreDate];
  dateFormatter.dateFormat = @"yyyy-MMdd";
  curDate = [dateFormatter dateFromString:theDay];
  dateFormatter.dateFormat = @"yyyy.M.d  EEEE";
  return [dateFormatter stringFromDate:curDate];
}

#pragma mark - header bev
-(void)back
{
  [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - uitableviewdelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  KKHistoryCell *historyCell = [tableView dequeueReusableCellWithIdentifier:cellID];

  historyCell.circleView.backgroundColor = [KKColorManager sharedManager].getRandomNormalColor;
    NSDictionary *recordDic = [NSDictionary dictionaryWithDictionary:[[KKDataManager sharedManager] getLastDayRecord]];
  NSString *location = [NSString stringWithFormat:@"%d", indexPath.row+1];
  NSDictionary *foodDataValue = recordDic[@"lastDay"][@"values"];
  if ([foodDataValue.allKeys indexOfObject:@(indexPath.row)])
  {

    NSArray *sectionDataList = foodDataValue[location];
    if (sectionDataList.count > 0)
    {
      KKFoodModel *model = [KKFoodModel mj_objectWithKeyValues:sectionDataList[0]];
      historyCell.firstImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_%d", model.iconType]];
    }
    if (sectionDataList.count == 2)
    {
      KKFoodModel *model1 = [KKFoodModel mj_objectWithKeyValues:sectionDataList[1]];
      historyCell.secImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_%d", model1.iconType]];

    }
    else if (sectionDataList.count == 3)
    {
      KKFoodModel *model1 = [KKFoodModel mj_objectWithKeyValues:sectionDataList[1]];
      historyCell.secImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_%d", model1.iconType]];

      KKFoodModel *model2 = [KKFoodModel mj_objectWithKeyValues:sectionDataList[2]];
      historyCell.thirdImgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_%d", model2.iconType]];

    }


    switch (indexPath.row+1)

    {
      case 1:
      {
        historyCell.descLabel.text = @"早餐";
        break;
      }
      case 2:
      {
        historyCell.descLabel.text = @"午餐";
        break;
      }
      case 3:
      {
        historyCell.descLabel.text = @"下午茶";
        break;
      }case 4:
      {
        historyCell.descLabel.text = @"晚餐";
        break;
      }
      case 5:
      {
        historyCell.descLabel.text = @"宵夜";
        break;
      }
      default:
      {
        break;
      }



    }

    historyCell.descLabel.textColor = [UIColor colorWithHue:0 saturation:0 brightness:0.7 alpha:1.0];
    historyCell.splitor.layer.cornerRadius = 4.0;
    historyCell.splitor.backgroundColor = [KKColorManager sharedManager].getRandomNormalColor;
    return historyCell;
  }
  else
  {
    switch (indexPath.row+1)

    {
      case 1:
      {
        historyCell.descLabel.text = @"早餐";
        break;
      }
      case 2:
      {
        historyCell.descLabel.text = @"午餐";
        break;
      }
      case 3:
      {
        historyCell.descLabel.text = @"下午茶";
        break;
      }case 4:
      {
        historyCell.descLabel.text = @"晚餐";
        break;
      }
      case 5:
      {
        historyCell.descLabel.text = @"宵夜";
        break;
      }
      default:
      {
        break;
      }

  }
    historyCell.descLabel.textColor = [UIColor colorWithHue:0 saturation:0 brightness:0.7 alpha:1.0];
    historyCell.splitor.layer.cornerRadius = 4.0;
    historyCell.splitor.backgroundColor = [KKColorManager sharedManager].getRandomNormalColor;
    return historyCell;

  }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//  UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake (0, 0, CGRectGetWidth (self.view.frame), 120)];
//  contentView.backgroundColor = [UIColor purpleColor];
//  UILabel *titleLabel = [[UILabel alloc] init];
//  titleLabel.center = contentView.center;
//  titleLabel.
//  titleLabel.font = [UIFont systemFontOfSize:24];
//  titleLabel.textColor = [UIColor grayColor];
//
//  switch (section)
//  {
//    case 0:
//    {
//      titleLabel.text = @"早餐";
//      break;
//    }
//    case 1:
//    {
//      titleLabel.text = @"午餐";
//      break;
//    }
//    case 2:
//    {
//      titleLabel.text = @"下午茶";
//      break;
//    }
//    case 3:
//    {
//      titleLabel.text = @"晚餐";
//      break;
//    }
//    case 4:
//    {
//      titleLabel.text = @"宵夜";
//      break;
//    }
//    default:
//      break;
//  }
//  [titleLabel sizeToFit];
//  [contentView addSubview:titleLabel];
//  return contentView;
//}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)prefersStatusBarHidden
{
  return YES;
}



@end