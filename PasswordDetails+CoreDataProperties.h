//
//  PasswordDetails+CoreDataProperties.h
//  FTPasswordManager
//
//  Created by fountain on 16/1/26.
//  Copyright © 2016年 com.fountain. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "PasswordDetails.h"

NS_ASSUME_NONNULL_BEGIN

@interface PasswordDetails (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *type;  //类型
@property (nullable, nonatomic, retain) NSString *note;  // 备注
@property (nullable, nonatomic, retain) NSString *psd;  // 密码
@property (nullable, nonatomic, retain) NSString *account; // 账号
@property (nullable, nonatomic, retain) NSString *image;  // 图标
@property (nullable, nonatomic, retain) Password *password;  

@end

NS_ASSUME_NONNULL_END
