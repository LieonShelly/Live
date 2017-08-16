//
//  UploadUtils.m
//  DuoSet
//
//  Created by fanfans on 2017/2/23.
//  Copyright © 2017年 Seven-Augus. All rights reserved.
//

#import "UploadUtils.h"
#import "UpYunFormUploader.h"
#import "UPYUNConfig.h"
#import "UpYun.h"
#import "UpyunCanfig.h"
#import "NSString+Date.h"

@implementation UploadUtils

+(void)upLoadMultimediaWithData:(NSData *)sourceData uploadReturnStr:(void (^)(NSString *uploadSuccessStr))uploadReturnStr success:(void (^)(NSString *mediaStr))success fail:(void (^)(NSString *errStr))fail  progress:(void(^)(NSString *progressStr))progress{
    NSString *upLoadimgUrl = [NSBundle mainBundle].infoDictionary[@"UpLoadimgUrl"];
    if (upLoadimgUrl.length == 0) {
        return;
    }
    UpYunFormUploader *up = [[UpYunFormUploader alloc] init];
    NSString *bucketName = upyunName;
    NSString *dateStr = [NSString dateFormToday];
    NSString *uuid = [self genRandomStringLenth:32];
    NSString *photoStr =  [NSString stringWithFormat:@"%@%@/%@.jpg",upLoadimgUrl,dateStr,uuid] ;
    
    NSString *uploadSuccessStr = [NSString stringWithFormat:@"%@/%@.jpg",dateStr,uuid];
    uploadReturnStr(uploadSuccessStr);
    
//    [RequestManager showHud:true showString:@"图片上传中" enableUserActions:true withViewController:nil];
    [up uploadWithBucketName:bucketName
                    operator:upyunId
                    password:upyunSecret
                    fileData:sourceData
                    fileName:nil
                     saveKey:photoStr
             otherParameters:nil
                     success:^(NSHTTPURLResponse *response,
                               NSDictionary *responseBody) {
                         NSLog(@"上传成功 responseBody：%@", responseBody);
                         NSString *str = [NSString stringWithFormat:@"%@",[responseBody objectForKey:@"url"]];
                         NSString *newStr = [str stringByReplacingOccurrencesOfString:upLoadimgUrl withString:@""];
                         success(newStr);
//                         [RequestManager showHud:false showString:@"图片上传中" enableUserActions:true withViewController:nil];
                     }
                     failure:^(NSError *error,
                               NSHTTPURLResponse *response,
                               NSDictionary *responseBody) {
//                         [RequestManager showHud:false showString:@"图片上传中" enableUserActions:true withViewController:nil];
                         NSLog(@"上传失败 error：%@", error);
                         NSLog(@"上传失败 responseBody：%@", responseBody);
                         NSLog(@"上传失败 message：%@", [responseBody objectForKey:@"message"]);
                         //主线程刷新ui
                         dispatch_async(dispatch_get_main_queue(), ^(){
                             NSString *message = [responseBody objectForKey:@"message"];
                             if (!message) {
                                 message = [NSString stringWithFormat:@"%@", error.localizedDescription];
                             }
                             fail(message);
                         });
                     }
     
                    progress:^(int64_t completedBytesCount,
                               int64_t totalBytesCount) {
                        NSString *progress = [NSString stringWithFormat:@"%lld / %lld", completedBytesCount, totalBytesCount];
                        NSString *progress_rate = [NSString stringWithFormat:@"upload %.1f %%", 100 * (float)completedBytesCount / totalBytesCount];
                        NSLog(@"upload progress: %@", progress);
                        NSLog(@"upload progress_rate: %@", progress_rate);
                        //主线程刷新ui
                        dispatch_async(dispatch_get_main_queue(), ^(){
                            //                            progress(progress_rate);
                        });
                    }];
}

+(void)upLoadMultimediaWithData:(NSData *)sourceData success:(void (^)(NSString *mediaStr))success fail:(void (^)(NSString *errStr))fail  progress:(void(^)(NSString *progressStr))progress{
    NSString *upLoadimgUrl = [NSBundle mainBundle].infoDictionary[@"UpLoadimgUrl"];
    if (upLoadimgUrl.length == 0) {
        return;
    }
    UpYunFormUploader *up = [[UpYunFormUploader alloc] init];
    NSString *bucketName = upyunName;
    NSString *dateStr = [NSString dateFormToday];
    NSString *uuid = [self genRandomStringLenth:32];
    NSString *photoStr =  [NSString stringWithFormat:@"%@%@/%@.jpg",upLoadimgUrl,dateStr,uuid] ;
//    [RequestManager showHud:true showString:@"图片上传中" enableUserActions:true withViewController:nil];
    [up uploadWithBucketName:bucketName
                    operator:upyunId
                    password:upyunSecret
                    fileData:sourceData
                    fileName:nil
                     saveKey:photoStr
             otherParameters:nil
                     success:^(NSHTTPURLResponse *response,
                               NSDictionary *responseBody) {
                         NSLog(@"上传成功 responseBody：%@", responseBody);
                         NSString *str = [NSString stringWithFormat:@"%@",[responseBody objectForKey:@"url"]];
                         NSString *newStr = [str stringByReplacingOccurrencesOfString:upLoadimgUrl withString:@""];
                         success(newStr);
//                         [RequestManager showHud:false showString:@"图片上传中" enableUserActions:true withViewController:nil];
                     }
                     failure:^(NSError *error,
                               NSHTTPURLResponse *response,
                               NSDictionary *responseBody) {
//                         [RequestManager showHud:false showString:@"图片上传中" enableUserActions:true withViewController:nil];
                         NSLog(@"上传失败 error：%@", error);
                         NSLog(@"上传失败 responseBody：%@", responseBody);
                         NSLog(@"上传失败 message：%@", [responseBody objectForKey:@"message"]);
                         //主线程刷新ui
                         dispatch_async(dispatch_get_main_queue(), ^(){
                             NSString *message = [responseBody objectForKey:@"message"];
                             if (!message) {
                                 message = [NSString stringWithFormat:@"%@", error.localizedDescription];
                             }
                             fail(message);
                         });
                     }
     
                    progress:^(int64_t completedBytesCount,
                               int64_t totalBytesCount) {
                        NSString *progress = [NSString stringWithFormat:@"%lld / %lld", completedBytesCount, totalBytesCount];
                        NSString *progress_rate = [NSString stringWithFormat:@"upload %.1f %%", 100 * (float)completedBytesCount / totalBytesCount];
                        NSLog(@"upload progress: %@", progress);
                        NSLog(@"upload progress_rate: %@", progress_rate);
                        //主线程刷新ui
                        dispatch_async(dispatch_get_main_queue(), ^(){
                            //                            progress(progress_rate);
                        });
                    }];
}

+(void)upLoadMultimediaWithDataArr:(NSArray *)sourceDataArr success:(void (^)(NSArray *mediaStrs))success fail:(void (^)(NSString *errStr))fail  progress:(void(^)(NSString *progressStr))progress{
    NSMutableArray *urlStrArr = [NSMutableArray array];
    NSMutableArray *uploadEndStrArr = [NSMutableArray array];
    for (NSData *data in sourceDataArr) {
        [self upLoadMultimediaWithData:data uploadReturnStr:^(NSString *uploadSuccessStr) {
            [urlStrArr addObject:uploadSuccessStr];
        } success:^(NSString *mediaStr) {
            [uploadEndStrArr addObject:mediaStr];
            if (uploadEndStrArr.count == sourceDataArr.count) {
                success(urlStrArr);
            }
        } fail:^(NSString *errStr) {
            //
        } progress:^(NSString *progressStr) {
            //
        }];
    }
}

+(NSString *)genRandomStringLenth:(NSInteger)length{
    NSString *allCharacters = @"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *randomString = [[NSMutableString alloc]initWithCapacity:length];
    for (int i = 0; i < length ; i++) {
        int len = (UInt32)allCharacters.length;
        int rand = arc4random_uniform(len) % len;
        [randomString appendFormat:@"%c",[allCharacters characterAtIndex:rand]];
    }
    return randomString;
}

@end
