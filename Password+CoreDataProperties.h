//
//  Password+CoreDataProperties.h
//  FTPasswordManager
//
//  Created by fountain on 16/1/26.
//  Copyright © 2016年 com.fountain. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Password.h"

NS_ASSUME_NONNULL_BEGIN

@interface Password (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) PasswordDetails *passwordDetails;

@end

NS_ASSUME_NONNULL_END
