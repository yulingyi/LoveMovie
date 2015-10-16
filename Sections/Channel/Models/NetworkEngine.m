//
//  NetworkEngine.m
//  LoveMovie
//
//  Created by laouhn on 15/9/18.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "NetworkEngine.h"


@interface NetworkEngine ()



@end


static NetworkEngine * network = nil;
@implementation NetworkEngine

+ (NetworkEngine *)shareNetworkEngine
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        network = [[NetworkEngine alloc] init];
    });
    return network;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.manger = [AFHTTPRequestOperationManager manager];
    }
    return self;
}

- (void)getInfoFromServerWithURLStr:(NSString *)str
                            success:(Success)success
                               fail:(Fail)fail
{


    self.manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
    __block typeof(self) mySelf = self;
    [self.manger GET:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
           mySelf.success = success;
        mySelf.success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
//        mySelf.fail(error);
    }];
    
}

@end
