//
//  GetDataWithUrl.m
//  LoveMovie
//
//  Created by laouhn on 15/9/17.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "GetDataWithUrl.h"
#import "AFNetworking.h"
@implementation GetDataWithUrl

- (void)requestDataWithUrlString:(NSString *)urlString
                       success:(Success)success
                          fail:(Fail)fail
{
    AFHTTPRequestOperationManager * manger = [AFHTTPRequestOperationManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/plain",nil];
    [manger GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"网络请求错误,请耐心等候" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
//        [alert show];
//        [alert release];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [alert dismissWithClickedButtonIndex:0 animated:YES];
//        });
//        fail(@"请求失败");
    }];

}




@end
