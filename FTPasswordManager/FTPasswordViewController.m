
//
//  FTPasswordViewController.m
//  FTPasswordManager
//
//  Created by fountain on 16/1/29.
//  Copyright © 2016年 com.fountain. All rights reserved.
//

#import "FTPasswordViewController.h"
#import "Password.h"
#import "PasswordDetails.h"
#import "FTImageSaver.h"


#define Property_Font 16
#define CATEGORY_PLACEHOLDER @"类型"

@interface FTPasswordViewController ()<UIScrollViewDelegate,UITextFieldDelegate,UITextViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIGestureRecognizerDelegate>
{
    UIScrollView *_scrollView;
    UILabel *hintLabel;
}

@end

@implementation FTPasswordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
   self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建一个Password实例
    if (!self.password) {
        self.password = [Password createEntity];
    }
    if (!self.password.passwordDetails) {
        self.password.passwordDetails = [PasswordDetails createEntity];
    }
    // 如果是新增密码状态，才显示
    if (self.isDelete && [self.isDelete isEqualToString:@"no"]) {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 25, 70, 30)];
        UIButton *operationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        operationBtn.frame = CGRectMake(0, 0, 50, 30);
        operationBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [operationBtn setTitle:@"取消" forState:UIControlStateNormal];
        [operationBtn addTarget:self action:@selector(cancelAdd) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:operationBtn];
        UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:view];
        self.navigationItem.leftBarButtonItem = barItem;
    
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 25, 70, 30)];
        operationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        operationBtn.frame = CGRectMake(20, 0, 50, 30);
        operationBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [operationBtn setTitle:@"保存" forState:UIControlStateNormal];
        [operationBtn addTarget:self action:@selector(addNewPassword) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:operationBtn];
        barItem = [[UIBarButtonItem alloc] initWithCustomView:view];
        self.navigationItem.rightBarButtonItem = barItem;
    }
    
    float x = 0;
    float y = 0;
    float width = SCREEN_WIDTH;
    float height = SCREEN_HEIGHT;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    _scrollView.delegate = self;
    
    // 图标
    _ptypeImgView = [[UIImageView alloc] initWithFrame:CGRectMake(x + 15, y + 8, 50, 50)];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(takePicture:)];
        tapGesture.delegate = self;
    _ptypeImgView.userInteractionEnabled = YES;
    _ptypeImgView.image = [UIImage imageNamed:@"bg_example_project_type_all@2x"];
    [_ptypeImgView addGestureRecognizer:tapGesture];
    [_scrollView addSubview:_ptypeImgView];
    
    //类型
    _pcategoryField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_ptypeImgView.frame) + 10, y + 15, SCREEN_WIDTH - CGRectGetWidth(_ptypeImgView.frame) - 15 , 35)];
    _pcategoryField.placeholder = CATEGORY_PLACEHOLDER;
    _pcategoryField.delegate = self;
    _pcategoryField.font = [UIFont systemFontOfSize:Property_Font];
    [_scrollView addSubview:_pcategoryField];
    
    // 分割线
    UIImageView *lineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(x, CGRectGetMaxY(_ptypeImgView.frame) + 8, SCREEN_WIDTH, 1)];
    lineImgView.image = [UIImage imageNamed:@"bg_index_horizontal_line@2x"];
    [_scrollView addSubview:lineImgView];

    // 标题
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_ptypeImgView.frame), CGRectGetMaxY(lineImgView.frame) + 7, 45, 35)];
    nameLabel.text = @"标题:";
    nameLabel.font = [UIFont systemFontOfSize:Property_Font];
    [_scrollView addSubview:nameLabel];
    
    _ptitleField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame), CGRectGetMinY(nameLabel.frame), SCREEN_WIDTH - CGRectGetWidth(nameLabel.frame), 35)];
    _ptitleField.delegate = self;
    _ptitleField.font = [UIFont systemFontOfSize:Property_Font];
    [_scrollView addSubview:_ptitleField];
    
    lineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(x, CGRectGetMaxY(_ptitleField.frame) + 8, SCREEN_WIDTH, 1)];
    lineImgView.image = [UIImage imageNamed:@"bg_index_horizontal_line@2x"];
    [_scrollView addSubview:lineImgView];

    // 账号
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_ptypeImgView.frame), CGRectGetMaxY(lineImgView.frame) + 7, 45, 35)];
    nameLabel.text = @"账号:";
    nameLabel.font = [UIFont systemFontOfSize:Property_Font];
    [_scrollView addSubview:nameLabel];
    
    _puserField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame), CGRectGetMinY(nameLabel.frame), SCREEN_WIDTH - CGRectGetWidth(nameLabel.frame), 35)];
    _puserField.delegate = self;
    _puserField.font = [UIFont systemFontOfSize:Property_Font];
    [_scrollView addSubview:_puserField];
    
    lineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(x, CGRectGetMaxY(_puserField.frame) + 8, SCREEN_WIDTH, 1)];
    lineImgView.image = [UIImage imageNamed:@"bg_index_horizontal_line@2x"];
    [_scrollView addSubview:lineImgView];

   // 密码
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_ptypeImgView.frame), CGRectGetMaxY(lineImgView.frame) + 7, 45, 35)];
    nameLabel.text = @"密码:";
    nameLabel.font = [UIFont systemFontOfSize:Property_Font];
    [_scrollView addSubview:nameLabel];
    
    _ppasswordField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame), CGRectGetMinY(nameLabel.frame), SCREEN_WIDTH - CGRectGetWidth(nameLabel.frame), 35)];
    _ppasswordField.delegate = self;
    _ppasswordField.font = [UIFont systemFontOfSize:Property_Font];
    [_scrollView addSubview:_ppasswordField];
    
    lineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(x, CGRectGetMaxY(_ppasswordField.frame) + 8, SCREEN_WIDTH, 1)];
    lineImgView.image = [UIImage imageNamed:@"bg_index_horizontal_line@2x"];
    [_scrollView addSubview:lineImgView];
    
    // 备注
    lineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 3.0, CGRectGetMaxY(_ppasswordField.frame) + 8, 1, 40)];
    lineImgView.image = [UIImage imageNamed:@"bg_index_vertical_line1x120@2x"];
    [_scrollView addSubview:lineImgView];

    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lineImgView.frame), CGRectGetMinY(lineImgView.frame), SCREEN_WIDTH/ 3.0, 40)];
    nameLabel.text = @" 备注 ";
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.font = [UIFont systemFontOfSize:Property_Font];
    [_scrollView addSubview:nameLabel];

    lineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame), CGRectGetMaxY(_ppasswordField.frame) + 8, 1, 40)];
    lineImgView.image = [UIImage imageNamed:@"bg_index_vertical_line1x120@2x"];
    [_scrollView addSubview:lineImgView];

    lineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(x, CGRectGetMaxY(lineImgView.frame), SCREEN_WIDTH, 1)];
    lineImgView.image = [UIImage imageNamed:@"bg_index_horizontal_line@2x"];
    [_scrollView addSubview:lineImgView];
    
    // 备注textView
    _pnotesTextView = [[UITextView alloc] initWithFrame:CGRectMake(x, CGRectGetMaxY(lineImgView.frame) + 5, SCREEN_WIDTH, 200)];
    _pnotesTextView.font = [UIFont systemFontOfSize:Property_Font];
    _pnotesTextView.delegate = self;
    [_scrollView addSubview:_pnotesTextView];
    
    if (!hintLabel) {
        hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(x + 3, CGRectGetMaxY(lineImgView.frame) + 8, SCREEN_WIDTH, 30)];
        hintLabel.text = @"请填写备注信息";
        hintLabel.textColor = [UIColor colorWithRed:207/255.0 green:207/255.0 blue:212/255.0 alpha:1.0];
        hintLabel.font = [UIFont systemFontOfSize:Property_Font];
    }
    
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, CGRectGetMinY(_pnotesTextView.frame) + 200);
    [self.view addSubview:_scrollView];
 
    if ([self.password.passwordDetails.image length] > 0) {
        NSData *imgData = [NSData dataWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:self.password.passwordDetails.image]];
        [self setImageForPassword:[UIImage imageWithData:imgData]];
    }
    self.pcategoryField.text = self.password.passwordDetails.type;
    self.ptitleField.text = self.password.title;
    self.puserField.text = self.password.passwordDetails.account;
    self.ppasswordField.text = self.password.passwordDetails.psd;
    self.pnotesTextView.text = self.password.passwordDetails.note;
}

// 选择图片
- (void)takePicture:(UITapGestureRecognizer*)sender {
    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:@"选择图片" message:@""preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
    }];
    
    UIAlertAction *photoLibraryAction = [UIAlertAction actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    
    [alertCtrl addAction:cancelAction];
    [alertCtrl addAction:takePhotoAction];
    [alertCtrl addAction:photoLibraryAction];
    [self presentViewController:alertCtrl animated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    if (self.password.passwordDetails.image) {
        [FTImageSaver deleteImageAtPath:self.password.passwordDetails.image];
    }
    if ([FTImageSaver saveImageToDisk:image andToPassword:self.password]) {
        [self setImageForPassword:image];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)setImageForPassword:(UIImage*)img {
    self.ptypeImgView.image = img;
    self.ptypeImgView.backgroundColor = [UIColor clearColor];
}


#pragma mark -viewWillappear & Disappear
- (void)viewWillAppear:(BOOL)animated {
    
    if ([_pnotesTextView.text isEqualToString:@""]) {
        
        [_scrollView addSubview:hintLabel];
           hintLabel.hidden = NO;
   
    } else {
        hintLabel.hidden = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self saveContext];
}

- (void)cancelAdd {
    if (!self.isDelete && [self.isDelete isEqualToString:@"no"]) {
        
        [self.password deleteEntity];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addNewPassword {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)saveContext {
    [[NSManagedObjectContext defaultContext] saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        if (success) {
            NSLog(@"成功保存");
        } else if (error) {
            NSLog(@"Error 保存信息：%@",error);
        }
    }];
}


#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([textField isEqual:self.pcategoryField]) {
        if ([textField.text isEqualToString:CATEGORY_PLACEHOLDER]) {
            textField.text = @"";
        }
    } else if ([textField isEqual:self.pcategoryField]) {
        if ([textField.text isEqualToString:CATEGORY_PLACEHOLDER]) {
            textField.text = @"";
        }
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if([textField isEqual:self.pcategoryField]) {
        if ([textField.text length] > 0) {
            self.password.passwordDetails.type = textField.text;
        }
    }
    
    if([textField isEqual:self.ptitleField]) {
        if ([textField.text length] > 0) {
            self.password.title = textField.text;
        }
    }
    
    if([textField isEqual:self.puserField]) {
        if ([textField.text length] > 0) {
            self.password.passwordDetails.account = textField.text;
        }
    }
    
    if([textField isEqual:self.ppasswordField]) {
        if ([textField.text length] > 0) {
            self.password.passwordDetails.psd = textField.text;
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSString *category = self.pcategoryField.text;
    
    if ([textField.placeholder isEqualToString:CATEGORY_PLACEHOLDER]) {
        if (!category || [category isEqualToString:@""] || [category isEqualToString:CATEGORY_PLACEHOLDER]) {
            [self.pcategoryField becomeFirstResponder];
            return YES;
        }
        [self.pcategoryField resignFirstResponder];
    }
    return YES;
}


#pragma mark -UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    
    hintLabel.hidden = YES;
    if ([textView.text length] <= 0) {
        hintLabel.hidden = NO;
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
    if ([textView.text length]) {
        self.password.passwordDetails.note = textView.text;
    }
    if ([textView.text length] <= 0) {
        hintLabel.hidden = NO;
    }
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

@end
