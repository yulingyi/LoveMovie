//
//  DetailTableViewCell.h
//  LoveMovie
//
//  Created by laouhn on 15/9/18.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "detailModel.h"
#import "RelateTableViewController.h"

@interface DetailTableViewCell : UIScrollView

@property (nonatomic, retain) detailModel * detailModel;

- (id)initWithFrame:(CGRect)frame;
              


@end
