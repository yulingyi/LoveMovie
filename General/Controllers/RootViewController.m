//
//  RootViewController.m
//  LoveMovie
//
//  Created by laouhn on 15/9/19.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "RootViewController.h"
#import "LeftViewViewController.h"
#import "TabBarViewController.h"
#define KWIDTH [UIScreen mainScreen].bounds.size.width
#define KHIGHT [UIScreen mainScreen].bounds.size.height

@interface RootViewController ()

@property (nonatomic, retain) TabBarViewController * tabBar;
@property (nonatomic, retain) LeftViewViewController * leftView;
@property (nonatomic, retain) UIImageView * bgView;

@end

@implementation RootViewController

-(void)dealloc
{
    [_tabBar release];
    [_leftView release];
    [_bgView release];
    [super dealloc];
}

/**
 *  声明一个初始化方法
 */
-(id)init
{
    if (self = [super init]) {
        
        
        [self addChildViewController:self.tabBar];
        [self addChildViewController:self.leftView];
        
    }
    return self;
}
- (LeftViewViewController *)leftView
{
    if (!_leftView) {
        self.leftView = [[[LeftViewViewController alloc] init] autorelease];;
        _leftView.view.frame = CGRectMake(-KWIDTH + 100 , 0, KWIDTH - 200 , KHIGHT);
    }
    return [[_leftView retain] autorelease];
}

- (TabBarViewController *)tabBar
{
    if (!_tabBar) {
        
    
        self.tabBar = [[[TabBarViewController alloc] init] autorelease];
        self.tabBar.view.frame = self.view.frame;
    }
    return [[_tabBar retain] autorelease];
}

- (UIImageView *)bgView
{
    if (!_bgView) {
        self.bgView = [[[UIImageView alloc] initWithFrame:self.view.frame] autorelease];
        _bgView.image = [UIImage imageNamed:@"rootBG"];
        _bgView.userInteractionEnabled = YES;
    }
    return [[_bgView retain] autorelease];
}
- (void)viewDidLoad {
    [super viewDidLoad];

   
    [self.view addSubview:self.bgView];
    
    [self.view addSubview:self.tabBar.view];
    
    [self.view addSubview:self.leftView.view];
    
    self.isOpen = NO;
    // Do any additional setup after loading the view.
}




- (void)openLeftView
{

    [UIView animateWithDuration:0.5 animations:^{
         self.leftView.view.frame = CGRectMake(0, 0, KWIDTH, KHIGHT);
        self.tabBar.view.frame = CGRectMake(KWIDTH - 100, 60, KWIDTH, KHIGHT - 100);
        self.tabBar.view.alpha = 0.5;
        self.leftView.view.alpha = 1;
    }];
//    [self.leftView setName];
//    [self.leftView setImageByUrl];
    self.isOpen = YES;
    
}


- (void)closeLeftView
{
    [UIView animateWithDuration:0.5 animations:^{
        self.leftView.view.frame = CGRectMake(-KWIDTH, 0, KWIDTH, KHIGHT);
        self.tabBar.view.frame = self.view.bounds;
         self.tabBar.view.alpha = 1;
        self.leftView.view.alpha = 0.5;
    }];
    
    self.isOpen = NO;
    
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
