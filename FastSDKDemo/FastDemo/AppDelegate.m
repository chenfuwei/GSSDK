//
//  AppDelegate.m
//  FastDemo
//
//  Created by 陈伯伦 on 2016/12/14.
//  Copyright © 2016年 陈伯伦. All rights reserved.
//

#import "AppDelegate.h"
#import <FASTSDK/FASTSDK.h>
#import <Bugly/Bugly.h>
#import "GSFastConfigController.h"
#import "GSFastNavigationController.h"
@interface AppDelegate ()

@end
@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    BuglyConfig * config = [[BuglyConfig alloc] init];
    // 设置自定义日志上报的级别，默认不上报自定义日志
    config.blockMonitorEnable = YES;
    config.blockMonitorTimeout = 2;
    config.unexpectedTerminatingDetectionEnable = YES;
    [Bugly startWithAppId:@"c2d6cf3ee4" config:config];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    GSFastConfigController *mainVC = [[GSFastConfigController alloc]init];
    GSFastNavigationController *navigation = [[GSFastNavigationController alloc] initWithRootViewController:mainVC];
    self.window.rootViewController = navigation;
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{

    return [GSFastSDK sharedInstance].orientationMask;
}

//对于shouldAutorotate系统默认返回YES,supportedInterfaceOrientations系统默认返回 UIInterfaceOrientationMaskAll for the iPad idiom and UIInterfaceOrientationMaskAllButUpsideDown for the iPhone idiom.

//#pragma mark --rorate---
//- (BOOL)shouldAutorotate{
//    return YES;
//}
//- (NSUInteger)supportedInterfaceOrientations
//{
//    
//    
//    return [[SDKAppDelegate sharedInstance] fastSDKSupportedInterfaceOrientations];
//}
//
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
//    
//    
//    
//    return   [[SDKAppDelegate sharedInstance] fastSDKShouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
//    
//}
//- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
//    
//    
//    
//    return [[SDKAppDelegate sharedInstance] fastSDKApplication:application supportedInterfaceOrientationsForWindow:window];
//}
//
//
//
//- (BOOL)application:(UIApplication *)application
//            openURL:(NSURL *)url
//  sourceApplication:(NSString *)sourceApplication
//         annotation:(id)annotation {
//    
//    return [[SDKAppDelegate sharedInstance]FastSDKapplication:application openURL:url sourceApplication:sourceApplication annotation:(id)annotation];
//}
//
//// NOTE: 9.0以后使用新API接口
//- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
//{
//
//    return [[SDKAppDelegate sharedInstance]FastSDKapplication:app openURL:url options:options];
//}





@end
