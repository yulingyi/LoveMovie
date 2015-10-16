//
//  TabBarViewController.m
//  LoveMovie
//
//  Created by laouhn on 15/9/16.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "TabBarViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configInitModth];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}

- (void)configInitModth
{
    
    
    NSArray * titles = @[@"微电影",
                         @"网络剧",
                         @"教学",
                         @"频道",
                         @"动态"];
    NSArray * viewControllerName = @[@"MicroFilmViewController",
                                     @"ElectricNetworkViewController",
                                     @"TeachingViewController",
                                     @"ChanelViewController"];
    
    NSArray * images =  images = @[@"0",
                                   @"1",
                                   @"2",
                                   @"3"];
    
    
    NSMutableArray * navArray = [@[] mutableCopy];
    
    for (int i = 0; i < 4; i++) {
        
        UIViewController * VC =  [[NSClassFromString(viewControllerName[i]) alloc] init];
        
        VC.navigationItem.title = titles[i];
        
        UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:VC];
        nav.tabBarItem.image = [UIImage imageNamed:images[i]];
        VC.navigationController.tabBarItem.title = titles[i];
        [navArray addObject:nav];
        [VC release];
        [nav release];
        
    }
    
    self.viewControllers =  navArray;
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
