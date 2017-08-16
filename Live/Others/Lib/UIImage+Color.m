//
//  UIImage+Color.m
//  BossApp
//
//  Created by fanfans on 5/4/16.
//  Copyright © 2016 ZDJY. All rights reserved.
//

#import "UIImage+Color.h"

@implementation UIImage (Color)

+(UIImage *)imageWithColor:(UIColor *)color{
    
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0);
    [color setFill];
    UIRectFill(rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+(UIImage *)placeholderImageWithSize:(CGSize)size{
    UIColor *backgroundColor = [self colorFromHex:0xf5f5f5];
    UIImage *image = [UIImage imageNamed:@"placeholderImage_clear"];
    CGFloat logoWH = (size.width > size.height ? size.height : size.width) * 0.5;
    CGSize logoSize = CGSizeMake(logoWH, logoWH);
    UIGraphicsBeginImageContextWithOptions(size,0, [UIScreen mainScreen].scale);
    [backgroundColor set];
    UIRectFill(CGRectMake(0,0, size.width, size.height));
    CGFloat imageX = (size.width / 2) - (logoSize.width / 2);
    CGFloat imageY = (size.height / 2) - (logoSize.height / 2);
    [image drawInRect:CGRectMake(imageX, imageY, logoSize.width, logoSize.height)];
    UIImage *resImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resImage;
}

+(UIColor *)colorFromHex:(UInt32)rgbValue{
    return [self colorFromHex:rgbValue alpha:1.0];
}

+(UIColor *)colorFromHex:(UInt32)rgbValue alpha:(float)alpha{
    
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0
                           green:((float)((rgbValue & 0xFF00) >> 8))/255.0
                            blue:((float)(rgbValue & 0xFF))/255.0 alpha:alpha];
}
@end
