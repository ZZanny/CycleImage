//
//  ZZCollectionView.h
//  UICollectionView轮播图
//
//  Created by zan.zhang on 17/3/21.
//  Copyright © 2017年 zan.zhang  All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScrollCell.h"



#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height



typedef NS_ENUM(NSUInteger, CycleScrollViewIndicatorType) {
	CycleScrollViewIndicatorDotType = 0,
	CycleScrollViewIndicatorTextType = 1,
	
};




@interface ZZCollectionView : UIView
@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,strong)UICollectionView *collectionView;
//-(instancetype)initWithFrame:(CGRect)frame images:(NSArray *)showImage;
-(instancetype)initWithFrame:(CGRect)frame images:(NSArray *)sourceImages indicatorType:(CycleScrollViewIndicatorType )indicatorType;
@end
