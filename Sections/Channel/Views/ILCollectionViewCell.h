//
//  ILCollectionViewCell.h
//  LoveMovie
//
//  Created by laouhn on 15/9/18.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoModel.h"
@interface ILCollectionViewCell : UICollectionViewCell

@property (nonatomic, retain) VideoModel * model;

- (void)showHistory;

@end
