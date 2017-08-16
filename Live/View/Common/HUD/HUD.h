//
//  HUD.h
//  Live
//
//  Created by lieon on 2017/6/27.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HUD : NSObject
+(void)showHud:(BOOL)show showString:(NSString *)text enableUserActions:(BOOL)enableUserActions withViewController:(UIViewController *)controller;
+(void)showAlertFrom:(UIViewController *)controller title:(NSString *)title enterTitle: (NSString*)enterTitle mesaage:(NSString *)msg success:(void (^)())success;
+(void)showAlertFrom:(UIViewController *)controller title:(NSString *)title mesaage:(NSString *)msg doneActionTitle:(NSString *)done handle:(void (^)())handle;

+(void)showAlertFrom:(UIViewController *)controller
               title:(NSString *)title
               enterTitle: (NSString*)enterTitle
               cancleTitle: (NSString*)cancleTitle
               mesaage:(NSString *)msg
               success:(void (^)())success
               failure:(void (^)())failure;

@end
