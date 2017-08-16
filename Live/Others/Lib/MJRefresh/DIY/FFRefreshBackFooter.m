//
//  FFRefreshBackFooter.m
//  DuoSet
//
//  Created by fanfans on 2017/4/20.
//  Copyright © 2017年 Seven-Augus. All rights reserved.
//

#import "FFRefreshBackFooter.h"
#import "UIColor+colorFromHex.h"

@interface FFRefreshBackFooter()

@property(nonatomic,strong) UIButton *btn;

@end

@implementation FFRefreshBackFooter
#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = 50;
    // 添加label
    UIButton *btn = [[UIButton alloc] init];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [btn setTitleColor:[UIColor colorFromHex:0x222222] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"top_arrow"] forState:UIControlStateNormal];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [self addSubview:btn];
    self.btn = btn;
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    self.btn.frame = self.bounds;
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    switch (state) {
        case MJRefreshStateIdle:
            [self.btn setImage:[UIImage imageNamed:@"top_arrow"] forState:UIControlStateNormal];
            [self.btn setTitle:@"上拉查看商品更多详情" forState:UIControlStateNormal];
            break;
        case MJRefreshStatePulling:
            [self.btn setImage:[UIImage imageNamed:@"down_arrow"] forState:UIControlStateNormal];
            [self.btn setTitle:@"松开查看商品更多详情 " forState:UIControlStateNormal];
            break;
        case MJRefreshStateRefreshing:
            [self.btn setImage:[UIImage imageNamed:@"down_arrow"] forState:UIControlStateNormal];
            [self.btn setTitle:@"松开查看商品更多详情 " forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    
    // 1.0 0.5 0.0
    // 0.5 0.0 0.5
    //    CGFloat red = 1.0 - pullingPercent * 0.5;
    //    CGFloat green = 0.5 - 0.5 * pullingPercent;
    //    CGFloat blue = 0.5 * pullingPercent;
    //    self.label.textColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}
@end
