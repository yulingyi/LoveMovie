//
//  NetworkEngine.h
//  LoveMovie
//
//  Created by laouhn on 15/9/18.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "detailModel.h"
#import "AFNetworking.h"


typedef void (^Success)(id response);

typedef void (^Fail)(NSError * error);

@interface NetworkEngine : NSObject

@property (nonatomic, copy) Success success;
@property (nonatomic, copy) Fail fail;
@property (nonatomic, retain) AFHTTPRequestOperationManager * manger;
@property (nonatomic, assign) CGFloat houHeight;

+ (NetworkEngine *)shareNetworkEngine;

- (void)getInfoFromServerWithURLStr:(NSString *)str
                            success:(Success)success
                               fail:(Fail)fail;


@end
