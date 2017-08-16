//
//  Utils.h
//  DuoSet
//
//  Created by fanfans on 12/27/16.
//  Copyright © 2016 Seven-Augus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>
#import <CoreLocation/CoreLocation.h>

@interface Utils : NSObject

+(NSString *)getCacheSize;

+(void)clearFile;

+(BOOL)isIncludeSpecialCharact: (NSString *)str;

+ (void)sharePlateType:(SSDKPlatformType)plateType ImageArray:(NSArray *)imgArray contentText:(NSString *)content shareURL:(NSString *)url shareTitle:(NSString *)title andViewController:(UIViewController *)controller success:(void(^)(SSDKPlatformType plateType))success;

+ (CLLocationCoordinate2D)BD09FromGCJ02:(CLLocationCoordinate2D)coor;

@end
