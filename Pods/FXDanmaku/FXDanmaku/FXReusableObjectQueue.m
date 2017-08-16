//
//  FXReusableObjectQueue.m
//  FXDanmakuDemo
//
//  Created by ShawnFoo on 2016/12/28.
//  Copyright © 2016年 ShawnFoo. All rights reserved.
//

#import "FXReusableObjectQueue.h"

typedef NSMutableSet *FXSetOfReuseObject;
typedef NSMutableDictionary<NSString*, FXSetOfReuseObject> *FXDictionaryOfReuseObjectSet;
typedef NSMutableDictionary<NSString*, id> *FXDictionaryOfNibsOfClassNames;

@interface FXReusableObjectQueue ()

@property (nonatomic, assign) NSUInteger maxCountOfUnusedObjects;
@property (nonatomic, strong) FXDictionaryOfReuseObjectSet unusedObjectsSetDictionary;
@property (nonatomic, strong) FXDictionaryOfNibsOfClassNames registeredNibsOrClassNamesDictionary;

@end

@implementation FXReusableObjectQueue

#pragma mark - LazyLoading
- (FXDictionaryOfReuseObjectSet)unusedObjectsSetDictionary {
    if (!_unusedObjectsSetDictionary) {
        _unusedObjectsSetDictionary = [NSMutableDictionary dictionary];
    }
    return _unusedObjectsSetDictionary;
}

- (FXDictionaryOfNibsOfClassNames)registeredNibsOrClassNamesDictionary {
    if (!_registeredNibsOrClassNamesDictionary) {
        _registeredNibsOrClassNamesDictionary = [NSMutableDictionary dictionary];
    }
    return _registeredNibsOrClassNamesDictionary;
}

#pragma mark - Accessor
- (FXSetOfReuseObject)unusedObjectsSetWithIdentifier:(NSString *)identifier {
    FXSetOfReuseObject set = self.unusedObjectsSetDictionary[identifier];
    if (!set) {
        set = [NSMutableSet set];
        self.unusedObjectsSetDictionary[identifier] = set;
    }
    return set;
}

- (id<FXReusableObject>)newResusableObjectWithIdentifier:(NSString *)identifier {
    id nibOfClassName = self.registeredNibsOrClassNamesDictionary[identifier];
    if ([nibOfClassName isKindOfClass:[NSString class]]) {
        Class cls = NSClassFromString(nibOfClassName);
        if ([cls instancesRespondToSelector:@selector(initWithReuseIdentifier:)]) {
            return [[cls alloc] initWithReuseIdentifier:identifier];
        }
        return [[cls alloc] init];
    }
    else if ([nibOfClassName isKindOfClass:[UINib class]]) {
        return [(UINib *)nibOfClassName instantiateWithOwner:nil options:nil].firstObject;
    }
    return nil;
}

#pragma mark - LifeCycle
+ (instancetype)queue {
    return [self queueWithMaxCountOfUnusedObjects:0];
}

+ (instancetype)queueWithMaxCountOfUnusedObjects:(NSUInteger)maxCount {
    return [[self alloc] initWithMaxCountOfUnusedObjects:maxCount];
}

- (instancetype)initWithMaxCountOfUnusedObjects:(NSUInteger)maxCount {
    if (self = [super init]) {
        _maxCountOfUnusedObjects = maxCount > 0 ? maxCount : 20;
    }
    return self;
}

- (instancetype)init {
    return [self initWithMaxCountOfUnusedObjects:0];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Observer
- (void)setupObserver {
    __weak typeof(self) weakSelf = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidReceiveMemoryWarningNotification
                                                      object:self
                                                       queue:nil
                                                  usingBlock:^(NSNotification * _Nonnull note)
     {
         typeof(self) self = weakSelf;
         [self emptyUnusedObjects];
     }];
}

#pragma mark - Resubale Object Register
- (void)registerClass:(Class)cls forObjectReuseIdentifier:(NSString *)identifier {
    if (!identifier.length) {
        return;
    }
    if (!cls) {
        [self unregisterObjectResueWithIdentifier:identifier];
    }
    else {
        self.registeredNibsOrClassNamesDictionary[identifier] = NSStringFromClass(cls);
    }
}

- (void)registerNib:(UINib *)nib forObjectReuseIdentifier:(NSString *)identifier {
    if (!identifier.length) {
        return;
    }
    if (!nib) {
        [self unregisterObjectResueWithIdentifier:identifier];
    }
    else {
        self.registeredNibsOrClassNamesDictionary[identifier] = nib;
    }
}

- (void)unregisterObjectResueWithIdentifier:(NSString *)identifier {
    if (identifier.length) {
        [self.registeredNibsOrClassNamesDictionary removeObjectForKey:identifier];
    }
}

#pragma mark - Queue Operation
- (void)enqueueReusableObject:(id<FXReusableObject>)object {
    NSString *identifier = nil;
    if ([object respondsToSelector:@selector(reuseIdentifier)]
        && (identifier = [object reuseIdentifier])
        && identifier.length)
    {
        FXSetOfReuseObject set = self.unusedObjectsSetDictionary[identifier];
        if (set.count < self.maxCountOfUnusedObjects) {
            if ([object respondsToSelector:@selector(prepareForReuse)]) {
                [object prepareForReuse];
            }
            [set addObject:object];
        }
    }
}

- (id<FXReusableObject>)dequeueReusableObjectWithIdentifier:(NSString *)identifier {
    if (identifier) {
        FXSetOfReuseObject set = self.unusedObjectsSetDictionary[identifier];
        if (set.count) {
            id<FXReusableObject> object = [set anyObject];
            [set removeObject:object];
            return object;
        }
        else {
            return [self newResusableObjectWithIdentifier:identifier];
        }
    }
    return nil;
}

- (void)emptyUnusedObjects {
    [self.unusedObjectsSetDictionary removeAllObjects];
}

@end
