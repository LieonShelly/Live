//
//  XYSwitch.m
//  XYSwitch
//
//  Created by DXY on 2017/5/25.
//  Copyright © 2017年 DXY. All rights reserved.
//

#import "XYSwitch.h"


@interface XYSwitch ()


@property(nonatomic,strong) UIView * btn;

@property(nonatomic,strong) UILabel * content;

@property(nonatomic,strong) UITapGestureRecognizer * tapGes;

@property(nonatomic,assign) BOOL isOn;


@end


@implementation XYSwitch

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isOn = NO;
        self.backgroundColor = [UIColor lightGrayColor];
        self.btn.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


- (void)layoutSubviews {
    [self prepareUI];
}

- (void)prepareUI {
    
    self.layer.cornerRadius = self.frame.size.height * 0.5;
    self.layer.masksToBounds = YES;
    
    
    [self addSubview:self.btn];
    
    [self.btn addSubview:self.content];
    
    [self frameSetup];
    
    
    [self addGestureRecognizer:self.tapGes];
    
}

- (void)frameSetup {
    
    
    
    self.backgroundColor = [UIColor lightGrayColor];
    CGFloat x,y,w,h;
    
    x = 2;
    y = 2;
    w = self.frame.size.height - 2 * 2;
    h = self.frame.size.height - 2 * 2;
    self.btn.frame = CGRectMake(x, y, w, h);
    
    self.btn.layer.cornerRadius = w / 2;
    self.btn.layer.masksToBounds = YES;
    
    x = 0;
    y = 0;
    self.content.frame = CGRectMake(x, y, w, h);
    
}


//关闭状态的UI
- (void)stateOff {
    
    self.backgroundColor = [UIColor colorWithRed:225./255. green:223./255. blue:223./255. alpha:1];
    
    self.content.textColor = [UIColor colorWithRed:225./255. green:223./255. blue:223./255. alpha:1];
    

    
    
    CGFloat x,y,w,h;
    
    x = 2;
    y = 2;
    w = self.frame.size.height - 2 * 2;
    h = self.frame.size.height - 2 * 2;
    self.btn.frame = CGRectMake(x, y, w, h);
    
    
    
}


//打开状态的UI
- (void)stateOn {
    self.backgroundColor = [UIColor colorWithRed:255/255.0 green:171/255.0 blue:51/255.0 alpha:1];
    
    self.content.textColor = [UIColor colorWithRed:255/255.0 green:171/255.0 blue:51/255.0 alpha:1];
    
    
    CGFloat x,y,w,h;
    
    
    x = self.frame.size.width - self.btn.frame.size.width - 2;
    y = 2;
    w = self.frame.size.height - 2 * 2;
    h = self.frame.size.height - 2 * 2;
    self.btn.frame = CGRectMake(x, y, w, h);
    
    
    
}


//改变开关状态
- (void)change {
    
    __weak XYSwitch * weakSelf = self;
    if (self.isOn) {
        //这里的非空判断自行完善,否则可能引起崩溃
        self.isOn = NO;

        self.changeStateBlock(self.isOn);
        [UIView animateWithDuration:0 animations:^{
            [weakSelf stateOff];
        }];

        
        
    }else{
        
        self.isOn = YES;
        
        self.changeStateBlock(self.isOn);
        [UIView animateWithDuration:0 animations:^{
            [weakSelf stateOn];
        }];

        
    }
    NSLog(@"SwitchisOn:%d",self.isOn);
    
    
}



#pragma mark - 懒加载

- (UILabel *)content{
    if (!_content){
        _content = [[UILabel alloc] init];
        _content.text = @"弹幕";
        _content.font = [UIFont systemFontOfSize:9];
        _content.textColor = [UIColor colorWithRed:225./255. green:223./255. blue:223./255. alpha:1];
        _content.textAlignment = NSTextAlignmentCenter;
        [_content sizeToFit];
    }
    return _content;
}

- (UIView *)btn{
    if (!_btn){
        _btn = [[UIView alloc] init];
        
    }
    
    return _btn;
}


- (UITapGestureRecognizer *)tapGes{
    if (!_tapGes){
        _tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(change)];
    }
    return _tapGes;
}

@end
