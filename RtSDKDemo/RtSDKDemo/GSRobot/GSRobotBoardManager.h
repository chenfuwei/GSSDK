//  GSRobotBoardManager.h
//  RtSDKDemo
//  Created by Gaojin Hsu on 2018/8/23.
//  Copyright © 2018年 gensee. All rights reserved.
#import <Foundation/Foundation.h>
#import "RobotPenHeader.h"
#import "RobotPenDevice.h"
@class RobotPenPoint,RobotPenDevice,RobotPenUtilPoint;
@interface GSRobotBoardManager : NSObject
/**获取已连接设备RSSI*/
@property(nonatomic,strong)NSNumber *RSSI;
//原始点
@property(nonatomic,copy)void(^recevicePointInfo)(RobotPenPoint *point);
//优化点
@property(nonatomic,copy)void(^receviceUtilPointInfo)(RobotPenUtilPoint *utilPoint);
@property(nonatomic,strong,readonly) RobotPenDevice *device;
#pragma mark - --Base
/**
 初始化画板单例
 */
+(instancetype)sharedRobotBoardManager;


/**
 搜索电磁板设备
 */
-(void)scanBlueDeviceWithBlock:(void(^)(RobotPenDevice *device))bufferDevice;


/**
 连接设备回调设备的状态
 */
- (void)connectDevice:(RobotPenDevice *)penDevice state:(void(^)(DeviceState state))deviceStateBlock;


/*!
 @method
 @abstract 停止搜索设备
 */
-(void)stopScanDevice;



/**
 断开设备
 */
-(void)disconnectDevice;


/*!
 @method
 @abstract  获取当前连接的设备
 @result 返回结果
 */
- (RobotPenDevice *)getConnectDevice;




/**
 @method
 @abstract 是否开启优化笔迹
 默认开启上报原始点 isOriginal = YES
 isOriginal = NO isOptimize = NO,则只开启上报屏幕点
 isOriginal = NO isOptimize = YES,则只开启上报优化后的屏幕点
 isOriginal = YES isOptimize = NO,则只开启上报原始点
 isOriginal = YES isOptimize = YES,则只开启上报原始点
 @param isOriginal 开启上报原始点
 @param isOptimize 开启上报优化点
 @param isTransform 开启上报原始点转换点(已左上角为（0，0）点)，只有开启上报原始点时有效
 */
- (void)setOrigina:(BOOL)isOriginal optimize:(BOOL)isOptimize transform:(BOOL)isTransform;


/*!
 @method
 @abstract  设置笔线条宽度(isOptimize = YES时需要设置)
 @param width 宽度
 */
- (void)setStrokeWidth:(float)width;


#pragma mark - --other
/*!
 @method
 @abstract  清空所有配对设备
 @discussion 蓝牙（BLE）专用
 */
- (void)cleanAllPairingDevice;
@end
