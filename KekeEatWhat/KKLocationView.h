//
//  KKLocationView.h
//  KekeEatWhat
//
//  Created by 凌空 on 16/1/5.
//  Copyright © 2016年 fharmony. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KKFoodModel;

@interface KKLocationView : UIControl
@property (weak, nonatomic) IBOutlet UITableView *foodInfoTableView;
@property(nonatomic, strong) KKFoodModel *foodModel;

- (void)setupViewAppearance;

- (void)updateFoodLocationInfo:(NSArray *)infoList;
@end
