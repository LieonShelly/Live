//
//  CollectionViewHorizontalLayout.h
//  Live
//
//  Created by lieon on 2017/7/31.
//  Copyright © 2017年 ChengDuHuanLeHui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewHorizontalLayout : UICollectionViewFlowLayout
@property (nonatomic) NSUInteger itemCountPerRow;
// 一页显示多少行
@property (nonatomic) NSUInteger rowCount;
@property (strong, nonatomic) NSMutableArray *allAttributes;

@end
