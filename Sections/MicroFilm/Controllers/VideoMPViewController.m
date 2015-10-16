//
//  VideoMPViewController.m
//  LoveMovie
//
//  Created by laouhn on 15/9/27.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "VideoMPViewController.h"
#import "AppDelegate.h"
@interface VideoMPViewController ()

@end

@implementation VideoMPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
    
    appDelegate.isFull = YES;

//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoDidEnterFullscreen:) name:MPMoviePlayerDidEnterFullscreenNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoWillExitFullscreen:) name:MPMoviePlayerWillExitFullscreenNotification object:nil];
    

    // Do any additional setup after loading the view.
}

//- (void)videoDidEnterFullscreen:(NSNotification *)notification {// 开始播放
//    
//    AppDelegate * appDelegate = [[UIApplication sharedApplication] delegate];
//    
//    appDelegate.isFull = YES;
//    
//}

- (void)viewDidDisappear:(BOOL)animated
{
    [self videoWillExitFullscreen:nil];
}

- (void)videoWillExitFullscreen:(NSNotification *)notification {//完成播放
    
    
    
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
