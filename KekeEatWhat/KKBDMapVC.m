//
// Created by 凌空 on 16/1/11.
// Copyright (c) 2016 fharmony. All rights reserved.
//

#import <BaiduMapKit/BaiduMapAPI_Utils/BMKGeometry.h>
#import "KKBDMapVC.h"
#import "BMKRouteSearch.h"
#import "KKMessageView.h"
#import "BMKMapView.h"
#import "BMKMapComponent.h"
#import "BMKAnnotation.h"


@interface KKBDMapVC ()<BMKRouteSearchDelegate>
@property(nonatomic, strong) BMKRouteSearch *search;
@property(nonatomic, strong) BMKMapView *mapView;
@end

@implementation KKBDMapVC
{

}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.mapView = [[BMKMapView alloc] initWithFrame:self.view.frame];
  self.view = self.mapView;

  //
  UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  [backBtn addTarget:self action:@selector (dismissView) forControlEvents:UIControlEventTouchUpInside];
  backBtn.frame = CGRectMake (32, 32, 56, 56);
  [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
  backBtn.imageEdgeInsets = UIEdgeInsetsMake (12, 12, 12, 12);
  backBtn.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0.4];
  backBtn.layer.cornerRadius = 28;
  //设定聚焦区域
  BMKCoordinateRegion region = BMKCoordinateRegionMake (BMKCoordinateForMapPoint (self.pointB),BMKCoordinateSpanMake (0.02, 0.02));
  [self.mapView setRegion:region];

  [self.view addSubview:backBtn];

  self.search = [[BMKRouteSearch alloc] init];
  self.search.delegate = self;
  BMKPlanNode *end = [[BMKPlanNode alloc] init];
  end.pt = BMKCoordinateForMapPoint (self.pointA);
  BMKPlanNode *start = [[BMKPlanNode alloc] init];
  start.pt = BMKCoordinateForMapPoint (self.pointB);
  BMKWalkingRoutePlanOption *walkingRoutePlanOption = [[BMKWalkingRoutePlanOption alloc] init];
  walkingRoutePlanOption.from = start;
  walkingRoutePlanOption.to = end;
  BOOL flag = [self.search walkingSearch:walkingRoutePlanOption];
  if (!flag)
  {
    [[KKMessageView sharedView] showHUDMessage:@"暂时无法找到最佳路径"];
  }

}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  self.search.delegate = nil;
  self.search = nil;
}


-(void)dismissView
{
  self.search = nil;
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - delegate
- (void)onGetWalkingRouteResult:(BMKRouteSearch *)searcher result:(BMKWalkingRouteResult *)result errorCode:(BMKSearchErrorCode)error
{
  NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
  [_mapView removeAnnotations:array];
  array = [NSArray arrayWithArray:_mapView.overlays];
  [_mapView removeOverlays:array];
  if (error == BMK_SEARCH_NO_ERROR) {
    BMKWalkingRouteLine* plan = (BMKWalkingRouteLine*) result.routes[0];
    // 计算路线方案中的路段数目
    int size = [plan.steps count];
    int planPointCounts = 0;
    // 统计路径的时间和距离
    int distance = 0;
    int times = 0;

    // 画轨迹
    BMKMapPoint temppoints[5000];
    int j = 0; // 轨迹中点数量

    double minx = CGFLOAT_MAX;
    double miny = CGFLOAT_MAX;
    double maxx = CGFLOAT_MIN;
    double maxy = CGFLOAT_MIN;

    for (int i = 0; i < size; i ++) {
      BMKWalkingStep* walkingStep = plan.steps[i];
      if (i == 0) {
        BMKPointAnnotation *item = [[BMKPointAnnotation alloc]init];
        item.coordinate = plan.starting.location;
        item.title = @"起点";
        [_mapView addAnnotation:item]; // 添加起点标注

      } else if (i == size - 1) {
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        item.coordinate = plan.terminal.location;
        item.title = @"终点";
        [_mapView addAnnotation:item]; // 添加起点标注
      }
      //轨迹点总数累计
      planPointCounts += walkingStep.pointsCount;
      // 累加距离和时间
      distance += walkingStep.distance;
      times += walkingStep.duration;

      BMKWalkingStep* transitStep = plan.steps[i];

      for (int k = 0;k < transitStep.pointsCount; k ++) {
        temppoints[j].x = transitStep.points[k].x;
        temppoints[j].y = transitStep.points[k].y;

        // 计算地图要显示的区域
        if (temppoints[j].x < minx) {
          minx = temppoints[j].x;
        }
        if (temppoints[j].x > maxx) {
          maxx = temppoints[j].x;
        }
        if (temppoints[j].y < miny) {
          miny = temppoints[j].y;
        }
        if (temppoints[j].y > maxy) {
          maxy = temppoints[j].y;
        }

        j ++;
      }
    }
    // 更新界面ui
//    _distanceLabel.text = [NSString stringWithFormat:@"距离 : %d米",distance];
//    times = times / 60;
//    _timeLabel.text = [NSString stringWithFormat:@"估算时间 : %d分钟", times == 0 ? 1 : times];

    // 通过points构建BMKPolyline
    BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:j];
    [_mapView addOverlay:polyLine]; // 添加路线overlay

    [_mapView setVisibleMapRect:BMKMapRectMake(minx, miny, maxx - minx, maxy - miny) animated:YES];

  }
}


- (BOOL)prefersStatusBarHidden
{
  return YES;
}

@end