//
//  FFLoaddingView.m
//  DuoSet
//
//  Created by fanfans on 2017/6/13.
//  Copyright © 2017年 Seven-Augus. All rights reserved.
//

#import "FFLoaddingView.h"

@implementation FFLoaddingView

static FFLoaddingView *shareLoaddingView;

+(instancetype)shareLoaddingView{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (shareLoaddingView == nil) {
            shareLoaddingView = [[super alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
            NSMutableArray *imgs = [NSMutableArray array];
            for (int i = 1 ; i <= 12; i++) {
                UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"loadding_%d",i]];
                [imgs addObject:img];
            }
            shareLoaddingView.animationImages = imgs;
            shareLoaddingView.animationDuration = 0.4;
        }
    });
    return shareLoaddingView;
}

-(void)startAnimationLoadding{
    shareLoaddingView.hidden = false;
    [shareLoaddingView startAnimating];
}

-(void)endAnimationLoadding{
    shareLoaddingView.hidden = true;
    [shareLoaddingView startAnimating];
}

@end
