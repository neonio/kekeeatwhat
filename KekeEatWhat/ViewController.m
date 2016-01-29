//
//  ViewController.m
//  KekeEatWhat
//
//  Created by 凌空 on 16/1/2.
//  Copyright © 2016年 fharmony. All rights reserved.
//

#import "ViewController.h"
#import "KKColorManager.h"
#import "MJExtension.h"
#import "KKFoodModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  NSString     *foodModelFile = [[NSBundle mainBundle] pathForResource:@"Food" ofType:@"plist"];
  NSDictionary *foodModels    = [NSDictionary dictionaryWithContentsOfFile:foodModelFile];
  if (foodModels)
  {

    NSArray     *afternoonTeaFoods = [KKFoodModel mj_objectArrayWithKeyValuesArray:foodModels[@"Food"][0][@"afternoonTea"]];
    KKFoodModel *model             = afternoonTeaFoods[1];
    self.view.backgroundColor = model.bgColor;


  }
//  NSLog (@"%@", foodModels[@"Food"]);
//  NSArray *morningFoodModels =
//  NSLog (@"%d", arc4random () % normalColorArray.count);

    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
