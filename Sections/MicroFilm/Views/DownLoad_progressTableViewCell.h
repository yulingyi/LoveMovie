//
//  DownLoad_progressTableViewCell.h
//  LoveMovie
//
//  Created by laouhn on 15/9/21.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "detailModel.h"
#import "AFNetworking.h"

@protocol DownLoad_progressTableViewCellDelegate <NSObject>

- (void)reloadData:(NSString *)videoName;

@end



@interface DownLoad_progressTableViewCell : UITableViewCell

@property (nonatomic, retain) detailModel * detail;
@property (nonatomic, assign) id<DownLoad_progressTableViewCellDelegate> delegate;

@property (nonatomic, retain) AFHTTPRequestOperation * operation;
@end
