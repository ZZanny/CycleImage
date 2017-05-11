//
//  ZZCollectionView.m
//  UICollectionView轮播图
//
//  Created by zan.zhang on 17/3/21.
//  Copyright © 2017年 zan.zhang  All rights reserved.
//

#import "ZZCollectionView.h"
#import <UIImageView+WebCache.h>

#define ZZWidth self.frame.size.width
#define ZZHeight self.frame.size.height

@interface ZZCollectionView ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong)NSArray *sourceImages;/** 源图像数组*/
@property (nonatomic,strong)NSMutableArray *showImages;/** 展示图像所需数组*/
@property (nonatomic,assign)NSInteger leftIndex;
@property (nonatomic,assign)NSInteger middleIndex;
@property (nonatomic,assign)NSInteger rightIndex;
@property (nonatomic,strong)UICollectionView *scrollView;
@property (nonatomic,strong)UIPageControl *pageControl;
@property (nonatomic,strong)UILabel *textTips;
@property (nonatomic,assign)BOOL isOpen;/** 判断定时器是否开启*/
@property (nonatomic,assign)CycleScrollViewIndicatorType indicatorType;


@end

@implementation ZZCollectionView

static NSString *identifier = @"scroll_cell";

-(NSTimer *)timer{
	if (_timer == nil) {
		_timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(nextCell) userInfo:nil repeats:YES];
	}
	return _timer;
}

-(void)setIndicatorType:(CycleScrollViewIndicatorType )indicatorType{
	_indicatorType = indicatorType;
	
	switch (_indicatorType) {
	  case CycleScrollViewIndicatorDotType:
		{
			/** 页数指示器*/
			_pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, ZZHeight-15, ZZWidth, 15)];
			_pageControl.numberOfPages = _sourceImages.count;
			_pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
			_pageControl.pageIndicatorTintColor = [UIColor grayColor];
			[self addSubview:_pageControl];
			_pageControl.currentPage = _middleIndex;/** 设置当前页数指示器与图片所在数组中下标一致*/
		}
			break;
		case CycleScrollViewIndicatorTextType:
		{
			_textTips = [[UILabel alloc]initWithFrame:CGRectMake(0, ZZHeight-15, ZZWidth, 15)];
			_textTips.font = [UIFont systemFontOfSize:14];
			_textTips.textAlignment = NSTextAlignmentCenter;
			_textTips.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
			_textTips.textColor = [UIColor whiteColor];
			[self addSubview:_textTips];
			
			_textTips.text = [NSString stringWithFormat:@"%ld / %lu",(long)self.middleIndex+1,(unsigned long)self.sourceImages.count];

			
		}
			break;
  default:
			break;
	}
	

}
-(instancetype)initWithFrame:(CGRect)frame images:(NSArray *)sourceImages indicatorType:(CycleScrollViewIndicatorType)indicatorType{
	if (self = [super initWithFrame:frame]) {
		/** layout*/
		UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
		layout.itemSize = CGSizeMake(SCREENWIDTH, frame.size.height);
		layout.minimumLineSpacing = 0;
		layout.minimumInteritemSpacing = 0;
		layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
		
		/** collectionView*/
		_scrollView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) collectionViewLayout:layout];
		[_scrollView registerNib:[UINib nibWithNibName:NSStringFromClass([ScrollCell class]) bundle:nil] forCellWithReuseIdentifier:identifier];
		_scrollView.backgroundColor = [UIColor whiteColor];
		_scrollView.dataSource = self;
		_scrollView.delegate = self;
		_scrollView.pagingEnabled = YES;
		_scrollView.showsHorizontalScrollIndicator = NO;
		
		if (sourceImages.count > 1) {
			_middleIndex = 0;
			_leftIndex = sourceImages.count -1 ;
			_rightIndex = 1;
		}
		
		_sourceImages = sourceImages;
		_showImages = [NSMutableArray array];
		[_showImages addObject:sourceImages[_leftIndex]];
		[_showImages addObject:sourceImages[_middleIndex]];
		[_showImages addObject:sourceImages[_rightIndex]];
		[self addSubview:_scrollView];
		
		
		self.indicatorType = indicatorType;
		[_scrollView setContentOffset:CGPointMake(SCREENWIDTH, 0)];/** 设置初始偏移量*/
			
		self.isOpen = YES;

	}
	return self;
}
-(void)nextCell{
	
	
	
	
	[_scrollView setContentOffset:CGPointMake(SCREENWIDTH*2, 0)];
	
	[self scrollToNextCell];
	

	
}

#pragma mark UICollectionViewDataSource 协议
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
	ScrollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
//	cell.scrollImage.image = _showImages[indexPath.row];
	
	[cell.scrollImage sd_setImageWithURL:[NSURL URLWithString:_showImages[indexPath.row]] placeholderImage:[UIImage imageNamed:@"watermelon.jpg"]];
	return cell;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
	
	return _showImages.count;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
	if (self.isOpen ) {/** 如果定时器打开，则关闭定时器*/
		[self.timer invalidate];
		self.timer = nil;
		self.isOpen = NO;/** 将定时器关闭后，设置BOOL变量为NO*/
	}
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
	
	if (!self.isOpen) {
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			[self.timer fire];
			self.isOpen = YES;
		});
		

	}
	
	if (scrollView == _scrollView) {
		[self scrollToNextCell];
	}
	
}
-(void)scrollToNextCell{
	/** 右滑*/
//		NSLog(@"偏移量:%f",_scrollView.contentOffset.x);

//		NSLog(@"拖拽后 ：left  %ld  middle : %ld right :%ld",_leftIndex ,_middleIndex ,(long)_rightIndex);

		if (_scrollView.contentOffset.x == SCREENWIDTH *2) {
			//			[_scrollView setContentOffset:CGPointMake(SCREENWIDTH, 0)];
			[_scrollView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];

			_middleIndex ++;
			if (_middleIndex == _sourceImages.count) {
				_middleIndex = 0;
			}

			_rightIndex = _middleIndex + 1;
			_leftIndex = _middleIndex - 1;


			if (_leftIndex == -1) {
				_leftIndex = _sourceImages.count -1;
			}
			if (_rightIndex == _sourceImages.count ) {
				_rightIndex = 0;
			}

		}
		/** 左滑*/
		if (_scrollView.contentOffset.x == 0) {
			//			[_scrollView setContentOffset:CGPointMake(SCREENWIDTH, 0)];
			[_scrollView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];

			_middleIndex --;
			if (_middleIndex == -1) {
				_middleIndex = _sourceImages.count -1;
			}
			_rightIndex = _middleIndex + 1;
			_leftIndex = _middleIndex - 1;

			if (_leftIndex == -1 ) {
				_leftIndex = _sourceImages.count - 1;
			}
			if (_rightIndex == _sourceImages.count) {
				_rightIndex = 0;
			}

		}
	

	[_showImages removeAllObjects];
	[_showImages addObject:_sourceImages[_leftIndex]];
	[_showImages addObject:_sourceImages[_middleIndex]];
	[_showImages addObject:_sourceImages[_rightIndex]];

	[_scrollView reloadData];
	_pageControl.currentPage = _middleIndex;
	
	_textTips.text = [NSString stringWithFormat:@"%ld / %lu",(long)self.middleIndex+1,(unsigned long)self.sourceImages.count];


}

@end
