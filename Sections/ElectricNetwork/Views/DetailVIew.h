//
//  DetailVIew.h
//  LoveMovie
//
//  Created by laouhn on 15/9/18.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoModel.h"


@interface DetailVIew : UIScrollView

@property (nonatomic, retain) VideoModel * video;
@property (nonatomic, assign) CGRect rect;

- (id)initWithFrame:(CGRect)frame
              video:(VideoModel *)video;

@end
