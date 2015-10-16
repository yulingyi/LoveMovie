//
//  ElectricNetworkViewController.m
//  LoveMovie
//
//  Created by laouhn on 15/9/17.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "ElectricNetworkViewController.h"
#import "TopCollectionReusableView.h"
#import "MoreNetWorkViewController.h"
#import "VideoModel.h"
#import "AFNetworking.h"
#import "ElectricNetWork.h"
#import "MicroFilmNetworkhelper.h"
#import "VideoCollectionViewCell.h"
#import "HeaderReusableView.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "VideoController.h"
#import "ScreenViewController.h"
#import "RootViewController.h"
#import "SearchViewController.h"
#import "HistoryCollectionViewController.h"



#define kCellIdentifier @"NETCELL"
#define kHeader @"Header"
#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height



@interface ElectricNetworkViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, retain) UICollectionView           * baseCollection;
@property (nonatomic, retain) UICollectionViewFlowLayout * layout;
@property (nonatomic, retain) NSMutableDictionary        * dataSourceDic;
@property (nonatomic, retain) NSArray                    * urlAry;



@end

@implementation ElectricNetworkViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.baseCollection = nil;
    self.layout = nil;
    self.dataSourceDic = nil;
    self.urlAry = nil;
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //停止刷新
    [self.baseCollection addLegendHeaderWithRefreshingBlock:^{
        [self.baseCollection.header endRefreshing];
    }];
    [self.view addSubview:self.baseCollection];
    
    
    self.urlAry = @[@"shuffing", @"update", @"excellent"];
    [UINavigationBar appearance].backgroundColor = [UIColor magentaColor];
    
    [self setNavigationItem];
 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStateChangeNET) name:@"WIFI" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStateChangeNET) name:@"IPHONE" object:nil];
    
    //加载菊花
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDAnimationFade;
    hud.labelText = @"加载中";
    
    [self netWorkHelper];

}
- (void)viewDidAppear:(BOOL)animated
{
    if (!_dataSourceDic.count) {
        [self netWorkHelper];
    }
}

- (void)networkStateChangeNET
{
    
    if (!_dataSourceDic.count) {
        [self netWorkHelper];
    }
}

#pragma mark -按钮

- (void)setNavigationItem
{
//    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"555"] style:UIBarButtonItemStyleDone target:self action:@selector(leftViewAction:)] autorelease];
//    
    
//    
//    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    
    
    UIView * view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 44)] autorelease];
    //    view.backgroundColor = [UIColor redColor];
    
    
    UIButton * screen = [UIButton buttonWithType:UIButtonTypeCustom];
    [screen setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
    screen.frame = CGRectMake(0, 0, 40, 44);
    [screen addTarget:self action:@selector(screenAction:) forControlEvents:UIControlEventTouchDown];
    [view addSubview:screen];
    
    UIButton * history = [UIButton buttonWithType:UIButtonTypeCustom];
    [history setImage:[UIImage imageNamed:@"history"] forState:UIControlStateNormal];
    history.frame = CGRectMake(40, 0, 40, 44);
    [history addTarget:self action:@selector(historyAction:) forControlEvents:UIControlEventTouchDown];
    [view addSubview:history];
    
    UIButton * search = [UIButton buttonWithType:UIButtonTypeCustom];
    [search setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    search.frame = CGRectMake(80, 0, 40, 44);
    [search addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchDown];
    [view addSubview:search];
    
    
    [screen addTarget:self action:@selector(touchUpAction:) forControlEvents:UIControlEventTouchUpInside];
    [history addTarget:self action:@selector(touchUpAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [search addTarget:self action:@selector(touchUpAction:) forControlEvents:UIControlEventTouchUpInside];
 
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    

//    UIBarButtonItem *  searchBar = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search"] style:UIBarButtonItemStyleDone target:self action:@selector(searchAction:)] autorelease];
//    
//    UIBarButtonItem * historyBar = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"history"] style:UIBarButtonItemStyleDone target: self action:@selector(historyAction:)] autorelease];
//    
//    UIBarButtonItem * screenBar = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"more"] style:UIBarButtonItemStyleDone target: self action:@selector(moreBarButtonClicked:)] autorelease];
//    
//    self.navigationItem.rightBarButtonItems  = @[searchBar,historyBar,screenBar];
}
- (void)touchUpAction:(UIButton *)sender
{
    sender.alpha = 1;
}

- (void)leftViewAction:(UIBarButtonItem *)sender
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
    layout.itemSize = CGSizeMake((kWidth - 20) / 3 , (kWidth - 20) / 3 * 1.5);
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


#pragma mark - NetWorkHelper
- (void)netWorkHelper
{
    NSString * shuffingUrl = @"http://api2.jxvdy.com/focus_pic?name=drama";
    NSString * updateUrl = @"http://api2.jxvdy.com/search_list?model=drama&order=time&direction=1&count=6";
    NSString * excellentUrl = @"http://api2.jxvdy.com/search_list?model=drama&order=random&attr=2&count=6";
    MicroFilmNetworkhelper * helper = [[MicroFilmNetworkhelper alloc] init];
    __block ElectricNetworkViewController * mySelf = self;
    [helper getDataSourceFormNetworkWithUrlString:shuffingUrl key:@"shuffing" success:^(NSMutableDictionary *dic) {
        [mySelf.dataSourceDic addEntriesFromDictionary:dic];
        [helper getDataSourceFormNetworkWithUrlString:updateUrl key:@"update" success:^(NSMutableDictionary *dic) {
            [mySelf.dataSourceDic addEntriesFromDictionary:dic];
            [helper getDataSourceFormNetworkWithUrlString:excellentUrl key:@"excellent" success:^(NSMutableDictionary *dic) {
                [mySelf.dataSourceDic addEntriesFromDictionary:dic];
                
                //刷新数据
                [self.baseCollection reloadData];
                //加载完成后, 隐藏菊花
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }];
        }];
    }];
}


#pragma mark - 按钮方法
- (void)moreBarButtonClicked:(UIBarButtonItem *)sender
{
    MoreNetWorkViewController * moreVC = [[MoreNetWorkViewController alloc] init];
    //隐藏标签视图
//    moreVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:moreVC animated:YES];
    [moreVC release];
}

#pragma mark - 懒加载
- (UICollectionView *)baseCollection
{
    if (_baseCollection == nil) {
        self.baseCollection = [[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight) collectionViewLayout:self.layout] autorelease];
        self.baseCollection.backgroundColor = [UIColor whiteColor];

        
        //注册collectionViewCell
        [self.baseCollection registerClass:[VideoCollectionViewCell class] forCellWithReuseIdentifier:kCellIdentifier];
        [self.baseCollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        //注册区头视图
        [self.baseCollection registerClass:[TopCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeader];
        [self.baseCollection registerClass:[HeaderReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderCell"];
        
        //给集合视图指定代理
        self.baseCollection.delegate = self;
        self.baseCollection.dataSource = self;
    }
    return [[_baseCollection retain] autorelease];
}


- (UICollectionViewFlowLayout *)layout
{
    if (_layout == nil) {
        self.layout = [[[UICollectionViewFlowLayout alloc] init] autorelease];
//        self.layout.itemSize = CGSizeMake((kWidth - 30) / 3, 200);
        //设置区头视图
        self.layout.headerReferenceSize = CGSizeMake(0, 10);
        self.layout.minimumInteritemSpacing = 5;;
    }
    return [[_layout retain] autorelease];
}

- (NSMutableDictionary *)dataSourceDic
{
    if (_dataSourceDic == nil) {
        self.dataSourceDic = [@{} mutableCopy];
    }
    return [[_dataSourceDic retain] autorelease];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section) {
        NSArray * urlAry = @[@"最近更新", @"佳作推荐"];
        HeaderReusableView * header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"HeaderCell" forIndexPath:indexPath];
        header.titleSectionLabel.text = urlAry[indexPath.section - 1];
        return header;
    }
        TopCollectionReusableView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kHeader forIndexPath:indexPath];
    headerView.videos = self.dataSourceDic[@"shuffing"];
    headerView.target = self;
    headerView.action = @selector(addressParser:);
        return headerView;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section) {
        return CGSizeMake(kWidth, 40);
    }
    return CGSizeMake(kWidth, 180);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section) {
        return CGSizeMake((kWidth - 10) / 3 , (kWidth - 10) / 3 * 2);
    }
    return CGSizeMake(1, 1);
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSourceDic.count ? 6 :0;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    if (indexPath.section) {
        VideoCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
        cell.video = self.dataSourceDic[self.urlAry[indexPath.section]][indexPath.row];
        return cell;
    }
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self addressParser:self.dataSourceDic[self.urlAry[indexPath.section]][indexPath.row]];
}
- (void)addressParser:(VideoModel *)video
{
    
    NSString * newUrlString = [@"http://api2.jxvdy.com/drama_info?token=&id=" stringByAppendingString:[video.videoID stringValue]];
    NSLog(@"%@", newUrlString);
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/plain",nil];
    [manager GET:newUrlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        VideoModel * model = [[VideoModel alloc] init];
        [model setValuesForKeysWithDictionary:(NSDictionary *)responseObject];

        VideoController * videoVC = [[[VideoController alloc] init] autorelease];
        videoVC.video = model;
        videoVC.video.img = video.img;
        videoVC.video.videoID = video.videoID;
        videoVC.video.episode = [NSNumber numberWithInt:1];
        videoVC.vid = [video.videoID stringValue];
        videoVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:videoVC animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"rtyu");
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
