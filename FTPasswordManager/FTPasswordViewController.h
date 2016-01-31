//
//  FTPasswordViewController.h
//  FTPasswordManager
//
//  Created by fountain on 16/1/29.
//  Copyright © 2016年 com.fountain. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Password;

@interface FTPasswordViewController : UIViewController

@property (nonatomic, strong)UIImageView *ptypeImgView;
@property (nonatomic, strong)UITextField *pcategoryField;
@property (nonatomic, strong)UITextField *ptitleField;
@property (nonatomic, strong)UITextField *puserField;
@property (nonatomic, strong)UITextField *ppasswordField;
@property (nonatomic, strong)UITextView *pnotesTextView;

@property (nonatomic ,strong) Password *password;

@property (nonatomic, strong)NSString *isDelete;

//- (void)cancelAdd;
//- (void)addNewPassword;

@end
