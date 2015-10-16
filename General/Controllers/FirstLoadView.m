//
//  FirstLoad.m
//  LoveMovie
//
//  Created by laouhn on 15/9/17.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "FirstLoadView.h"
#import "TabBarViewController.h"
#import "RootViewController.h"
#import "SDCycleScrollView.h"
#define KWIDTH [UIScreen mainScreen].bounds.size.width
#define KHIGHT [UIScreen mainScreen].bounds.size.height
@interface FirstLoadView ()<UIScrollViewDelegate,SDCycleScrollViewDelegate>

//@property (nonatomic, retain) UIScrollView * scrollView;
//@property (nonatomic, retain) NSTimer * timer;
@property (nonatomic, retain) NSMutableArray *images;
@property (nonatomic, retain) NSMutableArray *titles;
@property (nonatomic, assign) NSInteger index;
@end

@implementation FirstLoadView

- (void)dealloc
{
//    self.scrollView = nil;
    self.images     = nil;
    self.titles     = nil;
//    self.timer      = nil;
    
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadImg];
        
//        [self addSubview:self.scrollView];
//      self.timer =  [NSTimer scheduledTimerWithTimeInterval:1.5 target:self
//                                                         selector:@selector(firstLoad) userInfo:nil repeats:YES];
    }
    return self;
}


- (void)loadImg
{
    
                self.images = [@[[UIImage imageNamed:@"firstLoad1"],
                                [UIImage imageNamed:@"firstLoad2"],
                                [UIImage imageNamed:@"firstLoad3"],
                               [UIImage imageNamed:@"firstLoad4"]] mutableCopy];
    
    
    
    
    
    
    
            // 情景三：图片配文字
            NSArray *titles = @[@"最精彩的世界,莫过于自己走过的路",
                                @"自己的世界,该由自己掌控",
                                @"神龙大侠,带你进入童话世界",
                                @"点我, 快去看看吧..."];
    
    
    
    
    
    
    //        // 本地加载 --- 创建不带标题的图片轮播器
            SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:self.bounds imagesGroup:self.images];
    
            cycleScrollView.infiniteLoop = NO;
            cycleScrollView.autoScroll = NO;
            cycleScrollView.delegate = self;
          cycleScrollView.pageControlAliment =   SDCycleScrollViewPageContolAlimentCenter;
           cycleScrollView.titlesGroup = titles;
            cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
           cycleScrollView.titleLabelHeight = 200;
    
           cycleScrollView.titleLabelTextFont = [UIFont systemFontOfSize:36];
            [self addSubview:cycleScrollView];
    
    
    
    //         --- 轮播时间间隔，默认1.0秒，可自定义
    cycleScrollView.autoScrollTimeInterval = 2.0;
 
}


#pragma mark - SDCycleScrollViewDelegate


- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{

    if(index == 3) {
        
        
        
       
        
               [UIView  animateWithDuration:1 animations:^{
            self.alpha= 0;
            
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
        [self loading:nil];

    }
    
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView index:(NSInteger)index
{
    if (index == 3) {
        
        [UIView animateWithDuration:1 animations:^{
            self.hidden = YES;
            
        } completion:^(BOOL finished) {
             [self removeFromSuperview];
        }];
        
        [self loading:nil];
        
    }
    
    self.index = index;
}

//- (void)firstLoad
//{
//    
//    if (self.scrollView.contentOffset.x != KWIDTH * 3) {
//        [UIView animateWithDuration:1 animations:^{
//           self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x + KWIDTH, 0);
//        }];
//        
//    }else
//    {
//        
//        __block typeof(self) mySelf = self;
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//            [mySelf loading:nil];
//        });
//        
//
//    }
//  
//}

//- (UIScrollView *)scrollView
//{
//    if (!_scrollView) {
//        self.scrollView = [[[UIScrollView alloc] initWithFrame:self.bounds] autorelease];
//        self.scrollView.delegate = self;
//        self.scrollView.pagingEnabled = YES;
//        self.scrollView.contentSize = CGSizeMake(KWIDTH * 4, KHIGHT);
//        for (int i = 0; i < 4; i++) {
//            UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(KWIDTH * i, 0, KWIDTH, KHIGHT)];
//            
//            imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"firstLoad%d.jpg",i+1]];
//           
//            if (i == 3) {
//                
//                UIButton * btu = [UIButton buttonWithType:UIButtonTypeCustom];
//                btu.frame = CGRectMake(100, 450, 200, 50);
//                btu.backgroundColor = [UIColor redColor];
//                
//                [btu setTitle:@"快去看看" forState:UIControlStateNormal];
////                [btu setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//                [btu addTarget:self action:@selector(loading:) forControlEvents:UIControlEventTouchUpInside];
//                [btu.layer setCornerRadius:10];
//                [imgView addSubview:btu];
//   
//            }
//            imgView.userInteractionEnabled = YES;
//            [_scrollView addSubview:imgView];
//        
//            [imgView release];
//            
//        }
//
//    }
//    return [[_scrollView retain] autorelease];
//}
//

- (void)loading:(UIButton *)sender
{
    RootViewController * rootVC = [[[RootViewController alloc] init] autorelease];
    
    self.window.rootViewController = rootVC;
    
   
}

#pragma mark -----

//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
//{
//    
//    
//    [self.timer setFireDate:[NSDate distantFuture]];
//    
//}
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.timer setFireDate:[NSDate date]];
//    });
//    
//}





@end
