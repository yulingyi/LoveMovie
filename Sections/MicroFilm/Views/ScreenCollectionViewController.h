//
//  ScreenCollectionViewController.h
//  LoveMovie
//
//  Created by laouhn on 15/9/18.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScreenCollectionViewController : UICollectionViewController

- (void)getDataByUrlStr:(NSString *)str;




@property (nonatomic, retain) NSMutableArray * dataSource;

@end
