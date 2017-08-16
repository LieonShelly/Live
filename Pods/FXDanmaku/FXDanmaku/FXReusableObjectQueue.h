//
//  FXReusableObjectQueue.h
//  FXDanmakuDemo
//
//  Created by ShawnFoo on 2016/12/28.
//  Copyright © 2016年 ShawnFoo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FXReusableObject <NSObject>

@optional
- (instancetype)initWithReuseIdentifier:(nullable NSString *)identifier;
- (NSString *)reuseIdentifier;
- (void)prepareForReuse;

@end

@interface FXReusableObjectQueue : NSObject

+ (instancetype)queue;
+ (instancetype)queueWithMaxCountOfUnusedObjects:(NSUInteger)maxCount;
- (instancetype)initWithMaxCountOfUnusedObjects:(NSUInteger)maxCount NS_DESIGNATED_INITIALIZER;

#pragma mark - Resubale Object Register
- (void)registerClass:(nullable Class)cls forObjectReuseIdentifier:(NSString *)identifier;
- (void)registerNib:(nullable UINib *)nib forObjectReuseIdentifier:(NSString *)identifier;
- (void)unregisterObjectResueWithIdentifier:(NSString *)identifier;

#pragma mark - Queue Operation
- (void)enqueueReusableObject:(nullable id<FXReusableObject>)object;
- (nullable id<FXReusableObject>)dequeueReusableObjectWithIdentifier:(NSString *)identifier;
- (void)emptyUnusedObjects;

@end

NS_ASSUME_NONNULL_END
