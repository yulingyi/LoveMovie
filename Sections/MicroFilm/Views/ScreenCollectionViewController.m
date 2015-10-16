//
//  ScreenCollectionViewController.m
//  LoveMovie
//
//  Created by laouhn on 15/9/18.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "ScreenCollectionViewController.h"
#import "VideoCollectionViewCell.h"
#import "AFNetworking.h"
#import "MJRefresh.h"
#import "VideoPlayerViewController.h"
#import "VideoController.h"
#import "PlayViewController.h"
static int count = 0;
@interface ScreenCollectionViewController ()<UICollectionViewDelegateFlowLayout>


@property (nonatomic, copy) NSString * urlStr;

@end

@implementation ScreenCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [self.collectionView addLegendHeaderWithRefreshingBlock:^{
        
        count = 0;
        [self getDataByUrlStr:self.urlStr];

      
        [self.collectionView.header endRefreshing];
        
    }];
    

    [self.collectionView addLegendFooterWithRefreshingBlock:^{
       
        if (![[self.urlStr substringToIndex:36] isEqualToString:@"http://api2.jxvdy.com/drama_related?"]) {
            [self getDataByUrlStr:[NSString stringWithFormat:@"%@&offset=%d", self.urlStr, count]];
        
        }
        [self.collectionView.footer endRefreshing];
    }];
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[VideoCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    
    
    // Do any additional setup after loading the view.
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        self.dataSource = [@[] mutableCopy];
    }
    return [[_dataSource retain] autorelease];
}

- (void)getDataByUrlStr:(NSString *)str
{
//    self.dataSource = [@[] mutableCopy];
    self.urlStr = str;
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/plain",nil];
    
    __block ScreenCollectionViewController *selfBlock = self;
    
    [manager GET:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [selfBlock relaoveData:responseObject];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
    }];

    
}


- (void)relaoveData:(id)responseObject
{
    count ? nil : [_dataSource removeAllObjects];
    NSArray * dataArray = [NSArray arrayWithArray:responseObject];
    
    for (int i = 0; i < dataArray.count; i++) {
        
        NSDictionary * dic = dataArray[i];
        VideoModel * video = [[VideoModel alloc] init];
        
        [video setValuesForKeysWithDictionary:dic];
        
        [self.dataSource addObject:video];
        [video release];
       count ++;
    }
   
    
    [self.collectionView reloadData];
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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//#warning Incomplete method implementation -- Return the number of sections
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//#warning Incomplete method implementation -- Return the number of items in the section
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    VideoCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.video = self.dataSource[indexPath.row];
    return cell;
}


#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    VideoCollectionViewCell * videocell = (VideoCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if (!videocell.video.maxepisode) {
        
        PlayViewController * playerVC = [[PlayViewController alloc] init];
        playerVC.video = videocell.video;
        playerVC.hidesBottomBarWhenPushed = YES;
        [self.parentViewController.navigationController pushViewController:playerVC animated:YES];
        [playerVC release];
        

    }else
    {
    
    [self addressParser:videocell.video];

    }
    
}


- (void)addressParser:(VideoModel *)video
{
    
   
    NSString * str = [NSString stringWithFormat:@"http://api2.jxvdy.com/%@_info?token=&id=",(video.maxepisode ? @"drama" : @"video")];
    
    NSString * newUrlString = [str stringByAppendingString:[video.videoID stringValue]];
    NSLog(@"%@", newUrlString);
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/plain",nil];
    [manager GET:newUrlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        VideoModel * model = [[VideoModel alloc] init];
        [model setValuesForKeysWithDictionary:(NSDictionary *)responseObject];
        
        VideoController * videoVC = [[VideoController alloc] init];
        videoVC.video = model;
        videoVC.vid = [video.videoID stringValue];
        videoVC.hidesBottomBarWhenPushed = YES;
        [self.parentViewController.navigationController pushViewController:videoVC animated:YES];
        [videoVC release];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"rtyu");
    }];
    
}


// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}


/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
