//
//  VideoController.m
//  LoveMovie
//
//  Created by laouhn on 15/9/18.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "VideoController.h"
#import "DetailVIew.h"
#import "ScreenCollectionViewController.h"
#import "AFNetworking.h"


#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height


@interface VideoController ()<UIScrollViewDelegate>

@property (nonatomic, retain) UISegmentedControl * segment;
@property (nonatomic, retain) UIScrollView       * scrollView;
@property (nonatomic, retain) UICollectionViewFlowLayout * layout;
@property (nonatomic, retain) UIScrollView       * episodeScrollView;



@end

@implementation VideoController

- (void)dealloc
{
    self.vid = nil;
    self.segment = nil;
    self.scrollView = nil;
    self.layout = nil;
    self.episodeScrollView = nil;
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = self.video.title;
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/plain",nil];
    [manager GET:[@"http://api2.jxvdy.com/drama_video?" stringByAppendingString:[NSString stringWithFormat:@"id=%d&episode=1", [self.vid intValue]]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString * string = nil;
        if ([responseObject objectForKey:@"playurl"][@"720P"]) {
            string = responseObject[@"playurl"][@"720P"];
        }else if([responseObject objectForKey:@"playurl"][@"480P"])
        {
            string = responseObject[@"playurl"][@"480P"];
        }else
        {
            string = responseObject[@"playurl"][@"360P"];
        }
        
        [self setMPMoviePlayerController:string];
        NSLog(@"%@",  string);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    [self.view addSubview:self.segment];
    [self.view addSubview:self.scrollView];
    [self loadDetailScrollView];
}

#pragma mark - 懒加载
- (UICollectionViewFlowLayout *)layout
{
    if (_layout == nil) {
        self.layout = [[[UICollectionViewFlowLayout alloc] init] autorelease];
        self.layout.itemSize = CGSizeMake((kWidth - 30) / 3, 200);
        //设置区头视图
        self.layout.headerReferenceSize = CGSizeMake(0, 10);
        self.layout.minimumLineSpacing = 5;
        self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
    }
    return [[_layout retain] autorelease];
}

- (UISegmentedControl *)segment
{
    if (!_segment) {
        self.segment = [[[UISegmentedControl alloc] initWithItems:@[@"详情", @"选集", @"相关"]] autorelease];
        self.segment.frame = CGRectMake(0, CGRectGetMaxY(self.player.view.frame), kWidth, 40);
        self.segment.selectedSegmentIndex = 0;
        [self.segment addTarget:self action:@selector(segmentClicked:) forControlEvents:UIControlEventValueChanged];
    }
    return [[_segment retain] autorelease];
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        self.scrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0,  CGRectGetMaxY(_segment.frame), kWidth, kHeight - CGRectGetMaxY(_segment.frame))] autorelease];
        self.scrollView.delegate = self;
        self.scrollView.contentSize = CGSizeMake(kWidth * 3, kHeight - 364);
        self.scrollView.pagingEnabled = YES;
        self.scrollView.directionalLockEnabled = YES;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
    }
    return [[_scrollView retain] autorelease];
}

- (UIScrollView *)episodeScrollView
{
    if (!_episodeScrollView) {
        self.episodeScrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(kWidth, 0, kWidth, self.scrollView.frame.size.height)] autorelease];
        self.episodeScrollView.directionalLockEnabled = YES;
    }
    return [[_episodeScrollView retain] autorelease];
}


#pragma mark - segment按钮方法
- (void)segmentClicked:(UISegmentedControl *)sender
{
    self.scrollView.contentOffset = CGPointMake(kWidth * sender.selectedSegmentIndex, 0);
}

#pragma mark - 代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.segment.selectedSegmentIndex = fabs(scrollView.contentOffset.x) /scrollView.frame.size.width;
}
#pragma mark - 加载视图
- (void)loadDetailScrollView
{
    DetailVIew * detail = [[[DetailVIew alloc] initWithFrame:CGRectMake(0, 0, kWidth, self.scrollView.frame.size.height) video:self.video] autorelease];
    detail.contentSize  = CGSizeMake(kWidth, 400);
    detail.directionalLockEnabled = YES;
    [self.scrollView addSubview:detail];
    
    [self addEpisodeScrollView];
    
    ScreenCollectionViewController * relatedVC = [[[ScreenCollectionViewController alloc] initWithCollectionViewLayout:self.layout] autorelease];
    relatedVC.view.frame = CGRectMake(kWidth * 2, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    [relatedVC getDataByUrlStr:[@"http://api2.jxvdy.com/drama_related?count=12&id=" stringByAppendingString:self.vid]];
    [self addChildViewController:relatedVC];
    [self.scrollView addSubview:relatedVC.view];
}
- (void)addEpisodeScrollView
{
    self.episodeScrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, 5 + ([self.video.maxepisode intValue] / 7) * 40  + 50);
    for (int i = 0; i < [self.video.maxepisode intValue]; i++) {
        UIButton * episodeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        episodeButton.frame = CGRectMake((i % 7) * (kWidth - 30) / 7 + 15, 5 +(i / 7) * 40, (kWidth - 30) / 7 - 5, 35);
        episodeButton.tag = 500 + i;
        episodeButton.layer.cornerRadius = 5;
        [episodeButton setTitle:[NSString stringWithFormat:@"%d集", i + 1] forState:UIControlStateNormal];
        episodeButton.backgroundColor = [UIColor orangeColor];
        [episodeButton addTarget:self action:@selector(episodeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.episodeScrollView addSubview:episodeButton];
    }
    [self.scrollView addSubview:self.episodeScrollView];
}

- (void)episodeButtonClick:(UIButton *)sender
{
    NSString * urlString = [@"http://api2.jxvdy.com/drama_video?" stringByAppendingString:[NSString stringWithFormat:@"id=%@&episode=%ld", self.vid , sender.tag - 499]];
    NSLog(@"%@", urlString);
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/plain",nil];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString * string = nil;
        if ([responseObject objectForKey:@"playurl"][@"720P"]) {
            string = responseObject[@"playurl"][@"720P"];
        }else if([responseObject objectForKey:@"playurl"][@"480P"])
        {
            string = responseObject[@"playurl"][@"480P"];
        }else
        {
            string = responseObject[@"playurl"][@"360P"];
        }
        
        self.video.episode = [NSNumber numberWithInt:(int)(sender.tag - 499)];
        
        [self setMPMoviePlayerController:string];
        NSLog(@"720%@", string);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}



#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */





@end
