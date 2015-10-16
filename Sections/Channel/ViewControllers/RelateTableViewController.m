//
//  RelateTableViewController.m
//  LoveMovie
//
//  Created by laouhn on 15/9/18.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "RelateTableViewController.h"
#import "NetworkEngine.h"
#import "VideoModel.h"
#import "ILCollectionViewCell.h"
#import "PlayViewController.h"

#define KWIDTH self.view.frame.size.width
#define KHEIGHT self.view.frame.size.height
@interface RelateTableViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, retain) NSMutableArray * dataSourceAry;
@property (nonatomic, retain) UICollectionView * collectionView;
@property (nonatomic, retain) UICollectionViewFlowLayout * layout;


@end

@implementation RelateTableViewController


- (void)dealloc
{
    self.myId = nil;
    self.dataSourceAry = nil;
    self.collectionView = nil;
    self.layout = nil;
    [super dealloc];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
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
        self.collectionView = [[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, [NetworkEngine shareNetworkEngine].houHeight) collectionViewLayout:self.layout] autorelease];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.contentSize = CGSizeMake(375, 1000);
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[ILCollectionViewCell class] forCellWithReuseIdentifier:@"cells"];
    }
    return [[_collectionView retain] autorelease];
}

- (UICollectionViewFlowLayout *)layout
{
    if (_layout == nil) {
        self.layout = [[[UICollectionViewFlowLayout alloc] init] autorelease];
        _layout.itemSize = CGSizeMake((KWIDTH - 20) / 3, 250);
        _layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        _layout.minimumLineSpacing = 0;
        _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _layout.minimumInteritemSpacing = 0;
    }
    return [[_layout retain] autorelease];
}

- (void)setMyId:(NSNumber *)myId
{
    _myId = myId;
    [self getDataWithUrl];
}

#pragma mark - getData
- (void)getDataWithUrl
{
    NSString * urlString = [NSString stringWithFormat:@"http://api2.jxvdy.com/video_related?id=%@&count=6", [self.myId stringValue]];
    __block typeof(self) mySelf = self;
    [[NetworkEngine shareNetworkEngine] getInfoFromServerWithURLStr:urlString success:^(id response) {
        
        [mySelf dataParsingWithArray:response];
    } fail:^(NSError *error) {
        
        
    }];
}

- (void)dataParsingWithArray:(NSArray *)ary
{
    for (NSDictionary * dic in ary) {
        VideoModel * type = [[VideoModel alloc] init];
        [type setValuesForKeysWithDictionary:dic];
        [self.dataSourceAry addObject:type];
        [type release];
    }
    [self.collectionView reloadData];
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
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
     
    ILCollectionViewCell * videocell = (ILCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    PlayViewController * playerVC = [[PlayViewController alloc] init];
    playerVC.video = videocell.model;
    playerVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:playerVC animated:YES];
    [playerVC release];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
