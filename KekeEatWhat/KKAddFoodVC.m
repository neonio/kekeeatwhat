//
//  KKAddFoodVC.m
//  KekeEatWhat
//
//  Created by 凌空 on 16/1/3.
//  Copyright © 2016年 fharmony. All rights reserved.
//

#import "KKAddFoodVC.h"
#import "KKColorManager.h"
#import "KKFoodModel.h"
#import "UIColor+HexExt.h"
#import "KKDataManager.h"
#import "KKUserModel.h"
#import "KKAddIconCollectionVC.h"

static NSUInteger const yAxisOffset = 60;


@interface KKAddFoodVC ()<UITextFieldDelegate>

- (IBAction)cancelBtnClick:(UIButton *)sender;
- (IBAction)confirmBtnClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *foodIcon;
@property (weak, nonatomic) IBOutlet UITextField *foodNameTextfield;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@end

@implementation KKAddFoodVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBasicLayout];


    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.foodModel.iconType != 0)
    {
        [self.foodIcon setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"icon_%d", self.foodModel.iconType]] forState:UIControlStateNormal];
    }
}

- (void)setupBasicLayout
{

    self.view.backgroundColor       = [[KKColorManager sharedManager] getRandomNormalColor];
    self.foodNameTextfield.delegate = self;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector (dismissTextfield)];
    tapGestureRecognizer.numberOfTapsRequired    = 1;
    tapGestureRecognizer.numberOfTouchesRequired = 1;
    [self.scrollview addGestureRecognizer:tapGestureRecognizer];
    [self.foodIcon addTarget:self action:@selector (changeIcon) forControlEvents:UIControlEventTouchUpInside];

}

- (void)changeIcon
{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)cancelBtnClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)confirmBtnClick:(UIButton *)sender {

    KKFoodModel *foodModel = [[KKFoodModel alloc] init];
    foodModel.foodName = self.foodNameTextfield.text;
    foodModel.backgroundColor = [UIColor colorHexStringFromUIColor:[[KKColorManager sharedManager] getRandomNormalColor]];
    foodModel.location = [[KKDataManager sharedManager] hotPref:[KKUserModel sharedUser].location];
    foodModel.rate = 5;
    [[KKDataManager sharedManager] addFoodModel:foodModel];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dismissTextfield
{
//    self.scrollview.contentOffset = CGPointMake (0, 0);

    [self.scrollview setContentOffset:CGPointMake (0, 0) animated:YES];
    [self.view endEditing:YES];
}

#pragma mark - viewcontroller bev


- (void)viewWillDisappear:(BOOL)animated
{
    [self.view endEditing:YES];
}

#pragma mark - textfielddelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.scrollview setContentOffset:CGPointMake (0, yAxisOffset) animated:YES];
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self dismissTextfield];
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (KKFoodModel *)foodModel
{
    if (!_foodModel)
    {
        _foodModel = [[KKFoodModel alloc] init];
    }
    return _foodModel;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    KKAddIconCollectionVC *collectionVC = segue.destinationViewController;
    collectionVC.addFoodVC = self;
}

@end
