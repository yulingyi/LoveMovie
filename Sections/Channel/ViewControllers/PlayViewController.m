//
//  PlayViewController.m
//  LoveMovie
//
//  Created by laouhn on 15/9/22.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "PlayViewController.h"
#import "DetailTableViewCell.h"
#import "RelateTableViewController.h"
#import "NetworkEngine.h"
#import "detailModel.h"
#import "DetailTableViewCell.h"

#define SWIDTH self.view.frame.size.width
#define SHEIGHT self.view.frame.size.height


@interface PlayViewController ()<UIScrollViewDelegate>

@property (nonatomic, retain) DetailTableViewCell * detailVC;
@property (nonatomic, retain) RelateTableViewController * relateVC;
@property (nonatomic, retain) UIScrollView * scrollView;
@property (nonatomic, retain) NSMutableArray * dataSourceAry;

@property (nonatomic, retain) NSMutableArray * buttonAry;
@property (nonatomic, retain) UISegmentedControl * segment;

@end

@implementation PlayViewController


-(void)dealloc
{
    self.detailVC = nil;
    self.relateVC = nil;
    self.scrollView = nil;
    self.dataSourceAry = nil;
    self.buttonAry = nil;
    self.segment = nil;
    [super dealloc];
}


- (void)viewWillAppear:(BOOL)animated
{
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.detailVC];
    [self.scrollView addSubview:self.relateVC.view];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
   


    
    [self.view addSubview:self.segment];
    
    [[self.buttonAry firstObject] setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    NSString * urlString = [NSString stringWithFormat:@"http://api2.jxvdy.com/video_info?token=&id=%@", [self.video.videoID stringValue]];
    
    __block typeof(self) mySelf = self;
    [[NetworkEngine shareNetworkEngine] getInfoFromServerWithURLStr:urlString success:^(id response) {
        
        [mySelf dataWithParsing:response];
    } fail:^(NSError *error) {
        
        
    }];
   
}


- (UISegmentedControl *)segment
{
    if (!_segment) {
        self.segment = [[[UISegmentedControl alloc] initWithItems:@[@"详情", @"相关"]] autorelease];
        [_segment setFrame:CGRectMake(0, CGRectGetMaxY(self.player.view.frame), [UIScreen mainScreen].bounds.size.width, 50)];
        [_segment addTarget:self action:@selector(segmentChange:) forControlEvents:UIControlEventValueChanged];
        _segment.selectedSegmentIndex = 0;
    }
    return [[_segment retain] autorelease];
}




#pragma mark - 解析数据
- (void)dataWithParsing:(NSDictionary *)dic
{
    detailModel * detail = [[[detailModel alloc] init] autorelease];
    [detail setValuesForKeysWithDictionary:dic];
    [self.dataSourceAry addObject:detail];
    self.detailVC.detailModel = [self.dataSourceAry firstObject];
    if ([dic[@"playurl"] objectForKey:@"720P"]) {
        self.video.videoURL = [dic[@"playurl"] objectForKey:@"720P"];
    }else if([dic[@"playurl"] objectForKey:@"480P"])
    {
       self.video.videoURL = [dic[@"playurl"] objectForKey:@"480P"];
    }else
    {
         self.video.videoURL = [dic[@"playurl"] objectForKey:@"360P"];
    }
    
    
    [self setMPMoviePlayerController:self.video.videoURL];
}


#pragma lazyloading

- (NSMutableArray *)dataSourceAry
{
    if (!_dataSourceAry) {
        self.dataSourceAry = [@[] mutableCopy];
    }
    return [[_dataSourceAry retain] autorelease];
}

- (DetailTableViewCell *)detailVC
{
    if (!_detailVC) {
        self.detailVC = [[[DetailTableViewCell alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.scrollView.frame.size.height)] autorelease];
        }
    return [[_detailVC retain] autorelease];
}

- (RelateTableViewController *)relateVC
{
    if (_relateVC == nil) {
        self.relateVC = [[[RelateTableViewController alloc] init] autorelease];
        [self addChildViewController:_relateVC];
        [NetworkEngine shareNetworkEngine].houHeight = self.scrollView.frame.size.height;
        [self.relateVC.view setFrame:CGRectMake(self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
        _relateVC.myId = self.video.videoID;
    }
    return [[_relateVC retain] autorelease];
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        self.scrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_segment.frame), [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - CGRectGetMaxY(_segment.frame))] autorelease];
        _scrollView.pagingEnabled = YES;
        _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * 2, _scrollView.frame.size.height);
        _scrollView.delegate = self;
        _scrollView.backgroundColor = [UIColor whiteColor];
    }
    return [[_scrollView retain] autorelease];
}





#pragma mark - 代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.segment.selectedSegmentIndex = (int)self.scrollView.contentOffset.x / (int)self.scrollView.frame.size.width;
}


- (void)segmentChange:(UISegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex) {
        case 0:
            [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width * sender.selectedSegmentIndex, 0)];
            break;
        case 1:
            [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width * sender.selectedSegmentIndex, 0)];
            break;
        default:
            break;
    }
}





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
