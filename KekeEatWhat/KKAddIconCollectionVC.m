//
//  KKAddIconCollectionViewController.m
//  KekeEatWhat
//
//  Created by 凌空 on 16/1/5.
//  Copyright © 2016年 fharmony. All rights reserved.
//

#import "KKAddIconCollectionVC.h"
#import "KKDataManager.h"
#import "KKIconCell.h"
#import "KKColorManager.h"
#import "UIColor+HexExt.h"
#import "KKAddFoodVC.h"
#import "KKAddFoodVC.h"
#import "KKFoodModel.h"

@interface KKAddIconCollectionVC () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property(nonatomic, copy) NSMutableArray *iconArray;

@end

@implementation KKAddIconCollectionVC

static NSString *const reuseIdentifier = @"Cell";

- (void)viewWillAppear:(BOOL)animated
{

  self.collectionView.dataSource = self;
  self.collectionView.delegate   = self;
  for (int i = 0; i < 28; ++i)
  {
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_%d", i]];
    [self.iconArray addObject:image];
  }

}


- (void)viewDidLoad
{
  [super viewDidLoad];
  self.collectionView.backgroundColor = [UIColor whiteColor];
  self.collectionView.contentOffset   = CGPointMake (0, -140);
  // Register cell classes
  [self.collectionView registerClass:[KKIconCell class] forCellWithReuseIdentifier:@"buildinCell"];
  [self.collectionView registerNib:[UINib nibWithNibName:@"IconCell" bundle:nil] forCellWithReuseIdentifier:@"buildinCell"];
  // Do any additional setup after loading the view.
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
  return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  return self.iconArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  KKIconCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"buildinCell" forIndexPath:indexPath];

  cell.cellImageView.image            = self.iconArray[(NSUInteger) indexPath.row];
  cell.contentView.layer.cornerRadius = 16;
  cell.contentView.clipsToBounds      = YES;
  cell.cellBGView.backgroundColor     = [KKColorManager sharedManager].getRandomNormalColor;


  return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
  [collectionView deselectItemAtIndexPath:indexPath animated:YES];
  self.addFoodVC.foodModel.iconType = (NSUInteger) indexPath.row;
  [self dismissViewControllerAnimated:YES completion:nil];

}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{

    return UIEdgeInsetsMake (5, 5, 5, 5);

}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
  CGSize cellSize = CGSizeMake (CGRectGetWidth (self.view.frame) / 2 - 10, CGRectGetWidth (self.view.frame) / 2 - 10);

  return cellSize;
}

- (NSMutableArray *)iconArray
{
  if (!_iconArray)
  {
    _iconArray = [NSMutableArray array];
  }
  return _iconArray;
}

- (BOOL)prefersStatusBarHidden
{
  return YES;
}


@end
