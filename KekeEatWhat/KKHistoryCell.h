//
// Created by 凌空 on 16/1/6.
// Copyright (c) 2016 fharmony. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface KKHistoryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *cellBGView;
@property (weak, nonatomic) IBOutlet UIImageView *firstImgView;
@property (weak, nonatomic) IBOutlet UIImageView *secImgView;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImgView;
@property (weak, nonatomic) IBOutlet UIView *circleView;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIView *splitor;

@end