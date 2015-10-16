//
//  MicroFilmNetworkhelper.h
//  LoveMovie
//
//  Created by laouhn on 15/9/17.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^Success)(NSMutableDictionary* dic);
@interface MicroFilmNetworkhelper : NSObject

- (void)getDataSourceFormNetworkWithUrlString:(NSString *)urlString
                                          key:(NSString *)key
                                      success:(Success)success;

@end
