//
//  ScreenViewController.m
//  LoveMovie
//
//  Created by laouhn on 15/9/17.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "MoreNetWorkViewController.h"
#define KWIDTH [UIScreen mainScreen].bounds.size.width
#define KHIGHT [UIScreen mainScreen].bounds.size.height
#import "ScreenCollectionViewController.h"
#import "MicroFilmUrl.h"
@interface  MoreNetWorkViewController()<UIScrollViewDelegate>
@property (nonatomic, retain) UISegmentedControl * segment;
@property (nonatomic, retain) UIScrollView *  scrollView;

@end

@implementation MoreNetWorkViewController

- (void)dealloc
{
    self.segment = nil;
    self.scrollView = nil;
    
    [super dealloc];
}



- (UISegmentedControl *)segment
{
    if (!_segment) {
        self.segment = [[[UISegmentedControl alloc] initWithItems:@[@"最新",@"最热",@"好评"]] autorelease];
        _segment.frame = CGRectMake(0, 64, self.view.frame.size.width, 40);
        [_segment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
        _segment.selectedSegmentIndex = 0;
    }
    return [[_segment retain] autorelease];
}


- (void)segmentAction:(UISegmentedControl *)sender
{
    
    self.scrollView.contentOffset = CGPointMake(KWIDTH * sender.selectedSegmentIndex, 0);
}








- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        self.scrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0,  104, KWIDTH, KHIGHT - 64- 49)] autorelease];
        
        //        self.scrollView.backgroundColor = [UIColor redColor];
        _scrollView.contentSize = CGSizeMake(KWIDTH * 3, KHIGHT - 64- 49);
        self.scrollView.pagingEnabled = YES;
        self.scrollView.delegate = self;
    }
    return [[_scrollView retain] autorelease];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"筛选";
    [self.view addSubview:self.segment];
    
    [self.view addSubview:self.scrollView];
    [self loadViewToScrollView];
    // Do any additional setup after loading the view.
}

- (UICollectionViewFlowLayout *)getLayout
{
    
    UICollectionViewFlowLayout * layout = [[[UICollectionViewFlowLayout alloc] init] autorelease];
    
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumInteritemSpacing = 5;
    layout.itemSize = CGSizeMake((KWIDTH - 20) / 3 ,(KWIDTH - 20) / 3 * 1.5);
    layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
    return layout;
}


- (void)loadViewToScrollView
{
    
    //微电影筛选地址类型
    NSArray * orderAry = @[@"time",@"hits",@"like"];
    
    for (int i = 0; i < 3; i++) {
        
        
        NSString * urlStr =[NSString stringWithFormat:@"http://api2.jxvdy.com/search_list?model=drama&direction=1&count=12&order=%@",orderAry[i]];
        ScreenCollectionViewController * scVC = [[[ScreenCollectionViewController alloc] initWithCollectionViewLayout:[self getLayout]] autorelease];
        
        [self addChildViewController:scVC];
        scVC.view.frame = CGRectMake(KWIDTH * i, 10, KWIDTH, KHIGHT - 64- 49);
        [self.scrollView addSubview:scVC.view];
        [scVC getDataByUrlStr:urlStr];
    }
    
}

#pragma mark---

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.segment.selectedSegmentIndex = self.scrollView.contentOffset.x / KWIDTH;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
