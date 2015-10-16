//
//  RootViewController.h
//  LoveMovie
//
//  Created by laouhn on 15/9/19.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController
@property (nonatomic, assign) BOOL isOpen;

- (void)openLeftView;
- (void)closeLeftView;

@end
