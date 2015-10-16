//
//  TopCollectionReusableView.m
//  VMovie
//
//  Created by laouhn on 15/9/14.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "TopCollectionReusableView.h"
#import "AFNetworking.h"
#import "VideoController.h"
#import "PlayViewController.h"


@interface TopCollectionReusableView ()<SDCycleScrollViewDelegate>

@property (nonatomic, retain) NSMutableArray *imagesURLStrings;
@property (nonatomic, retain) NSMutableArray *titles;

@end

@implementation TopCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadImg];
    }
    
    return self;
}

- (void)loadImg
{
//    
//            self.imagesURLStrings = [@[
//                                          @"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
//                                          @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
//                                          @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"
//                                          ] mutableCopy];
//    
    //        // 情景三：图片配文字
    //        NSArray *titles = @[@"感谢您的支持，如果下载的",
    //                            @"如果代码在使用过程中出现问题",
    //                            @"您可以发邮件到gsdios@126.com",
    //                            @"感谢您的支持"
    //                            ];
    
    
    
    
   
    
    //        // 本地加载 --- 创建不带标题的图片轮播器
    //        SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 100, w, 180) imagesGroup:images];
    //
    //        cycleScrollView.infiniteLoop = YES;
    //        cycleScrollView.delegate = self;
    //        cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    //        [self.view addSubview:cycleScrollView];
    //
    
    
    //         --- 轮播时间间隔，默认1.0秒，可自定义
    //cycleScrollView.autoScrollTimeInterval = 4.0;
    
    
    self.imagesURLStrings = [NSMutableArray arrayWithCapacity:1];
    self.titles = [@[] mutableCopy];
    
    //网络加载 --- 创建带标题的图片轮播器
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 180) imageURLStringsGroup:nil]; // 模拟网络延时情景
    self.cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    self.cycleScrollView.delegate = self;
   
    self.cycleScrollView.dotColor = [UIColor yellowColor]; // 自定义分页控件小圆标颜色
    self.cycleScrollView.placeholderImage = [UIImage imageNamed:@"66.jpg"];
    [self addSubview:self.cycleScrollView];
    
    
    //             --- 模拟加载延迟
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.cycleScrollView.imageURLStringsGroup = self.imagesURLStrings;
//    });
    
    
    // 清除缓存
    //    [cycleScrollView2 clearCache];
}
- (void)setVideos:(NSArray *)videos
{
    if (_videos != videos) {
        [_videos release];
        _videos = [videos copy];
        
        if (![self.imagesURLStrings count]) {
            
            for (VideoModel * video in _videos) {
                
                [self.imagesURLStrings addObject:video.img];
                [self.titles addObject:video.title];
            }
            self.cycleScrollView.titlesGroup = self.titles;
            self.cycleScrollView.imageURLStringsGroup = self.imagesURLStrings;
        }
    }
   
}


#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", index);
    VideoModel * video = [self.videos objectAtIndex:index];   
    [self.target performSelector:self.action withObject:video];
//    [self addressParser:video];

}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView index:(NSInteger)index
{
    
}
- (void)addressParser:(VideoModel *)video
{

        NSString * str = [NSString stringWithFormat:@"http://api2.jxvdy.com/%@_info?token=&id=%d",(video.maxepisode ? @"video" : @"drama"), [video.videoID intValue]];
        
        NSString * newUrlString = [str stringByAppendingString:[video.videoID stringValue]];
        NSLog(@"%@", newUrlString);
        AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/plain",nil];
        [manager GET:newUrlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            VideoModel * model = [[VideoModel alloc] init];
            [model setValuesForKeysWithDictionary:(NSDictionary *)responseObject];
            
            VideoController * videoVC = [[VideoController alloc] init];
            videoVC.video = model;
            NSLog(@"%@", model.title);
            videoVC.hidesBottomBarWhenPushed = YES;
            
            [videoVC release];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"lkjhgfds");
        }];
        
 
    
  }

- (void)dealloc
{
    self.videos = nil;
    self.imagesURLStrings = nil;
    self.titles = nil;
    
    [super dealloc];
}

@end
