//
//  VideoModel.h
//  VMovie
//
//  Created by laouhn on 15/9/15.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoModel : NSObject

@property (nonatomic, copy) NSString   * img;
@property (nonatomic, copy) NSString   * title;
@property (nonatomic, retain) NSNumber * videoID;
@property (nonatomic, copy) NSString   * descript;
@property (nonatomic, copy) NSString   * score;
@property (nonatomic, retain) NSNumber * time;
@property (nonatomic, retain) NSNumber * maxepisode;
@property (nonatomic, retain) NSNumber * maxid;
@property (nonatomic, copy) NSString   * introduction;
@property (nonatomic, copy) NSString   * actors;
@property (nonatomic, copy) NSString   * directors;
@property (nonatomic, copy) NSString   * year;
@property (nonatomic, copy) NSString   * zone;
@property (nonatomic, copy) NSNumber   * episode;
@property (nonatomic, assign)  float   current;
//@property (nonatomic, assign)  double  playableDuration;


@property (nonatomic, copy) NSString   * videoURL;


@end
