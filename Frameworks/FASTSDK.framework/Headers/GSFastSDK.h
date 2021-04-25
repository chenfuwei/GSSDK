//
//  GSFastSDK.h
//  FASTSDK
//
//  Created by Sheng on 2017/7/27.
//  Copyright © 2017年 陈伯伦. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSFastSDKConfig.h"
#import <PlayerSDK/VodSDK.h>
#import "GSFastPlayerSDKDelegate.h"
#import "GSFastVodSDKDelegate.h"
NS_ASSUME_NONNULL_BEGIN
/**
 SDK类
 */
@interface GSFastSDK : NSObject
/**
 SDK 所支持的旋转方向值
 */
@property (nonatomic, assign) UIInterfaceOrientationMask orientationMask;
//播放时长
@property (nonatomic, assign) long playTime;

/// 使用下列block时请注意指针引用，避免被单例对象的block属性捕获导致对象不释放的问题
/// 点播开始或者直播开始
@property (nonatomic, copy) void (^didstart)(void);
/// value 0表示恢复 1表示缓冲
@property (nonatomic, copy) void (^didbuffer)(int value);
/// 点播didstop表示播放完成，直播didstop表示退出直播 - 界面还未退出
@property (nonatomic, copy) void (^didstop)(int value);
/// 界面leave完成回调
@property (nonatomic, copy) void (^didleave)(int value);
///点播播放进度
@property (nonatomic, copy) void (^didPosiiton)(int position);


@property (nonatomic, copy) NSString* (^didUserCustomLanguage)(void);

@property (nonatomic, weak)id<GSFastPlayerSDKDelegate> fastPlayerSDKDelegate;

@property (nonatomic, weak)id<GSFastVodSDKDelegate> fastVodSDKDelegate;
+ (instancetype)sharedInstance;

#pragma mark - Watch 观看


- (UIViewController*)watchViewControllerBy:(GSConnectInfo*)minfo configuration:(GSFastSDKConfig*)mconfig;

/**
 观看直播,默认采用present方式推出

 @param minfo 直播参数
 @param mconfig 直播配置信息
 @param animate 是否开启跳转动画
 @param completion 进入回调
 */
- (void)enterLive:(GSConnectInfo*)minfo config:(GSFastSDKConfig*)mconfig animate:(BOOL)animate completion:(void (^ __nullable)(void))completion;
/**
 设置退出回调,仅使用'enterLive:config:animate:completion:'方法时有效
 @param completion 退出回调
 */
- (void)setLeaveCompletion:(void (^ __nullable)(void))completion;

#pragma mark - Publish 发布
/**
 发布直播

 @param minfo 直播参数
 @param mconfig 直播配置信息
 */
- (void)publishLive:(GSConnectInfo *)minfo config:(GSFastSDKConfig*)mconfig;

#pragma mark - 点播

-(void)enterVod:(VodParam *)minfo  animate:(BOOL)animate completion:(void (^ __nullable)(void))completion;

-(void)enterVod:(VodParam *)minfo  config:(GSFastSDKConfig *)config animate:(BOOL)animate completion:(void (^ __nullable)(void))completion;

#pragma mark - private
/**
 登出 并清除部分资源 （用户不需要主动调用）
 */
- (void)logout;

@end

NS_ASSUME_NONNULL_END



