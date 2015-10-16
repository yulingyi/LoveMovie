//
//  MPPlayerController.m
//  LoveMovie
//
//  Created by laouhn on 15/9/29.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "MPPlayerController.h"


@implementation MPPlayerController

+ (MPPlayerController *)defaultMPPlayerController
{
    static MPPlayerController * mpPlayerController;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mpPlayerController = [[MPPlayerController alloc] init];
    });
    return mpPlayerController;
}

@end
