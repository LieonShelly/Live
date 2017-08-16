//
//  XYSwitch.h
//  XYSwitch
//
//  Created by DXY on 2017/5/25.
//  Copyright © 2017年 DXY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYSwitch : UIView

@property (nonatomic, strong) void (^changeStateBlock)(BOOL isOn);

@end
