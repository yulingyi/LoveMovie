//
//  GetDataWithUrl.h
//  LoveMovie
//
//  Created by laouhn on 15/9/17.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^Success)(id data);
typedef void (^Fail)(NSString * str);
@interface GetDataWithUrl : NSObject

- (void)requestDataWithUrlString:(NSString *)urlString
                       success:(Success)success
                          fail:(Fail)fail;

@end
