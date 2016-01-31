//
//  FTImageSaver.h
//  FTPasswordManager
//
//  Created by fountain on 16/1/29.
//  Copyright © 2016年 com.fountain. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Password;

@interface FTImageSaver : NSObject

+ (BOOL)saveImageToDisk:(UIImage*)image andToPassword:(Password*)password;
+ (void)deleteImageAtPath:(NSString*)path;

@end

