//
//  Utils.m
//  DuoSet
//
//  Created by fanfans on 12/27/16.
//  Copyright © 2016 Seven-Augus. All rights reserved.
//

#import "Utils.h"
#import "WeiboSDK.h"

@implementation Utils

+(NSString *)getCacheSize{
    NSString *size = @"";
    float cacheSize = [self readCacheSize] *1024;
    size = [NSString stringWithFormat:@"%.1fKB",cacheSize];
    if (cacheSize > 1024) {
        cacheSize = cacheSize / 1024;
        size = [NSString stringWithFormat:@"%.1fM",cacheSize];
    }
    return size;
}

+(float)readCacheSize{
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains (NSCachesDirectory , NSUserDomainMask , YES) firstObject];
    return [self folderSizeAtPath :cachePath];
}

+(float) folderSizeAtPath:( NSString *) folderPath{
    
    NSFileManager * manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath :folderPath]) return 0 ;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator];
    NSString * fileName;
    long long folderSize = 0 ;
    while ((fileName = [childFilesEnumerator nextObject]) != nil ){
        //获取文件全路径
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    
    return folderSize/( 1024.0 * 1024.0);
}

+(long long)fileSizeAtPath:( NSString *) filePath{
    NSFileManager * manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath :filePath]){
        return [[manager attributesOfItemAtPath :filePath error : nil] fileSize];
    }
    return 0;
}

+(void)clearFile{
    NSString * cachePath = [NSSearchPathForDirectoriesInDomains (NSCachesDirectory , NSUserDomainMask , YES ) firstObject];
    NSArray * files = [[NSFileManager defaultManager ] subpathsAtPath :cachePath];
    for ( NSString * p in files) {
        NSError * error = nil ;
        NSString * fileAbsolutePath = [cachePath stringByAppendingPathComponent :p];
        if ([[NSFileManager defaultManager ] fileExistsAtPath :fileAbsolutePath]) {
            [[NSFileManager defaultManager ] removeItemAtPath :fileAbsolutePath error :&error];
        }
    }
}

+(BOOL)isIncludeSpecialCharact: (NSString *)str{
    //***需要过滤的特殊字符：~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€。
    NSRange urgentRange = [str rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @"~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€"]];
    if (urgentRange.location == NSNotFound)
    {
        return NO;
    }
    return YES;
}

+ (void)sharePlateType:(SSDKPlatformType)plateType ImageArray:(NSArray *)imgArray contentText:(NSString *)content shareURL:(NSString *)url shareTitle:(NSString *)title andViewController:(UIViewController *)controller success:(void(^)(SSDKPlatformType plateType))success{
    if (plateType == SSDKPlatformSubTypeWechatSession || plateType == SSDKPlatformSubTypeWechatTimeline){//判断安装微信
        if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) {//没安装微信
            [self alertViewWithMessage:@"未安装微信客服端，暂时不能分享" with:controller];
            return;
        }
    }
    if (plateType == SSDKPlatformSubTypeQQFriend || plateType == SSDKPlatformSubTypeQZone) {//QQ
        if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {//没安装微信
            [self alertViewWithMessage:@"未安装QQ客服端，暂时不能分享" with:controller];
            return;
        }
    }
    if (plateType == SSDKPlatformTypeSinaWeibo) {//微博
        if (![WeiboSDK isWeiboAppInstalled]) {
            [self alertViewWithMessage:@"未安装微博客服端，暂时不能分享" with:controller];
            return;
        }
    }
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:content
                                     images:imgArray
                                        url:[NSURL URLWithString:url]
                                      title:title
                                       type:SSDKContentTypeAuto];
    [shareParams SSDKEnableUseClientShare];
    
    [ShareSDK share:plateType parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        switch (state) {
            case SSDKResponseStateBegin:
            {
                NSLog(@"开始");
                break;
            }
            case SSDKResponseStateSuccess:
            {
                success(plateType);
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                    message:nil
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                [alertView show];
                break;
            }
            case SSDKResponseStateFail:
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                    message:[NSString stringWithFormat:@"%@", error]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                [alertView show];
                break;
            }
            case SSDKResponseStateCancel:
            {
                NSLog(@"用户取消分享");
                break;
            }
            default:
                break;
        }
    }];
}

+(void)alertViewWithMessage:(NSString *)message with:(UIViewController *)controller{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    [controller presentViewController:alert animated:true completion:nil];
}

+ (CLLocationCoordinate2D)BD09FromGCJ02:(CLLocationCoordinate2D)coor{
    CLLocationDegrees x_pi = 3.14159265358979324 * 3000.0 / 180.0;
    CLLocationDegrees x = coor.longitude, y = coor.latitude;
    CLLocationDegrees z = sqrt(x * x + y * y) + 0.00002 * sin(y * x_pi);
    CLLocationDegrees theta = atan2(y, x) + 0.000003 * cos(x * x_pi);
    CLLocationDegrees bd_lon = z * cos(theta) + 0.0065;
    CLLocationDegrees bd_lat = z * sin(theta) + 0.006;
    return CLLocationCoordinate2DMake(bd_lat, bd_lon);
}

@end
