//
//  ScreenTableViewController.m
//  LoveMovie
//
//  Created by laouhn on 15/9/19.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "ScreenTableViewController.h"
#import "RecommendModel.h"
#import "RecommendTableViewCell.h"
#import "AFHTTPRequestOperationManager.h"
#import "MJRefresh.h"
#import "ShowDetailViewController.h"
@interface ScreenTableViewController ()
@property (nonatomic, copy) NSString * urlStr;
@end

@implementation ScreenTableViewController

- (void)dealloc
{
    self.urlStr = nil;
    self.dataSource =nil;
    
    [super dealloc];
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        self.dataSource = [@[] mutableCopy];
    }
    return [[_dataSource retain] autorelease];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.tableView registerClass:[RecommendTableViewCell class] forCellReuseIdentifier:@"cells"];
   
    
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        
        self.count = 0;
        [self getDataByUrlStr:self.urlStr];
        
        
        [self.tableView.header endRefreshing];
        
    }];
    
    
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        
        [self getDataByUrlStr:[NSString stringWithFormat:@"%@&offset=%d", self.urlStr, self.count]];
        
        
        [self.tableView.footer endRefreshing];
    }];
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    
    

    
}
- (void)getDataByUrlStr:(NSString *)str
{
    //    self.dataSource = [@[] mutableCopy];
    self.urlStr = str;
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/plain",nil];
    
    __block ScreenTableViewController *selfBlock = self;
    
    [manager GET:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [selfBlock relaoveData:responseObject];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
    }];
    
    
}


- (void)relaoveData:(id)responseObject
{
    NSArray * dataArray = [NSArray arrayWithArray:responseObject];
    
    for (int i = 0; i < dataArray.count; i++) {
        
        NSDictionary * dic = dataArray[i];
        RecommendModel * recommend = [[RecommendModel alloc] init];
        
        [recommend setValuesForKeysWithDictionary:dic];
        
        [self.dataSource addObject:recommend];
        [recommend release];
        self.count ++;
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
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   RecommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cells" forIndexPath:indexPath];
    
    cell.model = self.dataSource[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecommendTableViewCell * cell = (RecommendTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    ShowDetailViewController * showDetailVC = [[ShowDetailViewController alloc] init];
    showDetailVC.myId = cell.model.imageId;
    [self.parentViewController.navigationController pushViewController:showDetailVC animated:YES];
    [showDetailVC release];
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
