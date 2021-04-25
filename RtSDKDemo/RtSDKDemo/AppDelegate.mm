//
//  AppDelegate.m
//  iOSDemo
//
//  Created by Gaojin Hsu on 3/13/15.
//  Copyright (c) 2015 gensee. All rights reserved.
//

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import "GSRtParamViewController.h"
#import "GSBaseNavigationController.h"
#import <GSCommonKit/GSCommonKit.h>
#import <Bugly/Bugly.h>

@interface AppDelegate ()

@end
@implementation AppDelegate 
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[GSDiagnosisInfo shareInstance] redirectNSlogToDocumentFolder];
    
    BuglyConfig * config = [[BuglyConfig alloc] init];
    // 设置自定义日志上报的级别，默认不上报自定义日志
    config.blockMonitorEnable = YES;
    config.blockMonitorTimeout = 2;
    config.unexpectedTerminatingDetectionEnable = YES;
    [Bugly startWithAppId:@"5f55b71047" config:config];
    
//    [[GSBroadcastManager sharedBroadcastManager] setSessionCategoryOption:AVAudioSessionCategoryOptionDefaultToSpeaker];
    [GSBroadcastManager sharedBroadcastManager].isBriefIntroduce = YES;
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    GSRtParamViewController *mainVC = [[GSRtParamViewController alloc]init];
    GSBaseNavigationController *navigation = [[GSBaseNavigationController alloc] initWithRootViewController:mainVC];
    self.window.rootViewController = navigation;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {

     [application beginBackgroundTaskWithExpirationHandler:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
}


@end
