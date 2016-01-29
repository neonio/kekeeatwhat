//
//  KKSettingVC.m
//  KekeEatWhat
//
//  Created by 凌空 on 16/1/3.
//  Copyright © 2016年 fharmony. All rights reserved.
//

#import "KKSettingVC.h"
#import "KKColorManager.h"
#import "KKMessageView.h"
#import "KKChooseView.h"

static NSUInteger cellHeight = 80;


@interface KKSettingVC ()

@end

@implementation KKSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableviewBasicAppearence];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)setupTableviewBasicAppearence{
    self.view.backgroundColor = [KKColorManager sharedManager].getRandomNormalColor;
    UILabel *footerView = [[UILabel alloc] initWithFrame:CGRectMake (0, 0, CGRectGetWidth (self.view.frame), (CGFloat) (CGRectGetHeight (self.view.frame) - (CGRectGetHeight (self.view.frame)/6.0) * 5))];
    footerView.backgroundColor = [KKColorManager sharedManager].getRandomNormalColor;
    footerView.text = @"mail: fharmony@qq.com \n Copyright © 2016年 fharmony. \n All rights reserved." ;
    footerView.numberOfLines = 3;
    footerView.font = [UIFont systemFontOfSize:14];
    footerView.textAlignment = NSTextAlignmentCenter;
    footerView.textColor = [UIColor whiteColor];

    self.tableView.tableFooterView = footerView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (CGFloat) (CGRectGetHeight (self.view.frame)/6.0);
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row)
    {
        case 0:
        {

            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        }
        case 1:
        {
            [self configurePrefer];
            break;
        }
        case 2:
        {
            [self checkHistory];
            break;
        }
        case 3:
        {
            [self shareFoodMessage];
            break;
        }
        case 4:
        {
            [self feedbackMessage];
            break;
        }
        default:
            break;
    }
}

- (void)configurePrefer
{

}

- (void)checkHistory
{

}

- (void)shareFoodMessage
{

}

- (void)feedbackMessage
{

}
@end
