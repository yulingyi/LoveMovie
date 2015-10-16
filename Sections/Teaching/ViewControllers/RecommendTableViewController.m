//
//  RecommendTableViewController.m
//  LoveMovie
//
//  Created by laouhn on 15/9/17.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "RecommendTableViewController.h"
#import "manyViewController.h"


@interface RecommendTableViewController ()<ImagesCollectionViewCellDeleage>

@property (nonatomic, retain) NSMutableArray * dataSourceAry;
@property (nonatomic, assign) int pageCount;
@property (nonatomic, copy) NSString * myUrlString;

@end

@implementation RecommendTableViewController

- (void)dealloc
{
    self.dataSourceAry = nil;
    self.myUrlString = nil;
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self firstLoadView];
    self.pageCount = 0;
    
    __block typeof(self) HeiSelf = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        
        [self.dataSourceAry removeAllObjects];
        [HeiSelf loadAgainData];

    }];
    
    __block typeof(self) mySelf = self;
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        
        self.pageCount++;
         NSLog(@"%d", self.pageCount);
        NSString * newUrlString = [self.myUrlString stringByAppendingString:[NSString stringWithFormat:@"&offset=%d", self.pageCount * 15]];
        [mySelf getUrl:newUrlString];
    }];
    
    [self.tableView registerClass:[RecommendTableViewCell class] forCellReuseIdentifier:@"cells"];
    
    ImagesCollectionViewCell * imagesView = [[[ImagesCollectionViewCell alloc] init] autorelease];
    imagesView.deleage = self;
    self.tableView.tableHeaderView = imagesView;
   
}

- (void)onClickWithRecommendModel:(NSNumber *)modelID
{
    ShowDetailViewController * detailVC = [[ShowDetailViewController alloc] init];
    detailVC.myId = modelID;
    [self.parentViewController.navigationController pushViewController:detailVC animated:YES];
    [detailVC release];
}
- (void)firstLoadView
{
    NSString * urlString = @"http://api2.jxvdy.com/search_list?model=tutorials&attr=2&direction=1&count=15&token=";
    self.myUrlString = urlString;
    GetDataWithUrl * url = [[[GetDataWithUrl alloc] init] autorelease];
    
    [url requestDataWithUrlString:urlString success:^(id data) {
        for (NSDictionary * dic in data) {
            RecommendModel * model = [[RecommendModel alloc] init] ;
            [model setValuesForKeysWithDictionary:dic];
            [self.dataSourceAry addObject:model];
            [model release];
        }
        [self.tableView reloadData];
        
    } fail:^(NSString *str) {
        
        
    }];

}

- (void)loadAgainData
{
    NSString * urlString = @"http://api2.jxvdy.com/search_list?model=tutorials&attr=2&direction=1&count=15&token=";
    GetDataWithUrl * url = [[[GetDataWithUrl alloc] init] autorelease];
    
    [url requestDataWithUrlString:urlString success:^(id data) {
        for (NSDictionary * dic in data) {
            RecommendModel * model = [[RecommendModel alloc] init] ;
            [model setValuesForKeysWithDictionary:dic];
            [self.dataSourceAry addObject:model];
            [model release];
        }
        [self.tableView reloadData];
        [self.tableView.header endRefreshing];
        
    } fail:^(NSString *str) {
        
        
    }];

}


#pragma  mark - lazyloading
- (NSMutableArray *)dataSourceAry
{
    if (_dataSourceAry == nil) {
        self.dataSourceAry = [@[] mutableCopy];
    }
    return [[_dataSourceAry retain] autorelease];
}


#pragma mark 方法实现
- (void)getUrl:(NSString *)newUrlString
{
    AFHTTPRequestOperationManager * manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/plain",nil];
    __block typeof(self) mySelf = self;
    [manger GET:newUrlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [mySelf dataParsingWith:responseObject];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"网络请求错误,请耐心等候" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alert dismissWithClickedButtonIndex:0 animated:YES];
        });
    }];
}

- (void)dataParsingWith:(NSArray *)responseObject
{
    for (NSDictionary * dic in responseObject) {
        RecommendModel * model = [[RecommendModel alloc] init];
        [model setValuesForKeysWithDictionary:dic];
        [self.dataSourceAry addObject:model];
        [model release];
    }
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.dataSourceAry.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    RecommendTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cells" forIndexPath:indexPath];
    cell.model = self.dataSourceAry[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ShowDetailViewController * detailVC = [[ShowDetailViewController alloc] init];
    detailVC.myId = [self.dataSourceAry[indexPath.row] imageId];
    [self.parentViewController.navigationController pushViewController:detailVC animated:YES];
    [detailVC release];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
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
