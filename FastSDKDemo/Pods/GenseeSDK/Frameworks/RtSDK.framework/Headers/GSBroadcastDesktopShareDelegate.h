//
//  GSBroadcastDesktopShareDelegate.h
//  RtSDK
//
//  Created by Gaojin Hsu on 6/29/16.
//  Copyright © 2016 Geensee. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GSGLBuffer;
/**
 *  直播桌面共享代理，接收桌面共享信息回调
 */
@protocol GSBroadcastDesktopShareDelegate <NSObject>
@required


/**
 *  桌面共享模块初始化反馈代理
 *
 *  @param manager 触发此代理的GSBroadcastManager对象
 *  @param result  布尔值表示初始化是否成功，YES表示成功
 *  @see  GSBroadcastManager
 */
- (void)broadcastManager:(GSBroadcastManager*)manager didReceiveDesktopShareModuleInitResult:(BOOL)result;


/**
 *  桌面共享每一帧的数据 软解
 *
 *  @param manager    触发此代理的GSBroadcastManager对象
 *  @param videoFrame 视频数据的一帧
 *  @see  GSVideoFrame
 */

- (void)broadcastManager:(GSBroadcastManager*)manager renderDesktopShareFrame:(UIImage*)videoFrame;

- (void)broadcastManager:(GSBroadcastManager*)manager receiveSoftBuffer:(GSGLBuffer*)buffer;

/**
 *  桌面共享每一帧的数据, 硬解
 *
 */
- (void)OnAsData:(unsigned char*)data dataLen: (unsigned int)dataLen width:(unsigned int)width height:(unsigned int)height;


/**
 *  开启桌面共享代理
 *
 *  @param manager 触发此代理的GSBroadcastManager对象
 *  @param userID  桌面共享的ID
 *  @see GSBroadcastManager
 */
- (void)broadcastManager:(GSBroadcastManager*)manager didActivateDesktopShare:(long long)userID;


/**
 *  桌面共享关闭代理
 *
 *  @param manager 触发此代理的GSBroadcastManager对象
 *  @see GSBroadcastManager
 */
- (void)broadcastManagerDidInactivateDesktopShare:(GSBroadcastManager*)manager;

/**
 *辅助摄像头视频开始
 */
- (void)broadcastManager:(GSBroadcastManager*)manager onDsBegin:(long long)userID;

/**
 *辅助摄像头视频关闭
 */
- (void)broadcastManagerOnDsEnd:(GSBroadcastManager*)manager;

@optional
/**
 *桌面共享开始开发发送数据代理
 *@param handle 再发送桌面共享数据时，需要使用
 */
-(void)broadcastManager:(GSBroadcastManager*)manager onAsPushModeBegin:(void *)handle;

/**
*桌面共享结束发送数据代理
*/
-(void)broadcastManager:(GSBroadcastManager*)manager onAsPushModeEnd:(void*) handle;

/**
*桌面共享强制关键帧
*/
-(void)broadcastManager:(GSBroadcastManager*)manager onAsPushModeForceKey:(void*) handle;

@end
