//
//  ChanelViewController.m
//  LoveMovie
//
//  Created by laouhn on 15/9/17.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "ChanelViewController.h"
#import "ButtonView.h"
#import "MoreButtonView.h"
#import "TypeVideoViewController.h"
#import "MJRefresh.h"
#import "FMDatabase.h"




#define KWIDTH self.view.frame.size.width
#define KHIGHT self.view.frame.size.height
@interface ChanelViewController ()<MoreButtonViewDelegate, ButtonViewDelegate>


@property (nonatomic, retain) UICollectionViewFlowLayout * layout;

@end

@implementation ChanelViewController

- (void)dealloc
{
    self.layout = nil;
    [super dealloc];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

  
    ButtonView * buttonView = [[ButtonView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 50)] ;
    buttonView.delegate = self;
    [self.view addSubview:buttonView];
    [buttonView release];

    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64 + buttonView.frame.size.height + 50, KWIDTH, KHIGHT - 50 - 100 - 49)];
    [self.view addSubview:scrollView];
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, scrollView.frame.size.height * 1.5);
    
    MoreButtonView * more = [[MoreButtonView alloc] initWithFrame:CGRectMake(0, 0, scrollView.frame.size.width, self.view.frame.size.height)];
    more.delegate = self;
    [scrollView addSubview:more];
    [more release];
    
}


#pragma mark - button代理方法
- (void)getClickedButton:(UIButton *)button
{
    NSString * urlString = [NSString stringWithFormat:@"http://api2.jxvdy.com/search_list?model=video&direction=1&count=15&order=time&type=%ld", (button.tag - 999)];
    TypeVideoViewController * typeView = [[TypeVideoViewController alloc] init];
    typeView.navigationItem.title = button.titleLabel.text;
    [typeView getDataWithURLString:urlString];
    [self.navigationController pushViewController:typeView animated:YES];
    [typeView release];

}

#pragma mark - 三种button代理方法
- (void)buttonClicked:(UIButton *)sender
{
    NSArray * urlAry = @[@"time", @"hits", @"like"];
    NSString * url = [NSString stringWithFormat:@"http://api2.jxvdy.com/search_list?model=video&direction=1&count=15&order=%@", urlAry[sender.tag - 1000]];
    TypeVideoViewController * typeView = [[TypeVideoViewController alloc] init];
    typeView.navigationItem.title = sender.titleLabel.text;
    [typeView getDataWithURLString:url];
    [self.navigationController pushViewController:typeView animated:YES];
    [typeView release];

}

- (UICollectionViewFlowLayout *)layout
{
    if (!_layout) {
        self.layout = [[[UICollectionViewFlowLayout alloc] init] autorelease];
        _layout.itemSize = CGSizeMake((self.view.frame.size.width - 20) / 3, (self.view.frame.size.height - 10) / 3);
        _layout.minimumInteritemSpacing = 5;
        _layout.minimumLineSpacing = 5;
        _layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        
    }
    return [[_layout retain] autorelease];
}


/*
//点击显示历史键响应的两个方法
#pragma lazyloading
- (UICollectionViewFlowLayout *)layout
{
    if (!_layout) {
        self.layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.itemSize = CGSizeMake((self.view.frame.size.width - 20) / 3, (self.view.frame.size.height - 10) / 3);
        _layout.minimumInteritemSpacing = 5;
        _layout.minimumLineSpacing = 5;
        _layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    }
    return [[_layout retain] autorelease];
}


#pragma mark -显示收藏历史
- (void)showHistory:(UIBarButtonItem *)sender
{
     
    myHistoryCollectionViewController * history = [[myHistoryCollectionViewController alloc] initWithCollectionViewLayout:self.layout];
    [self.navigationController pushViewController:history animated:YES];
    [history release];
}
*/

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
