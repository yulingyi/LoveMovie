 //
//  DramaCourseTableViewController.m
//  LoveMovie
//
//  Created by laouhn on 15/9/17.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "DramaCourseTableViewController.h"
#import "manyViewController.h"


@interface DramaCourseTableViewController ()

@property (nonatomic, retain) NSMutableArray * dataSourceAry;
@property (nonatomic, assign) int pageCount;
@property (nonatomic, assign) BOOL ISREFRESH;

@end

@implementation DramaCourseTableViewController

- (void)dealloc
{
    self.dataSourceAry = nil;
    self.urlString = nil;
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.pageCount = 0;
    [self.tableView registerClass:[RecommendTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    
    __block typeof(self) headerSelf = self;
    [self.tableView addLegendHeaderWithRefreshingBlock:^{
        _ISREFRESH = YES;
               [headerSelf getUrl:self.urlString];
        [self.tableView.header endRefreshing];
    }];
    
    __block typeof(self) yoursSelf = self;
    [self.tableView addLegendFooterWithRefreshingBlock:^{
        self.pageCount++;
        _ISREFRESH = NO;
//        NSLog(@"111111 %ld", self.dataSourceAry.count);
        NSString * newUrlString = [self.urlString stringByAppendingString:[NSString stringWithFormat:@"&offset=%d", self.pageCount * 15]];
        [yoursSelf getUrl:newUrlString];
            [self.tableView.footer endRefreshing];
    }];
}

#pragma mark - lazyloading
- (NSMutableArray *)dataSourceAry
{
    if (_dataSourceAry == nil) {
        self.dataSourceAry = [@[] mutableCopy];
    }
    return [[_dataSourceAry retain] autorelease];
}

#pragma mark - 得到地址方法
- (void)getUrl:(NSString *)urlSring
{
    GetDataWithUrl * url = [[[GetDataWithUrl alloc] init] autorelease];
    __block typeof(self) mySelf = self;
    [url requestDataWithUrlString:urlSring success:^(id data) {
        
        [mySelf dataParsing:data];
    } fail:^(NSString *str) {
        
        
    }];
}

- (void)dataParsing:(NSArray *)data
{
    
    _ISREFRESH ? [self.dataSourceAry removeAllObjects] : nil;

    for (NSDictionary * dic in data) {
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
    
    RecommendTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = self.dataSourceAry[indexPath.row];
    
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ShowDetailViewController * detail = [[ShowDetailViewController alloc] init];
    detail.myId = [self.dataSourceAry[indexPath.row] imageId];
    [self.parentViewController.navigationController pushViewController:detail animated:YES];
    [detail release];
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
