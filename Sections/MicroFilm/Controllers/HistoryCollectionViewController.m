//
//  HistoryCollectionViewController.m
//  LoveMovie
//
//  Created by laouhn on 15/9/19.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "HistoryCollectionViewController.h"
#import "FMDB.h"
#import "VideoModel.h"
#import "VideoCollectionViewCell.h"
#import "VideoPlayerViewController.h"
#import "AFNetworking.h"
#import "PlayViewController.h"
#import "VideoController.h"
@interface HistoryCollectionViewController ()

@property (nonatomic, retain) NSMutableArray * dataSource;
@property (nonatomic, assign) int           state;

@end

@implementation HistoryCollectionViewController

static NSString * const reuseIdentifier = @"Cell";


- (void)dealloc
{
    self.dataSource = nil;
    
    [super dealloc];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.state = 0;

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStyleDone target:self action:@selector(deleteItemForButton:)];
    
    self.navigationItem.title = @"历史记录";
    [self.collectionView registerClass:[VideoCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];

    [self getVideoFromSql];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        
        self.dataSource = [@[] mutableCopy];
        
    }
    
    return [[_dataSource retain] autorelease];
}

- (void)getVideoFromSql
{
    
    NSString * docPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];

  
    NSString * dbpath = [docPath stringByAppendingPathComponent:@"data.sqlite"];
    
    
    FMDatabase * db = [FMDatabase databaseWithPath:dbpath];
    
    [db open];
    
    
    
    if (![db open]) {
        NSLog(@"Open database failed");
        return;
    }
    
   //插入数据
    FMResultSet * result  = [db executeQuery:@"select * from video"];
//    _video.img,
//    _video.title, _video.videoID , _video.descript, _video.score, _video.time
    while([result next]) {
        VideoModel * video = [[VideoModel alloc] init];
        
        video.title = [result stringForColumn:@"title"];
        video.img = [result stringForColumn:@"img"];
        video.videoID = [NSNumber numberWithInt:[result intForColumn:@"videoID"]];
        video.descript = [result stringForColumn:@"descript"];
        video.score = [result stringForColumn:@"score"];
        video.time = [NSNumber numberWithInt:[result intForColumn:@"time"]];
        video.episode =[NSNumber numberWithInt:[result intForColumn:@"episode"]];
//        video.playableDuration = [result doubleForColumn:@"playableDuration"];
        [self.dataSource addObject:video];
        
        [video release];

    }
    
    [db close];
    
    [self.collectionView reloadData];
    
}


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
    

    
    VideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.video = self.dataSource[indexPath.row];

    
    
    
    return cell;
}

- (void)deleteItemForButton:(UIBarButtonItem *)bar
{

      NSArray * aryCells  = [self.collectionView visibleCells];
    
    if (_state == 0) {
        
        
        for (VideoCollectionViewCell * obj in aryCells) {
            UIButton * deleteBut = [UIButton buttonWithType:UIButtonTypeCustom];
            deleteBut.frame = CGRectMake(obj.frame.size.width - 50, 0, 50, 50);
            [deleteBut setTitle:@"X" forState:UIControlStateNormal];
            deleteBut.tag = 1000 + [self.dataSource indexOfObject:obj.video];
            [deleteBut.layer setCornerRadius:25];
            [deleteBut addTarget:self action:@selector(deleteItem:) forControlEvents:UIControlEventTouchUpInside];
            deleteBut.backgroundColor = [UIColor redColor];
            
            [obj addSubview:deleteBut];
            _state = 1;
        }
    }
    else
    {
        for (VideoCollectionViewCell * obj in aryCells) {
            
            UIButton * btu = (UIButton *)[obj.subviews lastObject];
            [btu removeFromSuperview];
            _state = 0;
        }
    }

}

- (void)viewDidDisappear:(BOOL)animated
{
    
}


- (void)deleteItem:(UIButton *)sender
{
   
     VideoCollectionViewCell * cell =  (VideoCollectionViewCell *)[sender superview];

    
    NSString * docPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    
    NSLog(@"%@", docPath);

    
    NSString * dbpath = [docPath stringByAppendingPathComponent:@"data.sqlite"];
    
    
    FMDatabase * db = [FMDatabase databaseWithPath:dbpath];
    
    [db open];
    
    
    
    if (![db open]) {
        NSLog(@"Open database failed");
        return;
    }

    
    NSString * query = [NSString stringWithFormat:@"DELETE FROM video WHERE videoID = %@ and episode = %@",[cell.video.videoID stringValue],  [(cell.video.episode ? cell.video.episode : 0) stringValue]];
    BOOL delete = [db executeUpdate: query];
    
    if (delete) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
    }
    
    [db close];
    

//    [self.dataSource removeObject:cell.video];
//    [self.collectionView reloadData];
    [self.dataSource removeAllObjects];
    [self getVideoFromSql];


}


#pragma mark <UICollectionViewDelegate>


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    VideoCollectionViewCell * videocell = (VideoCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if (!videocell.video.maxepisode) {
        
        PlayViewController * playerVC = [[PlayViewController alloc] init];
        playerVC.video = videocell.video;
        playerVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:playerVC animated:YES];
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
        [self.navigationController pushViewController:videoVC animated:YES];
        [videoVC release];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"rtyu");
    }];
    
}





/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

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
