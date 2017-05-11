//
//  ViewController.m
//  UICollectionView轮播图
//
//  Created by zan.zhang on 17/3/9.
//  Copyright © 2017年 zan.zhang  All rights reserved.
//

#import "ViewController.h"
#import "ZZCollectionView.h"
//#define Reuseidentifer @"scroll_class"

#import "ScrollCell.h"
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController ()
@property (nonatomic,strong)NSArray *sourceImages;
@property (nonatomic,strong)ZZCollectionView *scrollView;



@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.automaticallyAdjustsScrollViewInsets = NO;
	
	_sourceImages = @[@"http://mu1.sinaimg.cn/frame.750x1080/weiyinyue.music.sina.com.cn/movie_poster/177380_vertical.jpg?v=1490083200",@"http://mu1.sinaimg.cn/frame.750x1080/weiyinyue.music.sina.com.cn/movie_poster/179424_vertical.jpg?v=1490083200",@"http://mu1.sinaimg.cn/frame.750x1080/weiyinyue.music.sina.com.cn/movie_poster/177440_vertical.jpg?v=1490083200",@"http://mu1.sinaimg.cn/frame.750x1080/weiyinyue.music.sina.com.cn/movie_poster/181922_vertical.jpg?v=1490083200"];
//	self.scrollView = [[ZZCollectionView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT*0.3) images:_sourceImages];
	
	
	self.scrollView = [[ZZCollectionView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT*0.3) images:_sourceImages indicatorType:CycleScrollViewIndicatorTextType];
	
	

	[self.view addSubview:self.scrollView];

}
-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];

	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[self.scrollView.timer setFireDate:[NSDate distantPast]];//打开定时器

	});
	
}

-(void)viewDidDisappear:(BOOL)animated{
	[super viewDidDisappear:animated];//关闭定时器
	[self.scrollView.timer setFireDate:[NSDate distantFuture]];
}


@end
