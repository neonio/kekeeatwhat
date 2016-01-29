//
// Created by 凌空 on 16/1/5.
// Copyright (c) 2016 fharmony. All rights reserved.
//

#import "KKIconCell.h"

@interface KKIconCell ()

@end

@implementation KKIconCell
{

}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{

  self = [super initWithCoder:aDecoder];
  if (self)
  {
    self.cellBGView.layer.cornerRadius = 10;
    self.cellBGView.clipsToBounds = YES;

  }
  return self;
}




@end