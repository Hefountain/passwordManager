//
//  FTImageSaver.m
//  FTPasswordManager
//
//  Created by fountain on 16/1/29.
//  Copyright © 2016年 com.fountain. All rights reserved.
//

#import "FTImageSaver.h"
#import "Password.h"
#import "PasswordDetails.h"

@implementation FTImageSaver

+ (BOOL)saveImageToDisk:(UIImage*)image andToPassword:(Password *)password {
    NSData *imgData   = UIImageJPEGRepresentation(image, 0.5);
    NSString *name    = [[NSUUID UUID] UUIDString];
    NSString *path	  = [NSString stringWithFormat:@"Documents/%@.jpg", name];
    NSString *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:path];
    
    if ([imgData writeToFile:jpgPath atomically:YES]) {
        password.passwordDetails.image = path;
    } else {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"There was an error saving your photo. Try again."
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles: nil] show];
        return NO;
    }
    return YES;
}

+ (void)deleteImageAtPath:(NSString *)path {
    NSError *error;
    NSString *imgToRemove = [NSHomeDirectory() stringByAppendingPathComponent:path];
    [[NSFileManager defaultManager] removeItemAtPath:imgToRemove error:&error];
}

@end
