//
//  MicroFilmNetworkhelper.m
//  LoveMovie
//
//  Created by laouhn on 15/9/17.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "MicroFilmNetworkhelper.h"
#import "AFNetworking.h"
#import "VideoModel.h"

@interface MicroFilmNetworkhelper ()


@property (nonatomic, retain) NSMutableDictionary * dataSourse;

@property (nonatomic, copy)  Success success;
@end

@implementation MicroFilmNetworkhelper


- (void)dealloc
{
    self.dataSourse = nil;
    
    [super dealloc];
}
- (void)getDataSourceFormNetworkWithUrlString:(NSString *)urlString
                                          key:(NSString *)key
                                      success:(Success)success
{
    
     self.success = success;
     self.dataSourse = [@{} mutableCopy];
    
    
     //第三方网络请求管理
        AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
      
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/plain",nil];
        
//        __block MicroFilmNetworkhelper *selfBlock = self;

        [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self relaoveData:responseObject key:key];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"%@", error);
        }];
}
    
- (void)relaoveData:(id)responseObject key:(NSString *)key
{
        NSArray * dataArray = responseObject;
       
        NSMutableArray * array = [@[] mutableCopy];
        for (NSDictionary * dic in dataArray) {
            
            VideoModel * video = [[VideoModel alloc] init];
            
            [video setValuesForKeysWithDictionary:dic];
            [array addObject:video];
            
            [video release];
            
        }
        
    [self.dataSourse setObject:array forKey:key];
    
    self.success(self.dataSourse);
  
}

    





@end
