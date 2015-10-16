//
//  TypeVideoViewController.m
//  LoveMovie
//
//  Created by laouhn on 15/9/18.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "TypeVideoViewController.h"
#import "NetworkEngine.h"
#import "VideoModel.h"
#import "ILCollectionViewCell.h"

#import "MJRefresh.h"
#import "FMDatabase.h"
#import "PlayViewController.h"
#define KWIDTH self.view.frame.size.width
#define KHEIGHT self.view.frame.size.height
@interface TypeVideoViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, retain) UICollectionView * collectionView;
@property (nonatomic, retain) UICollectionViewFlowLayout * layout;
@property (nonatomic, retain) NSMutableArray * dataSourceAry;
@property (nonatomic, assign) int pageCount;
@property (nonatomic, copy) NSString * urlString;
@property (nonatomic, assign) BOOL ISREFRESH;
@end

@implementation TypeVideoViewController

- (void)dealloc
{
    self.collectionView = nil;
    self.layout = nil;
    self.dataSourceAry = nil;
    self.urlString = nil;
    [super dealloc];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    // Do any additional setup after loading the view.
    
    self.pageCount = 0;
    
//    [self.collectionView addLegendHeaderWithRefreshingTarget:self refreshingAction:@select0or(LoadDataAgain)];
    
    [self.collectionView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(downLoadData)];
    
 }


#pragma mark - 加载数据

- (void)downLoadData
{
    self.ISREFRESH = NO;
    self.pageCount++;
    NSLog(@"%d", self.pageCount);
    NSString * newUrlString = [self.urlString stringByAppendingString:[NSString stringWithFormat:@"&offset=%d", self.pageCount * 15]];
    [self getDataWithURLString:newUrlString];
}

- (void)LoadDataAgain
{
    
    _ISREFRESH = YES;
    [self getDataWithURLString:self.urlString];

}



#pragma mark - lazyloading


- (NSMutableArray *)dataSourceAry
{
    if (_dataSourceAry == nil) {
        self.dataSourceAry = [@[] mutableCopy];
    }
    return [[_dataSourceAry retain] autorelease];
}

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        self.collectionView = [[[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:self.layout] autorelease];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[ILCollectionViewCell class] forCellWithReuseIdentifier:@"cells"];
        _collectionView.delegate = self;
    }
    return [[_collectionView retain] autorelease];
}

- (UICollectionViewFlowLayout *)layout
{
    if (_layout == nil) {
        self.layout = [[[UICollectionViewFlowLayout alloc] init] autorelease];
        _layout.itemSize = CGSizeMake((KWIDTH - 20) / 3, 250);
        _layout.minimumInteritemSpacing = 5;
        _layout.minimumLineSpacing = 5;
        _layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
     }
    return [[_layout retain] autorelease];
}

#pragma mark - getData
- (void)getDataWithURLString:(NSString *)str
{
    
    _ISREFRESH ? [self.dataSourceAry removeAllObjects] : nil;
    if (self.urlString == nil) {
        self.urlString = str;
    }
    __block typeof(self) mySelf = self;
    [[NetworkEngine shareNetworkEngine] getInfoFromServerWithURLStr:str success:^(id response) {
        [mySelf dataParsingWithArray:response];
    } fail:^(NSError *error) {
        NSLog(@"%@", error);
    }];
    
}


#pragma mark - parsingData
- (void)dataParsingWithArray:(NSArray *)response
{
    for (NSDictionary * dic in response) {
        VideoModel * type = [[VideoModel alloc] init];
        [type setValuesForKeysWithDictionary:dic];
        [self.dataSourceAry addObject:type];
        [type release];
    }
    [self.collectionView reloadData];
    [self.collectionView.footer endRefreshing];
    [self.collectionView.header endRefreshing];
}


#pragma mark - 代理方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSourceAry.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ILCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cells" forIndexPath:indexPath];
    cell.model = self.dataSourceAry[indexPath.row];
    [cell showHistory];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    ILCollectionViewCell * cell = (ILCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    PlayViewController * playerVC = [[PlayViewController alloc] init];
    playerVC.video = cell.model;
    playerVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:playerVC animated:YES];
    [playerVC release];
    

    
    
    /* 影片历史记录, 将看过的电影存入到数据库, 因为设置有主键,所以不用担心在历史记录中出现有相同的看过的影片, 在myHistoryCollectionViewController中从数据库中取出
    NSString * cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    
    NSString * dbPath = [cachePath stringByAppendingPathComponent:@"data.sqlite"];
    
    NSLog(@"%@", dbPath);
    FMDatabase * db = [FMDatabase databaseWithPath:dbPath];
    [db open];
    
    if (![db open]) {
        NSLog(@"asd");
        return;
    }
    [db executeUpdate:@"create table videoInformation(myDescription text, myId int primary key, img text, score text, time int, title text)"];
    BOOL insert = [db executeUpdate:@"insert into videoInformation values(?, ?, ?, ?, ?, ?)", cell.model.myDescription, cell.model.myId, cell.model.img, cell.model.score, cell.model.time, cell.model.title];
    if (!insert) {
        NSLog(@"Fail");
    }
    [db close];
    */
    

  
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
