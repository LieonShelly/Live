//
//  UIColor+colorFromHex.h
//  BossApp
//
//  Created by fanfans on 5/4/16.
//  Copyright © 2016 ZDJY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (colorFromHex)

+ (UIColor *)colorWithHexString:(NSString *)color;
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;
+(UIColor*)colorFromHex:(UInt32)rgbValue;
+(UIColor*)colorFromHex:(UInt32)rgbValue alpha:(float)alpha;
+(UIColor*)mainColor;
+(UIColor*)randomColor;
@end
