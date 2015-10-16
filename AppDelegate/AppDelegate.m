//
//  AppDelegate.m
//  LoveMovie
//
//  Created by laouhn on 15/9/16.
//  Copyright (c) 2015年 laouhn. All rights reserved.
//

#import "AppDelegate.h"
#import "TabBarViewController.h"
#import "FirstLoadView.h"
#import "RootViewController.h"
#import "UMSocial.h"
#import "UMSocialSnsService.h"
#import "UMSocialSinaHandler.h"
#import "UMSocialQQHandler.h"
#import "AFNetworking.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    

//    [UIApplication sharedApplication]

        [UMSocialData setAppKey:@"5602838f67e58ecc55000a8b"];
    [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeImage;

    
    [UMSocialQQHandler setQQWithAppId:@"1104805529" appKey:@"YruZEO4J0L6Yui0o" url:@"http://www.umeng.com/social"];
    

//
//    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"IsFirstLoad"]) {
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"IsFirstLoad"];
//        FirstLoadView * firstView = [[[FirstLoadView alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease];
//        
//        [self.window addSubview:firstView];
//        
//
//
//    }else
//    {
        RootViewController * rootVC = [[RootViewController alloc] init];
        self.window.rootViewController = rootVC;
        [rootVC release];
//    }
//  
    [self networkReachability];


    return YES;
}


- (void)networkReachability
{
    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    
    // 2.设置网络状态改变后的处理
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: // 未知网络
                NSLog(@"未知网络");
                _isNETWORK = YES;
                break;
                
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
                NSLog(@"没有网络(断网)");
                _isNETWORK = NO;
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"NONETWORK" object:self];
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                NSLog(@"手机自带网络");
                _isNETWORK = YES;
                  [[NSNotificationCenter defaultCenter] postNotificationName:@"IPHONE" object:self];
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
                _isNETWORK = YES;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"WIFI" object:self];
                NSLog(@"WIFI");
                break;
        }
    }];
    
    // 3.开始监控
    [mgr startMonitoring];
    

}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [UMSocialSnsService handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [UMSocialSnsService handleOpenURL:url];
}


- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if(self.isFull)
    {
        return UIInterfaceOrientationMaskAll;
    }
    
    return UIInterfaceOrientationMaskPortrait;
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
