//
//  AppDelegate.h
//  iOSDemo
//
//  Created by Gaojin Hsu on 3/13/15.
//  Copyright (c) 2015 gensee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RtSDK/RtSDK.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property BOOL allowRotation;

@property (nonatomic, strong)GSBroadcastManager *manager;

@end

