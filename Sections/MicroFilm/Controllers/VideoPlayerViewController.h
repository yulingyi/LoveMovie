//
//  VideoPlayerViewController.h
//  LoveMovie
//
//  Created by laouhn on 15/9/18.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoModel.h"
#import <MediaPlayer/MediaPlayer.h>
#define Kwidth self.player.view.frame.size.width
#define KHIGHT self.player.view.frame.size.height
#define KHIGHT_VIEW ([UIScreen mainScreen].bounds.size.height - 64)
@interface VideoPlayerViewController : UIViewController
@property (nonatomic, retain) MPMoviePlayerController * player;
@property (nonatomic, retain) VideoModel * video;
- (void)setMPMoviePlayerController:(NSString *)urlVideo;




@end
