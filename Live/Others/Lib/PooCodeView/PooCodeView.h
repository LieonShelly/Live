//
//  PooCodeView.h
//  DuoSet
//
//  Created by fanfans on 2017/3/20.
//  Copyright © 2017年 Seven-Augus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PooCodeView : UIView

@property (nonatomic, retain) NSArray *changeArray;
@property (nonatomic, retain) NSMutableString *changeString;
@property (nonatomic, retain) UILabel *codeLabel;

-(void)changeCode;

@end
