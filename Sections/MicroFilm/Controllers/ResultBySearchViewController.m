//
//  ResultBySearchViewController.m
//  LoveMovie
//
//  Created by laouhn on 15/9/18.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "ResultBySearchViewController.h"
#define KWIDTH [UIScreen mainScreen].bounds.size.width
#define KHIGHT [UIScreen mainScreen].bounds.size.height
#import "ScreenCollectionViewController.h"
#import "MicroFilmUrl.h"
#import "ScreenTableViewController.h"
#import "FMDB.h"
@interface ResultBySearchViewController ()<UIScrollViewDelegate, UISearchBarDelegate>
@property (nonatomic, retain) UISegmentedControl * segment;
@property (nonatomic, retain) UIScrollView *  scrollView;

@property (nonatomic, retain) UISearchBar * searchBar;
@end

@implementation ResultBySearchViewController





- (void)dealloc
{
    self.segment = nil;
    self.scrollView = nil;

    self.searchBar = nil;
    [super dealloc];
}

- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        self.searchBar = [[[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.navigationItem.titleView.frame.size.width, 40)] autorelease];
        _searchBar.placeholder = @"请输入关键字....";
        _searchBar.delegate = self;
        
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    }
    return [[_searchBar retain] autorelease];
    
}


- (UISegmentedControl *)segment
{
    if (!_segment) {
        self.segment = [[[UISegmentedControl alloc] initWithItems:@[@"微电影",@"网络剧",@"教学"]] autorelease];
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
        
        
        _scrollView.contentSize = CGSizeMake(KWIDTH * 3, KHIGHT - 64- 49);
        self.scrollView.pagingEnabled = YES;
        self.scrollView.delegate = self;
    }
    return [[_scrollView retain] autorelease];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.segment];
    self.navigationItem.titleView = [[[UIView alloc] init] autorelease];
    self.navigationItem.titleView.frame = CGRectMake(0, 0, KWIDTH - 100, 40);
    [self.navigationItem.titleView addSubview:self.searchBar];
    [self.view addSubview:self.scrollView];
    self.searchBar.text = self.key;
    [self loadViewToScrollView];
    // Do any additional setup after loading the view.
}


- (UICollectionViewFlowLayout *)getLayout
{
    
    UICollectionViewFlowLayout * layout = [[[UICollectionViewFlowLayout alloc] init] autorelease];
    
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumInteritemSpacing = 5;
    layout.itemSize = CGSizeMake((KWIDTH - 20) / 3 , (KWIDTH - 20) / 3 * 1.5);
    layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
    return layout;
}

- (void)loadViewToScrollView
{
  
    //微电影筛选地址类型
    NSArray * orderAry = @[@"video",@"drama",@"tutorials"];
    
    for (int i = 0; i < 3; i++) {
        
        NSString * urlStr =[NSString stringWithFormat:@"http://api2.jxvdy.com/search_list?model=%@&count=15&keywords=%@&token=", orderAry[i], self.key];
        if (i != 2) {
            ScreenCollectionViewController * scVC = [[ScreenCollectionViewController alloc] initWithCollectionViewLayout:[self getLayout]];
            [self addChildViewController:scVC];
            scVC.view.frame = CGRectMake(KWIDTH * i, 10, KWIDTH, KHIGHT - 64- 49);
            
            [self.scrollView addSubview:scVC.view];
            [scVC getDataByUrlStr:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            [scVC release];
        }else
        {
            ScreenTableViewController * scVC = [[ScreenTableViewController alloc] init];
            scVC.view.frame = CGRectMake(KWIDTH * i, 10, KWIDTH, KHIGHT - 64- 49);
            [self addChildViewController:scVC];

            [self.scrollView addSubview:scVC.view];
            [scVC getDataByUrlStr:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            [scVC release];
        }
       

    }
    
    
    
    
    
}

#pragma mark---

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.segment.selectedSegmentIndex = self.scrollView.contentOffset.x / KWIDTH;
}

#pragma mark---UISearchBarDelegate


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    //微电影筛选地址类型
    NSArray * orderAry = @[@"video",@"drama",@"tutorials"];
    
    for (int i = 0; i < 3; i++) {
        NSString * urlStr =[NSString stringWithFormat:@"http://api2.jxvdy.com/search_list?model=%@&count=15&keywords=%@&token=",orderAry[i], self.searchBar.text];
        
            for (UIViewController * vc in self.childViewControllers) {
                if ([vc isKindOfClass:[ScreenCollectionViewController class]]) {
                    
                    ScreenCollectionViewController * scrVC = (ScreenCollectionViewController *)vc;
                    
                    [scrVC.dataSource removeAllObjects];
                    [scrVC getDataByUrlStr:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                }else
                {
                    ScreenTableViewController * tabVC = (ScreenTableViewController *)vc;
                    
                    [tabVC.dataSource removeAllObjects];
                    [tabVC getDataByUrlStr:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                   
                    
                }
                
            }
       
        
   
    }

    
}

- (void)insertKeyToSql:(NSString *)key
{
    
    NSString * DocPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    NSString * sqlPath = [DocPath stringByAppendingPathComponent:@"data.sqlite"];
    
    FMDatabase * db = [FMDatabase databaseWithPath:sqlPath];
    
    if (![db open]) {
        NSLog(@"guygyu");
    }
    if (![db executeQuery:@"select * from SearchKeys"]) {
        [db executeUpdate:@"CREATE TABLE SearchKeys (key text PRIMARY KEY)"];
    }
    
    BOOL insert = [db executeUpdate:@"insert into  SearchKeys values (?)", key];
    
    if (insert) {
        NSLog(@"---------------");
    }
    
    
    [db close];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
