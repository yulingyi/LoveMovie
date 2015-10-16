//
//  RecommendModel.h
//  LoveMovie
//
//  Created by laouhn on 15/9/17.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecommendModel : NSObject

@property (nonatomic, copy) NSNumber * imageId;
@property (nonatomic, copy) NSString * img;
@property (nonatomic, copy) NSNumber * mycollect;
@property (nonatomic, copy) NSNumber * time;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSArray * type;

@end
