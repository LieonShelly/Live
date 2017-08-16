//
//  UIImage+Extension.h
//  Live
//
//  Created by lieon on 2017/8/3.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)
-(UIImage *)gsImagewithGsNumber:(CGFloat)blur;
-(UIImage*)scaleImageToSize:(CGSize)size;
-(UIImage *)clipImageInRect:(CGRect)rect;
@end
