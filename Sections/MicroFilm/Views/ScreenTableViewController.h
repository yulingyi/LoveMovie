//
//  ScreenTableViewController.h
//  LoveMovie
//
//  Created by laouhn on 15/9/19.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScreenTableViewController : UITableViewController


- (void)getDataByUrlStr:(NSString *)str;
@property (nonatomic, assign) int count;

@property (nonatomic, retain) NSMutableArray * dataSource;


@end
