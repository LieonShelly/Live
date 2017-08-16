//
//  FXGCDOperationQueue.m
//  FXDanmakuDemo
//
//  Created by ShawnFoo on 2017/1/15.
//  Copyright © 2017年 ShawnFoo. All rights reserved.
//

#import "FXGCDOperationQueue.h"

#pragma mark - FXBlockOperation
@interface FXBlockOperation : NSObject

@property (nonatomic, copy) dispatch_block_t block;

- (void)cancel;

@end

@implementation FXBlockOperation

#pragma mark Factory
+ (instancetype)operationWithBlock:(dispatch_block_t)block {
    FXBlockOperation *operation = [[FXBlockOperation alloc] init];
    operation.block = block;
    return operation;
}

#pragma mark Operation
- (void)cancel {
    self.block = nil;
}

@end


#pragma mark - FXGCDOperationQueue
@interface FXGCDOperationQueue ()

@property (nonatomic, strong) NSHashTable<FXBlockOperation *> *operations;
@property (nonatomic, strong) dispatch_queue_t queue;

@end

@implementation FXGCDOperationQueue

#pragma mark Factory
+ (instancetype)queueWithDispatchQueue:(dispatch_queue_t)queue {
    FXGCDOperationQueue *opQueue = nil;
    if (queue) {
        opQueue = [[FXGCDOperationQueue alloc] init];
        opQueue.queue = queue;
        opQueue.operations = [NSHashTable weakObjectsHashTable];
    }
    return opQueue;
}

#pragma mark Operations
- (void)addSyncOperationBlock:(dispatch_block_t)block {
    [self addOperationBlock:block asynchronous:NO];
}

- (void)addAsyncOperationBlock:(dispatch_block_t)block {
    [self addOperationBlock:block asynchronous:YES];
}

- (void)addOperationBlock:(dispatch_block_t)block asynchronous:(BOOL)asynchronous {
    if (block) {
        __weak typeof(self) weakSelf = self;
        [self runBlockInMainThread:^{
            typeof(self) self = weakSelf;
            if (!self) {
                return;
            }
            FXBlockOperation *op = [FXBlockOperation operationWithBlock:block];
            dispatch_block_t opBlock = ^{
                dispatch_block_t cBlock = [op.block copy];
                if (cBlock) {
                    cBlock();
                }
            };
            if (asynchronous) {
                dispatch_async(self.queue, opBlock);
            }
            else {
                dispatch_sync(self.queue, opBlock);
            }
            
            [self.operations addObject:op];
        }];
    }
}

- (void)cancelAllOperation {
    __weak typeof(self) weakSelf = self;
    [self runBlockInMainThread:^{
        typeof(self) self = weakSelf;
        if (!self) {
            return;
        }
        for (FXBlockOperation *op in self.operations) {
            [op cancel];
        }
    }];
}

#pragma mark Util
- (void)runBlockInMainThread:(dispatch_block_t)block {
    if (block) {
        if ([NSThread isMainThread]) {
            block();
        }
        else {
            dispatch_async(dispatch_get_main_queue(), block);
        }
    }
}

@end
