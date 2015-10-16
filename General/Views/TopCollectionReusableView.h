//
//  TopCollectionReusableView.h
//  VMovie
//
//  Created by laouhn on 15/9/14.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoModel.h"
#import "SDCycleScrollView.h"
@interface TopCollectionReusableView : UICollectionViewCell

@property (nonatomic, copy) NSArray * videos;
@property (nonatomic, retain) SDCycleScrollView *cycleScrollView;
@property (nonatomic, retain) id target;
@property (nonatomic, assign) SEL action;
@property (nonatomic, assign) NSInteger * vid;

@end
