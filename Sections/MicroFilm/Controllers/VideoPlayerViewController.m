 //
//  VideoPlayerViewController.m
//  LoveMovie
//
//  Created by laouhn on 15/9/18.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "VideoPlayerViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "detailModel.h"
#import "NetworkEngine.h"

#import "FMDB.h"
#import "AppDelegate.h"
#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"

@interface VideoPlayerViewController ()<UMSocialUIDelegate>




@property (nonatomic, retain) AFHTTPRequestOperationManager * manager;
@property (nonatomic, assign) double currenTime;
@property (nonatomic, assign) BOOL ISFULLSCREEN;
@end


@implementation VideoPlayerViewController


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [self updatePlayableDuration:_player.playableDuration];
    [_player stop];
    [_player release];
    
    
    [super dealloc];
}

- (void)action:(UIButton *)sender
{
    
    [self downloadVideoByVideoId:self.video];
    
}


- (MPMoviePlayerController *)player
{
    if (!_player) {
        self.player = [[[MPMoviePlayerController alloc] init] autorelease];
        self.player.repeatMode = MPMovieRepeatModeNone;
        //<4>MPMoviePlayerController视频播放器是一个视图控制器 上面有自带的视图 所以此处需要设置视图的现实位置及大小
        [self.player.view setFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, KHIGHT_VIEW * 0.4)];
        self.player.controlStyle = MPMovieControlStyleDefault;
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:_player.view animated:YES];
        //菊花的类型, 4种
        hud.mode=MBProgressHUDAnimationFade;//枚举类型不同的效果
        hud.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        //菊花显示的文字
        hud.labelText=@"loading";

        
        //<6>视频控制器没有回调方法 所以必须通过通知中心来检测视频播放器的变化 通知中心发送一些特殊字符串在控制视频播放器的操作
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishMovie:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoDidEnterFullscreen:) name:MPMoviePlayerDidEnterFullscreenNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isFull:) name:MPMoviePlayerWillEnterFullscreenNotification object:nil];
        

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoWillExitFullscreen:) name:MPMoviePlayerWillExitFullscreenNotification object:nil];
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stataChange:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideAllHUDs:) name:MPMovieSourceTypeAvailableNotification object:nil];

    }
    return [[_player retain] autorelease];
}


- (void)hideAllHUDs:(NSNotification *)notification
{
    [MBProgressHUD hideAllHUDsForView:_player.view animated:YES];
  
}

- (void)stataChange:(NSNotification *)notification
{
    
    switch (self.player.playbackState) {
        case MPMoviePlaybackStateInterrupted:
            //中断
            NSLog(@"中断");
            break;
        case MPMoviePlaybackStatePaused:
            //暂停
            NSLog(@"暂停");
        {

            [MBProgressHUD hideAllHUDsForView:_player.view animated:YES];
        }
            break;
        case MPMoviePlaybackStatePlaying:
        {
            //播放中
            
            [self saveVideoDetailToSql];
            NSLog(@"播放中");
              [MBProgressHUD hideAllHUDsForView:_player.view animated:YES];
           
        }
            break;
        case MPMoviePlaybackStateSeekingBackward:
            //后退
            NSLog(@"后退");
            break;
        case MPMoviePlaybackStateSeekingForward:
        {
            //快进
            
            MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:_player.view animated:YES];
            //菊花的类型, 4种
            hud.mode=MBProgressHUDAnimationFade;//枚举类型不同的效果
            hud.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];

            //菊花显示的文字
            hud.labelText=@"loading";
            NSLog(@"快进");
          }
            break;
        case MPMoviePlaybackStateStopped:
            //停止
            NSLog(@"停止");
            break;
            
            
        default:
            break;
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    if (_player) {
        [_player play];
    }

    
    [self.player pause];
}
-(void)setMPMoviePlayerController:(NSString *)urlVideo
{
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:_player.view animated:YES];
    //菊花的类型, 4种
    hud.mode=MBProgressHUDAnimationFade;//枚举类型不同的效果
    hud.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    //菊花显示的文字
    hud.labelText=@"loading";
    
    self.player.contentURL = [NSURL URLWithString:urlVideo];

    [self.player prepareToPlay];
   

    

    
    
    self.player.shouldAutoplay = NO;
//       _player.initialPlaybackTime = _video.playableDuration;
//     [MBProgressHUD hideAllHUDsForView:_player.view animated:YES];
    
}
- (void)isFull:(NSNotification *)notification
{
    _ISFULLSCREEN = YES;
}
- (void)videoDidEnterFullscreen:(NSNotification *)notification {// 开始播放
    
    AppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
    
    appDelegate.isFull = YES;
    
}


- (void)videoWillExitFullscreen:(NSNotification *)notification {//完成播放
    
    
    _ISFULLSCREEN = NO;
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    appDelegate.isFull =NO;
    
    
    
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        
        SEL selector = NSSelectorFromString(@"setOrientation:");
        
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        
        [invocation setSelector:selector];
        
        [invocation setTarget:[UIDevice currentDevice]];
        
        int val =UIInterfaceOrientationPortrait;
        
        [invocation setArgument:&val atIndex:2];
        
        [invocation invoke];
        
    }
}
-(void)finishMovie:(NSNotification *)notification
{
    
    
    
    NSLog(@"播放完成");
    
}


        

- (void)networkStateChange
{
    NSLog(@"-----------");
    
    UIAlertView * alter = [[UIAlertView alloc] initWithTitle:@"没有网络" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    
    [alter show];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alter dismissWithClickedButtonIndex:0 animated:YES];
    });
    
    [alter release];
    
}



- (void)viewWillDisappear:(BOOL)animated
{
 
    if (!_ISFULLSCREEN) {
        [_player pause];
     
    }
 
}

- (void)viewDidDisappear:(BOOL)animated
{

    NSLog(@"%f", _player.playableDuration);
    NSLog(@"%f", _player.endPlaybackTime);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStateChange) name:@"NONETWORK" object:nil];
  

    self.navigationItem.title = self.video.title;
    UIBarButtonItem * shareButton = [[[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(shareVideo:)] autorelease];
    
    
    
    self.navigationItem.rightBarButtonItem = shareButton;
    
//    UIBarButtonItem * downloadButton = [[UIBarButtonItem alloc] initWithTitle:@"下载" style:UIBarButtonItemStylePlain target:self action:@selector(action:)];
    
//    self.navigationItem.rightBarButtonItems = @[shareButton, downloadButton];
    [self.view addSubview:self.player.view];

    //    [self setMPMoviePlayerController:@"http://v.jxvdy.com/sendfile/HtllnIfFGTq3XmabyfWPCounoQD7D3kcZIdcWqFpFnA1jGSIuI6elcbCLcvW8ajBb4VW1igJrARoT_58jv8Roz6yV_t0sA"];
    //
    // Do any additional setup after loading the view.
}


- (void)shareVideo:(UIBarButtonItem *)sender
{
    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"5602838f67e58ecc55000a8b" shareText:[NSString stringWithFormat:@"%@视频详情地址%@", self.video.title, self.video.videoURL] shareImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.video.img] ]] shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren, UMShareToQzone, UMShareToWechatTimeline,nil] delegate:self];
    [UMSocialQQHandler setQQWithAppId:@"1104805529" appKey:@"YruZEO4J0L6Yui0o" url:self.video.videoURL];
    [UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskAll];
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}


#pragma mark --- 下载电影
- (void)downloadVideoByVideoId:(VideoModel *)video
{
    
    
    self.manager = [NetworkEngine shareNetworkEngine].manger;
    
    
    NSString * cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSLog(@"沙盒路径%@", cachePath);
    
    
    NSLog(@"%@", cachePath);
    NSString * downLoadDicCacheWithVideo = [cachePath stringByAppendingPathComponent:@"DownLoadChacheWithVideo"];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:downLoadDicCacheWithVideo]) {
        [fileManager createDirectoryAtPath:downLoadDicCacheWithVideo withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString * videoPath = [downLoadDicCacheWithVideo stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4",_video.title]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:videoPath]) {
        UIAlertView * alterView = [[UIAlertView alloc] initWithTitle:@"视频已存在" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        
        
        [alterView show];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alterView dismissWithClickedButtonIndex:0 animated:YES];
        });
        [alterView release];
    }else{
        NSURL * url = [NSURL URLWithString:video.videoURL];
        
        //    NSURL * url = [NSURL URLWithString:video.videoURL];
        //
        //        NSURL * url = [NSURL URLWithString:@"http://v.jxvdy.com/sendfile/HtllnIfFGTq3XmabyfWPCounoQD7D3kcZIdcWqFpFnA1jGSIuI6elcbCLcvW8ajBb4VW1igJrARoT_58jv8Roz6yV_t0sA"];
        
        NSURLRequest * request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:-1];
        AFHTTPRequestOperation * operation = [[[AFHTTPRequestOperation alloc] initWithRequest:request] autorelease];
        
        operation.outputStream = [[[NSOutputStream alloc] initToFileAtPath:videoPath append:YES] autorelease];
        operation.name = _video.title;
        
        //    __block typeof(self) mySelf = self;
        [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
            
            float readed = (float)totalBytesRead / totalBytesExpectedToRead;
            
            _video.current = readed;
            
            NSLog(@"%f",readed);
        }];
        operation.video = self.video;
        
        //1.开启该任务
        //第一种方法
        //    [operation start];
        NSString * docPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
        
        NSLog(@"%@", docPath);
        [self.manager.operationQueue addOperation:operation];
        
        NSLog(@"%@", self.manager.operationQueue.operations);
        
        
    }
}

#pragma mark -- 播放视屏存到sql


- (void)saveVideoDetailToSql
{
    self.currenTime = _player.currentPlaybackTime;
    NSString * docPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    
    NSLog(@"%@", docPath);
    
    NSString * dbpath = [docPath stringByAppendingPathComponent:@"data.sqlite"];
    
    
    FMDatabase * db = [FMDatabase databaseWithPath:dbpath];
    
    [db open];
    
    
    
    if (![db open]) {
        NSLog(@"Open database failed");
        return;
   
    }
//    
//    [db executeUpdate:@"CREATE TABLE video (img text,  title text, videoID int, descript text, score text, time int, episode int, playableDuration double,PRIMARY KEY(videoID, episode, time))"];
    
        [db executeUpdate:@"CREATE TABLE video (img text,  title text, videoID int, descript text, score text, time int, episode int,PRIMARY KEY(videoID, episode, time))"];
    //
    //插入数据
    BOOL insert = [db executeUpdate:@"insert into video values (?,?,?,?,?,?,?)", _video.img,
                   _video.title, _video.videoID , _video.descript, _video.score, _video.time, (_video.episode ? _video.episode :[NSNumber numberWithInt:0])];
    
    if (insert) {
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"保存成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        //        [alert show];
        //        [alert release];˜
    }
    
    [db close];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
