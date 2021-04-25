//
//  AppDelegate.h
//  VodSDKDemo
//
//  Created by gs_mac_wjj on 15/9/21.
//  Copyright © 2015年 Gensee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VodSDK/VodSDK.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) VodPlayer *vodplayer;

@property (nonatomic,assign)UIInterfaceOrientationMask orientMask;

@end

