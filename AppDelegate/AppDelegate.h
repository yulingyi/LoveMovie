//
//  AppDelegate.h
//  LoveMovie
//
//  Created by laouhn on 15/9/16.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (assign, nonatomic) BOOL isFull;
@property (assign, nonatomic) BOOL isNETWORK;
- (void)networkReachability;

@end

