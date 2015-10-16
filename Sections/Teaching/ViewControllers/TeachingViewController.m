//
//  TeachingViewController.m
//  LoveMovie
//
//  Created by laouhn on 15/9/17.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "TeachingViewController.h"
#import "manyViewController.h"

#define TWITHD 49
#define KSIZE [UIScreen mainScreen].bounds.size
#define KWITH scroll.centerScrollView.frame.size.width
#define KHIGHT scroll.centerScrollView.frame.size.height
@interface TeachingViewController ()

@property (nonatomic, retain) NSMutableArray * VCArray;

@end

@implementation TeachingViewController

- (void)dealloc
{
    self.VCArray = nil;
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchVideos:)];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self getScrollView];
}


#pragma mark - lazyloading
- (NSMutableArray *)VCArray
{
    if (!_VCArray) {
        self.VCArray = [@[] mutableCopy];
    }
    return [[_VCArray retain] autorelease];
}


#pragma mark - 搜索按钮实现方法
- (void)searchVideos:(UIBarButtonItem *)sender
{
    SearchViewController * search = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:search animated:YES];
    [search release];
}

#pragma mark - scrollView
- (void)getScrollView
{
    
    ScrollView * scroll = [[ScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - TWITHD - 64)];
    scroll.centerScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scroll];
    
    RecommendTableViewController * baseTable = [[RecommendTableViewController alloc] initWithStyle:UITableViewStylePlain] ;
    [self addChildViewController:baseTable];
    baseTable.view.frame = CGRectMake(0, 0, KWITH, KHIGHT );
    [scroll.centerScrollView addSubview:baseTable.view];
//    NSString * urlStr = @"http://api2.jxvdy.com/search_list?model=tutorials&attr=2&direction=1&count=15&type=14&token=";
////    [ getUrl:urlStr];
    [baseTable release];
    
    DramaCourseTableViewController * drama = [[DramaCourseTableViewController alloc] initWithStyle:UITableViewStylePlain];
    drama.view.frame = CGRectMake(KWITH * 1, 0, KWITH, KHIGHT);
    [self addChildViewController:drama];
    NSString * str = @"http://api2.jxvdy.com/search_list?model=tutorials&attr=2&direction=1&count=15&type=14&token=";
    drama.urlString = str;
    [drama getUrl:str];
    [scroll.centerScrollView addSubview:drama.view];
    [drama release];
    


    TinyShootViewController * tiny = [[TinyShootViewController alloc] initWithStyle:UITableViewStylePlain] ;
    tiny.view.frame = CGRectMake(KWITH * 2, 0, KWITH, KHIGHT);
    [self addChildViewController:tiny];
    [scroll.centerScrollView addSubview:tiny.view];
    [tiny release];
    
    FilmLaterViewController * filmVC = [[FilmLaterViewController alloc] initWithStyle:UITableViewStylePlain];
    filmVC.view.frame = CGRectMake(KWITH * 3, 0, KWITH, KHIGHT);
    [self addChildViewController:filmVC];
    [scroll.centerScrollView addSubview:filmVC.view];
    [filmVC release];
    
    
    ShootEquitmentViewController * shoot = [[ShootEquitmentViewController alloc] initWithStyle:UITableViewStylePlain] ;
    shoot.view.frame = CGRectMake(KWITH * 4, 0, KWITH, KHIGHT);
    [self addChildViewController:shoot];
    [scroll.centerScrollView addSubview:shoot.view];
    [shoot release];
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
