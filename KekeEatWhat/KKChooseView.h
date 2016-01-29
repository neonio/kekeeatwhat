//
//  KKChooseView.h
//  KekeEatWhat
//
//  Created by 凌空 on 16/1/7.
//  Copyright © 2016年 fharmony. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol KKChooseViewDelegate<NSObject>
@optional
- (void)didClickButtonAtIndex:(NSUInteger)index;
- (void)getTextfieldContent:(NSString *)string;
- (void)cancelOp;
@end



@interface KKChooseView : UIView
@property (weak, nonatomic) IBOutlet UILabel *displayMsLabel;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property(nonatomic, weak) id <KKChooseViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *infoTextfield;

- (instancetype)initWithTitle:(NSString *)string AndImage:(UIImage *)image success:(NSString *)successText fail:(NSString *)failText;

-(instancetype)initWithTitle:(NSString *)string AndImage:(UIImage *)image ;

- (void)showInputLabelWithPlaceholder:(NSString *)placeholderStr AndTitle:(NSString *)title;

- (void)show;

- (void)dismiss;
@end
