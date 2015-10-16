//
//  DownLoadTableViewController.m
//  LoveMovie
//
//  Created by laouhn on 15/9/21.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "DownLoadTableViewController.h"
#import "DownLoad_progressTableViewCell.h"
#import "VideoController.h"
#import "VideoModel.h"
#import <MediaPlayer/MediaPlayer.h>

#define DWONLOADING @"downLoading"
#define DWONLOADED  @"downLoaded"
#import "AFNetworking.h"
#import "NetworkEngine.h"
#import "VideoMPViewController.h"
@interface DownLoadTableViewController ()<DownLoad_progressTableViewCellDelegate>

@property (nonatomic, retain) AFHTTPRequestOperationManager * manager;
@property (nonatomic, retain) NSMutableArray * downLoadedAry;


@end

@implementation DownLoadTableViewController

- (void)dealloc
{
    [_manager release];
    [_downLoadedAry release];
    
    [super dealloc];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.manager = [NetworkEngine shareNetworkEngine].manger;
        self.downLoadedAry = [@[] mutableCopy];
        [self getVideoDownLoadedFromNSFileManager];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.navigationItem.title = @"下载";
//    [self.tableView registerClass:[DownLoad_progressTableViewCell class] forCellReuseIdentifier:DWONLOADING];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:DWONLOADED];
    
    
    
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarAction:)] autorelease];
  
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section)
    {
        
        NSString * VideoName =[tableView cellForRowAtIndexPath:indexPath].textLabel.text;;
        
        
        NSString * cachePath  = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        
        NSString * downLoadWithVideoPath = [cachePath stringByAppendingPathComponent:@"DownLoadWithVideo"];
        
        NSString * videoPath = [downLoadWithVideoPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4", VideoName]];
        
        
        
       VideoMPViewController * playerVC = [[VideoMPViewController alloc] initWithContentURL:[NSURL fileURLWithPath:videoPath]];
        
        
        [self presentMoviePlayerViewControllerAnimated:playerVC];
        
        [playerVC release];
        
        
        
        
    }
    
    
}

- (void)rightBarAction:(UIBarButtonItem *)sender

{
    self.tableView.editing = !self.tableView.isEditing;
    [sender setTitle:self.tableView.isEditing ? @"取消" : @"删除"];
}

- (void)getVideoDownLoadedFromNSFileManager
{
    NSString * cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    
    NSString * downLoadedVideo = [cachePath stringByAppendingPathComponent:@"DownLoadWithVideo"];
    NSArray * fileAry = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:downLoadedVideo error:nil];
    for (NSString * filePath in fileAry) {
        NSString * fileType = [filePath pathExtension];
        
        if ([fileType isEqualToString:@"mp4"]) {
            
            [self.downLoadedAry addObject:[[filePath lastPathComponent]  stringByDeletingPathExtension]];
        }
    }
    
    
}

- (void)reloadData:(NSString *)videoName
{
    
    
    NSString * cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString * downLoadDicCacheWithVideo = [cachePath stringByAppendingPathComponent:@"DownLoadChacheWithVideo"];
    
    
    NSString * downLoadDicWithVideo = [cachePath stringByAppendingPathComponent:@"DownLoadWithVideo"];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:downLoadDicWithVideo]) {
        
        [fileManager createDirectoryAtPath:downLoadDicWithVideo  withIntermediateDirectories:YES attributes:nil error:nil];
        
    }
    
    if ([fileManager fileExistsAtPath:downLoadDicWithVideo]) {
        NSString * videoPath = [downLoadDicCacheWithVideo stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",videoName]];
        if (videoPath) {
            [fileManager moveItemAtPath:videoPath toPath:[downLoadDicWithVideo stringByAppendingPathComponent:[videoPath lastPathComponent]] error:nil];
        }
        
    }
    
    
    
    
    self.downLoadedAry = [@[] mutableCopy];
    [self getVideoDownLoadedFromNSFileManager];

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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    NSLog(@"%@", self.manager.operationQueue.operations);
    //    NSLog(@"%ld, %@", self.manager.operationQueue.operations.count, self.manager.operationQueue.operations[0]);
    return section ? self.downLoadedAry.count : self.manager.operationQueue.operations.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.section) {
        
        NSString * cellIndentity =[NSString stringWithFormat:@"indentity%ld%ld", indexPath.section, indexPath.row];
        
        DownLoad_progressTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIndentity];
        
        if (!cell) {
            cell = [[DownLoad_progressTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentity];
        }
        
        cell.delegate = self;
        
        cell.operation = self.manager.operationQueue.operations[indexPath.row];
        
        return cell;
    }
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:DWONLOADED];
    
    cell.textLabel.text = self.downLoadedAry[indexPath.row];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section ? 44 : 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (!section) {
        NSLog(@"%ld",self.manager.operationQueue.operations.count);
        return self.manager.operationQueue.operations.count ? 40 : 0;
    }else
        return self.downLoadedAry.count ? 40 : 0;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return section ? @"已下载" : @"正在下载";
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  UITableViewCellEditingStyleDelete;
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle ==UITableViewCellEditingStyleDelete) {//如果编辑样式为删除样式
        
        if (!indexPath.section) {
            
            DownLoad_progressTableViewCell * cell = (DownLoad_progressTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];

            [self deleteFile:cell.operation.video.title dic:@"DownLoadChacheWithVideo"];
            

            
               [cell.operation cancel];
            [tableView reloadData];
//            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
         
        }else
        {
          [self deleteFile:self.downLoadedAry[indexPath.row] dic:@"DownLoadWithVideo"];
         [self.downLoadedAry removeObjectAtIndex:indexPath.row];//移除数据源的数据
         [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];//移除tableView中的数据
        }
    }
}

- (void)deleteFile:(NSString *)str dic:(NSString *)dic
{
    
    NSString * cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    
    NSString * dicPath = [cachePath stringByAppendingPathComponent:dic];
    
    NSString * videoPath = [dicPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",str]];
    [[NSFileManager defaultManager] removeItemAtPath:videoPath error:nil];
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
