//
//  FFLoaddingView.h
//  DuoSet
//
//  Created by fanfans on 2017/6/13.
//  Copyright © 2017年 Seven-Augus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFLoaddingView : UIImageView

+(instancetype)shareLoaddingView;

-(void)startAnimationLoadding;

-(void)endAnimationLoadding;

@end
