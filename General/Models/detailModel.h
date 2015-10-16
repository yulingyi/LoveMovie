//
//  detailModel.h
//  LoveMovie
//
//  Created by laouhn on 15/9/18.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface detailModel : NSObject

@property (nonatomic, copy) NSString * year;
@property (nonatomic, copy) NSString * zone;
@property (nonatomic, copy) NSString * actors;
@property (nonatomic, copy) NSString * videoDescription;
@property (nonatomic, copy) NSString * directors;
@property (nonatomic, copy) NSString * introduction;
@property (nonatomic, retain) NSDictionary * playurl;
@property (nonatomic, copy) NSString * pubface;
@property (nonatomic, retain) NSNumber * pubid;
@property (nonatomic, copy) NSString * pubnick;
@property (nonatomic, copy) NSString * score;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, retain) NSArray * type;
@property (nonatomic, copy) NSString * writers;



@end
