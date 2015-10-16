//
//  MicroFilmViewController.m
//  LoveMovie
//
//  Created by laouhn on 15/9/16.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "MicroFilmViewController.h"
#import "TopCollectionReusableView.h"
#import "VideoCollectionViewCell.h"
#import "HeaderCollectionReusableView.h"
#import "MicroFilmNetworkhelper.h"
#import "MBProgressHUD.h"
#import "FMDB.h"
#import "MJRefresh.h"
#import "ScreenViewController.h"
#import "SearchViewController.h"
#import "VideoPlayerViewController.h"
#import "HistoryCollectionViewController.h"
#import "RootViewController.h"
#import "LoginViewController.h"
#import "DownLoadTableViewController.h"
#import "VideoController.h"
#import "AFNetworking.h"
#import "PlayViewController.h"
#import "AppDelegate.h"
#import "SettingViewController.h"
#define KWIDTH [UIScreen mainScreen].bounds.size.width
//#define KHIGHT [UIScreen mainScreen].bounds.size.height
@interface MicroFilmViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, retain) UICollectionView * collectionView;
@property (nonatomic, retain) NSMutableDictionary * dataSource;
@property (nonatomic, retain) UICollectionViewFlowLayout * layout;

@property (nonatomic, copy)  NSArray * urlAry;
@property (nonatomic, assign)  BOOL  networkState;
@property (nonatomic, copy) NSArray  * titleSection;
@end

@implementation MicroFilmViewController
-(void)dealloc
{
    self.collectionView = nil;
    self.dataSource = nil;
    self.layout = nil;
    self.urlAry = nil;
    self.titleSection = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (!_dataSource.count) {
        [self networkHelper];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
     [self setNavigationItem];
    
   
        [self.collectionView addLegendHeaderWithRefreshingBlock:^{
        
        if (self.networkState) {
            [self networkHelper];
        }
        [self.collectionView.header endRefreshing];
        
    }];

    [self.view addSubview:self.collectionView];

    
    
     self.urlAry = @[];
    self.titleSection = @[@"佳作推荐",@"国内佳作",@"国外佳作"];
   
    
    //菊花放的位置, 放在数据请求之前
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //菊花的类型, 4种
    hud.mode=MBProgressHUDAnimationFade;//枚举类型不同的效果
    //菊花显示的文字
    hud.labelText=@"loading";

    


    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStateChangeNONET) name:@"NONETWORK" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStateChangeNET) name:@"WIFI" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStateChangeNET) name:@"IPHONE" object:nil];

        [self networkHelper];


    
    
    
    // Do any additional setup after loading the view.
}
- (void)networkStateChangeNET
{
    if (!_dataSource.count) {
         [self networkHelper];
    }
    
}

- (void)networkStateChangeNONET
{
    NSLog(@"-----------");
    
    UIAlertView * alter = [[UIAlertView alloc] initWithTitle:@"没有网络" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];

    [alter show];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alter dismissWithClickedButtonIndex:0 animated:YES];
    });
    
    [alter release];
    
    
  
}
#pragma mark ---

- (void)setNavigationItem
{
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"555"] style:UIBarButtonItemStyleDone target:self action:@selector(leftViewAction:)] autorelease];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];

    
    UIView * view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 44)] autorelease];
//    view.backgroundColor = [UIColor redColor];
    
    
    UIButton * screen = [UIButton buttonWithType:UIButtonTypeCustom];
    [screen setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
    screen.frame = CGRectMake(0, 0, 40, 44);
    
    [screen addTarget:self action:@selector(screenAction:) forControlEvents:UIControlEventTouchDown];
    [screen addTarget:self action:@selector(touchUpAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:screen];
    
    UIButton * history = [UIButton buttonWithType:UIButtonTypeCustom];
    [history setImage:[UIImage imageNamed:@"history"] forState:UIControlStateNormal];
    history.frame = CGRectMake(40, 0, 40, 44);
    [history addTarget:self action:@selector(historyAction:) forControlEvents:UIControlEventTouchDown];
    [history addTarget:self action:@selector(touchUpAction:) forControlEvents:UIControlEventTouchUpInside];

    [view addSubview:history];

    UIButton * search = [UIButton buttonWithType:UIButtonTypeCustom];
    [search setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    search.frame = CGRectMake(80, 0,40, 44);
    [search addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchDown];
    [search addTarget:self action:@selector(touchUpAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:search];

    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    
    
    
    
    
    
    
//    
//    UIBarButtonItem *  searchBar = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search"] style:UIBarButtonItemStyleDone target:self action:@selector(searchAction:)] autorelease];
//   
//    
//
//
//    UIBarButtonItem * historyBar = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"history"] style:UIBarButtonItemStyleDone target: self action:@selector(historyAction:)] autorelease];
//    
//
//    UIBarButtonItem * screenBar = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"more"] style:UIBarButtonItemStyleDone target: self action:@selector(screenAction:)] autorelease];
//
//      self.navigationItem.rightBarButtonItems  = @[searchBar,historyBar,screenBar];

}

- (void)touchUpAction:(UIButton *)sender
{
     sender.alpha = 1;
}
- (void)leftViewAction:(UIButton *)sender
{
    
    
    RootViewController * rootVC = (RootViewController *)self.tabBarController.parentViewController;
    
    rootVC.isOpen ? [rootVC closeLeftView] : [rootVC openLeftView];
    
  
    
}

- (void)screenAction:(UIButton *)sender
{
     sender.alpha = 0.2;
    
    ScreenViewController * screentVC = [[ScreenViewController alloc] init];
    
    [self.navigationController pushViewController:screentVC animated:YES];
    
    [screentVC release];
   

}


- (void)historyAction:(UIButton *)sender
{
 sender.alpha = 0.2;
    UICollectionViewFlowLayout * layout = [[[UICollectionViewFlowLayout alloc] init] autorelease];
    
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumInteritemSpacing = 5;
    layout.itemSize = CGSizeMake((KWIDTH - 20) / 3 , (KWIDTH - 20) / 3 * 1.5);
    layout.sectionInset = UIEdgeInsetsMake(20, 5, 0, 5);
    HistoryCollectionViewController * historyVC = [[HistoryCollectionViewController alloc] initWithCollectionViewLayout:layout];
    
    [self.navigationController pushViewController:historyVC animated:YES];
    
    [historyVC release];
    


    
}
- (void)searchAction:(UIButton *)sender
{
 
 sender.alpha = 0.2;
    SearchViewController * searchVC = [[SearchViewController alloc] init];
    
    [self.navigationController pushViewController:searchVC animated:YES];
    
    [searchVC release];
    
   


}
#pragma mark --

- (NSMutableDictionary *)dataSource
{
    if (!_dataSource) {
        self.dataSource = [@{} mutableCopy];
    }
    return [[_dataSource retain] autorelease];
}

- (UICollectionViewFlowLayout *)layout
{
    if (!_layout) {
        self.layout = [[[UICollectionViewFlowLayout alloc] init] autorelease];
        
        _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _layout.minimumInteritemSpacing = 5;
        
        
    }
    return [[_layout retain] autorelease];
}
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        self.collectionView = [[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) collectionViewLayout:self.layout] autorelease];
        self.collectionView.showsVerticalScrollIndicator = NO;
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.backgroundColor = [UIColor whiteColor];
        [self.collectionView registerClass:[VideoCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"oneSection"];
        
        [self.collectionView registerClass:[TopCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"topHeader"];
        
        [self.collectionView registerClass:[HeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
        
    }
    
    return [[_collectionView retain] autorelease];
    
}

#pragma mark-- UICollectionViewDataSource,UICollectionViewDelegate


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 4;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.dataSource.count ? 6 : 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section ) {
        VideoCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        cell.video = self.dataSource[self.urlAry[indexPath.section]][indexPath.row];
  
        return cell;
    }
    
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"oneSection" forIndexPath:indexPath];
    return cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
    return section  ? CGSizeMake(KWIDTH, 40) : CGSizeMake(KWIDTH, 180);
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section ? CGSizeMake((KWIDTH - 10) / 3 , (KWIDTH - 10) / 3 * 2) : CGSizeMake(1, 1);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section) {
        HeaderCollectionReusableView * header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        
        header.leftLabel.text = self.titleSection[indexPath.section - 1];
        return header;
    }
    
    TopCollectionReusableView * TopHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"topHeader" forIndexPath:indexPath];
    TopHeader.videos = self.dataSource[@"topHeader"];
  
    TopHeader.target = self;
    TopHeader.action = @selector(addressParser:);
    return TopHeader;
}

- (void)addressParser:(VideoModel *)video
{
    PlayViewController * playerVC = [[PlayViewController alloc] init];
    playerVC.video = video;
    playerVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:playerVC animated:YES];
    [playerVC release];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    VideoCollectionViewCell * videocell = (VideoCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    PlayViewController * playerVC = [[PlayViewController alloc] init];
    playerVC.video = videocell.video;
    playerVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:playerVC animated:YES];
    [playerVC release];

    
    
    
}



#pragma mark ----

//网络请求数据
- (void)networkHelper
{
    
    self.dataSource = nil;

    //轮播图链接
    NSString * url = @"http://api2.jxvdy.com/focus_pic?name=video";
    //内地链接
    NSString * inlandVideoUrl = @"http://api2.jxvdy.com/search_list?model=video&zone=23&order=random&count=6&attr=2";
    //国外链接
    NSString * foreignVideoUrl = @"http://api2.jxvdy.com/search_list?model=video&zone=24&order=random&count=6&attr=2";
    //佳作推荐
    NSString * goodVideoUrl =  @"http://api2.jxvdy.com/search_list?model=video&order=time&direction=1&count=6&attr=2";
    
    self.urlAry = @[@"topHeader", @"goodVideo", @"inlanVideo", @"foreignVideo"];
    MicroFilmNetworkhelper * helper = [[[MicroFilmNetworkhelper alloc] init] autorelease];
    
    __block MicroFilmViewController * selfBlock = self;
    [helper getDataSourceFormNetworkWithUrlString:url key:@"topHeader" success:^(NSMutableDictionary *dic) {
        
        [selfBlock.dataSource addEntriesFromDictionary:dic];
        
        [helper getDataSourceFormNetworkWithUrlString:inlandVideoUrl key:@"inlanVideo" success:^(NSMutableDictionary *dic) {
            
            [selfBlock.dataSource addEntriesFromDictionary:dic];
            [helper getDataSourceFormNetworkWithUrlString:foreignVideoUrl key:@"foreignVideo" success:^(NSMutableDictionary *dic) {
                [selfBlock.dataSource addEntriesFromDictionary:dic];
                [helper getDataSourceFormNetworkWithUrlString:goodVideoUrl key:@"goodVideo" success:^(NSMutableDictionary *dic) {
                    [selfBlock.dataSource addEntriesFromDictionary:dic];
                    [selfBlock.collectionView reloadData];
                    
                    

//                    //请求数据完成之后, 让菊花消失
                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                    //请求数据完成之后, 延迟多少秒之后消失
//                    [hud hide:YES afterDelay:0.5];
//                    hud.labelText = @"加载完成";

                }];
            }];
        }];
        
    }];
    
  
}


#pragma mark ---

- (void)actionFromLeftView:(NSInteger)i
{
    switch (i) {
        
       
        case 0:
        {
            HistoryCollectionViewController * historyVC = [[HistoryCollectionViewController alloc] initWithCollectionViewLayout:[self getLayout]];
            [self.navigationController pushViewController:historyVC animated:YES];
            [historyVC release];
            
        }
            
            break;
        case 1:
        {
            SettingViewController * settingVC = [[SettingViewController alloc] init];
            [self.navigationController pushViewController:settingVC animated:YES];
            settingVC.str = @"免责声明";
            
            [settingVC release];
            
        }
            
            
            break;
            
        case 4:
        {
            SettingViewController * settingVC = [[SettingViewController alloc] init];
            [self.navigationController pushViewController:settingVC animated:YES];
            settingVC.str = @"联系我们";
            
            [settingVC release];
            
        }
            
            break;
            
            
        case 5:
        {
            SettingViewController * settingVC = [[SettingViewController alloc] init];
            [self.navigationController pushViewController:settingVC animated:YES];
            settingVC.str = @"关于我们";
            
            [settingVC release];
            
        }
            
            
            break;

        default:
            break;
    }
}
- (UICollectionViewFlowLayout *)getLayout
{
    
    UICollectionViewFlowLayout * layout = [[[UICollectionViewFlowLayout alloc] init] autorelease];
    
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumInteritemSpacing = 5;
    layout.itemSize = CGSizeMake((KWIDTH - 20) / 3 , 200);
    layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
    return layout;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
