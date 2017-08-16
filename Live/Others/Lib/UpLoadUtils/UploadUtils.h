//
//  UploadUtils.h
//  DuoSet
//
//  Created by fanfans on 2017/2/23.
//  Copyright © 2017年 Seven-Augus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UploadUtils : NSObject

//单张图片上传
+(void)upLoadMultimediaWithData:(NSData *)sourceData success:(void (^)(NSString *mediaStr))success fail:(void (^)(NSString *errStr))fail  progress:(void(^)(NSString *progressStr))progress;

//多张图片上传
+(void)upLoadMultimediaWithDataArr:(NSArray *)sourceDataArr success:(void (^)(NSArray *mediaStrs))success fail:(void (^)(NSString *errStr))fail  progress:(void(^)(NSString *progressStr))progress;

@end
