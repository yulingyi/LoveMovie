//
//  LeftViewViewController.m
//  LoveMovie
//
//  Created by laouhn on 15/9/19.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "LeftViewViewController.h"
#import "RootViewController.h"
#define KWIDTH self.view.frame.size.width
#define KHIGHT self.view.frame.size.height
#import "HistoryCollectionViewController.h"
#import "UIImageView+WebCache.h"
#import "MicroFilmViewController.h"
#import "SDImageCache.h"
#import "NightTableViewCell.h"
@interface LeftViewViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) UITableView * baseTable;
@property (nonatomic, retain) UIImageView * iconImage;
@property (nonatomic, copy) NSArray * titleAry;
@property (nonatomic, retain) UIButton * loginBtu;

@end

@implementation LeftViewViewController
- (void)dealloc
{
    [_baseTable release];
    [_iconImage release];
    [_loginBtu release];
    [super dealloc];
    
}


- (UITableView *)baseTable
{
    if (!_baseTable) {
        
        self.baseTable = [[[UITableView alloc] initWithFrame:CGRectMake(20, 60, self.view.frame.size.width - 140 , 408) style:UITableViewStylePlain] autorelease];
        _baseTable.dataSource = self;
        _baseTable.delegate = self;
        _baseTable.scrollEnabled = NO;

//        [_baseTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cells"];
        _baseTable.backgroundColor = [UIColor clearColor];
    }
    return [[_baseTable retain] autorelease];
}
- (UIImageView *)iconImage
{
    if (!_iconImage) {
        self.iconImage = [[[UIImageView alloc] initWithFrame:CGRectMake(20, 30, 100, 100)] autorelease];
        
        [_iconImage.layer setCornerRadius:50];
        _iconImage.clipsToBounds = YES;
       
        _iconImage.backgroundColor = [UIColor redColor];
        
    }
    return [[_iconImage retain] autorelease];
}
- (UIButton *)loginBtu
{
    if (!_loginBtu) {
        self.loginBtu = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginBtu.frame = CGRectMake(CGRectGetMaxX(self.iconImage.frame), CGRectGetMinY(self.iconImage.frame) + 50, 100, 40);
        [_loginBtu.layer setCornerRadius:5];
       
        [_loginBtu setTitle:@"登陆/注册" forState:UIControlStateNormal];
        
        [_loginBtu addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return [[_loginBtu retain] autorelease];
}


- (void)loginAction:(UIButton *)sender
{
    
    
    [[self getMicroFilmViewController] actionFromLeftView:-1];
    
}
- (void)swipeAction:(UISwipeGestureRecognizer *)gesture
{
    RootViewController * rootVC = (RootViewController *)self.parentViewController;
    
    rootVC.isOpen ? [rootVC closeLeftView] :[rootVC openLeftView];
}



- (void)viewDidLoad {
    [super viewDidLoad];
        [self.view addSubview:self.baseTable];
    
    
    
//    [self.view addSubview:self.iconImage];
//    [self.view addSubview:self.loginBtu];
//    
//    [self setName];
//    [self setImageByUrl];
      UISwipeGestureRecognizer * swip = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction:)] autorelease];
    swip.direction = UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swip];
//    self.titleAry = @[@"我的收藏", @"我的微影",@"我的教程", @"我的下载", @"观影记录",@"清除缓存"];
    self.titleAry = @[@"历史记录",@"免责声明", @"夜间模式", @"清除缓存", @"联系我们", @"关于我们"];

}

- (void)setName
{
    NSString * name = [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
    
    [_loginBtu setTitle:name ? name : @"登录/注册" forState:UIControlStateNormal];

}


- (void)setImageByUrl
{
    NSString  * url = [[NSUserDefaults standardUserDefaults] objectForKey:@"url"];
    
    url ?  [self.iconImage sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }]: [self.iconImage setImage:[UIImage imageNamed:@"load"]];
    
    
}
#pragma mark --


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section ? 2 : 4 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    if (indexPath.row == 2) {
        NightTableViewCell * cell = [[NightTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.text = self.titleAry[indexPath.row + indexPath.section * 4];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
//        cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    
    static NSString * cellIndentity = @"cells";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIndentity];

    
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentity] autorelease];
    }
    cell.textLabel.text = self.titleAry[indexPath.row + indexPath.section * 4];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
    if (indexPath.row == 3) {
        float size = [[SDImageCache sharedImageCache] getSize] / 1024.0;
        if(size > 1024){
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.1fM", size / 1024];
        }else
        {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.1fK", size];
        }
        
    }
    cell.accessoryType =  UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"%ld",indexPath.section * 5 + indexPath.row);
    
   
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ( indexPath.row == 3) {
        
        [[SDImageCache sharedImageCache] clearDisk];
//        [[SDImageCache sharedImageCache] clearMemory];
        
        [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:3 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        UIAlertView * alter = [[UIAlertView alloc] initWithTitle:@"缓存已清除" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        
        [alter show];
        
        
        
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alter dismissWithClickedButtonIndex:0 animated:YES];
        });
        
        [alter release];
        
        NSLog(@"清除缓存");
    }else  if(indexPath.row == 2)
    {
    
//        self.view.window.alpha = 0.5;
    
    }else{
        [[self getMicroFilmViewController] actionFromLeftView:indexPath.section * 4 + indexPath.row];
    }

    

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section ? 0 : 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0,  self.baseTable.frame.size.width,50)] autorelease];
    UILabel *lael = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0,  self.baseTable.frame.size.width,50)] autorelease];
    
    lael.text = @"设置";
    lael.textColor = [UIColor whiteColor];
    lael.textAlignment = NSTextAlignmentCenter;
    [view addSubview:lael];
    lael.backgroundColor = [UIColor clearColor];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section

{
    UIView * view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0,  self.baseTable.frame.size.width,50)] autorelease];
    
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (!section) {
        return @"设置";
    }
    return nil;
}
#pragma mark---


- (MicroFilmViewController *)getMicroFilmViewController
{
    RootViewController * rootVC = (RootViewController *)self.parentViewController;
    
    [rootVC closeLeftView];
    
    UITabBarController * tab = (UITabBarController *)rootVC.childViewControllers[0];
    UINavigationController * nav = tab.childViewControllers[0];
    return ((MicroFilmViewController *)nav.viewControllers[0]);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}



@end
