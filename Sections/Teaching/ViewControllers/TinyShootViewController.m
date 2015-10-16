//
//  TinyShootViewController.m
//  LoveMovie
//
//  Created by laouhn on 15/9/22.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "TinyShootViewController.h"

@interface TinyShootViewController ()

@end

@implementation TinyShootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.urlString = @"http://api2.jxvdy.com/search_list?model=tutorials&attr=2&direction=1&count=15&type=15&token=";
    [self getUrl:self.urlString];
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
