//
//  FTSearchBar.m
//  FTPasswordManager
//
//  Created by fountain on 16/1/30.
//  Copyright © 2016年 com.fountain. All rights reserved.
//

#import "FTSearchBar.h"

@implementation FTSearchBar

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderWidth = 0.5;
       // self.layer.backgroundColor = [UIColor blackColor].CGColor;
       // self.backgroundColor = [UIColor clearColor];
        self.backgroundImage = [[UIImage alloc] init];
       // self.bgSearchImage = [UIImage imageNamed:@"search_frame"];
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    if (self.bgSearchImage) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextDrawImage(context, self.bounds, self.bgSearchImage.CGImage);
        CGContextStrokePath(context);
    }
}

- (void)hideKeyBoard {
    
    [self resignFirstResponder];
}

@end
