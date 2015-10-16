//
//  VideoModel.m
//  VMovie
//
//  Created by laouhn on 15/9/15.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "VideoModel.h"

@implementation VideoModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        
        self.videoID = value;
    }
    
    if ([key isEqualToString:@"description"]) {
        self.descript = value;
    }
}

@end
