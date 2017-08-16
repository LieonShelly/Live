//
//  HUD.m
//  Live
//
//  Created by lieon on 2017/6/27.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

#import "HUD.h"
#import "FFLoaddingView.h"
#import "SVProgressHUD.h"

@implementation HUD
+(void)showHud:(BOOL)show showString:(NSString *)text enableUserActions:(BOOL)enableUserActions withViewController:(UIViewController *)controller{
    if (text.length == 0) {
        if (show) {
            if (enableUserActions) {
                [UIApplication sharedApplication].keyWindow.userInteractionEnabled = true;
                [[UIApplication sharedApplication].keyWindow addSubview:[FFLoaddingView shareLoaddingView]];
                [FFLoaddingView shareLoaddingView].center = [UIApplication sharedApplication].keyWindow.center;
                [[FFLoaddingView shareLoaddingView] startAnimationLoadding];
            }else{
                 [UIApplication sharedApplication].keyWindow.userInteractionEnabled = false;
                [controller.view addSubview:[FFLoaddingView shareLoaddingView]];
                [FFLoaddingView shareLoaddingView].center = controller.view.center;
                [[FFLoaddingView shareLoaddingView] startAnimationLoadding];
            }
        }else{
            [UIApplication sharedApplication].keyWindow.userInteractionEnabled = true;
            [[FFLoaddingView shareLoaddingView] endAnimationLoadding];
        }
    }else{
        if (show) {
            [SVProgressHUD setDefaultStyle:SVProgressHUDStyleLight];
            [SVProgressHUD setBackgroundColor:[UIColor blackColor]];
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeCustom];
            [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
            [SVProgressHUD showWithStatus:text];
        }else{
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                });
            });
        }
    }
}

+(void)showAlertFrom:(UIViewController *)controller title:(NSString *)title enterTitle: (NSString*)enterTitle mesaage:(NSString *)msg success:(void (^)())success{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:enterTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        success();
    }]];
    [controller presentViewController:alert animated:true completion:nil];
}

+(void)showAlertFrom:(UIViewController *)controller title:(NSString *)title mesaage:(NSString *)msg doneActionTitle:(NSString *)done handle:(void (^)())handle{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:done style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        handle();\
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [controller presentViewController:alert animated:true completion:nil];
    
}

+ (void)showAlertFrom:(UIViewController *)controller title:(NSString *)title enterTitle:(NSString *)enterTitle cancleTitle:(NSString *)cancleTitle mesaage:(NSString *)msg success:(void (^)())success failure:(void (^)())failure {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:enterTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        success();
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:cancleTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        failure();
    }]];
    [controller presentViewController:alert animated:true completion:nil];
}
@end
