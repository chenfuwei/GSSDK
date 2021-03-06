//
//  VodDownLoader.h
//  VodSdk
//
//  Created by gs_mac_fjb on 14-10-31.
//  Copyright (c) 2014年 gensee. All rights reserved.
//

#import <Foundation/Foundation.h>
@class downItem,VodItem;
#include "vodHead.h"
#import "VodParam.h"
#import "GSVodMacro.h"
#import "GSRecordInfo.h"

@protocol VodDownLoadDelegate <NSObject>
@optional
/**
 *  下载完成代理
 *
 *  @param downloadID 已经下载完成的点播件（录制件）的ID
 */
- (void) onDLFinish:(NSString*) downloadID;

/**
 *  下载进度代理
 *
 *  @param downloadID 正在下载的点播件（录制件）的ID
 *  @param percent    下载的进度
 */
- (void) onDLPosition:(NSString*) downloadID  percent:(float) percent;

/**
 *  下载开始代理
 *
 *  @param downloadID 开始下载的点播件（录制件）的ID
 */
- (void) onDLStart:(NSString*) downloadID;

/**
 *  下载停止代理
 *
 *  @param downloadID 停止下载的点播件（录制件）的ID
 */
- (void) onDLStop:(NSString*) downloadID;

/**
 *  下载出错代理\
 *
 *  @param downloadID 下载出错的点播件（录制件）的ID
 *  @param errorCode  错误码
 */
- (void) onDLError:(NSString*) downloadID Status:(VodDownLoadStatus) errorCode; // 下载出错

/**
 *  添加到下载代理
 *
 *  @param resultType 添加到下载的结果
 *  @param item        添加到下载的点播件（录制件）
 */
- (void) onAddItemResult:(RESULT_TYPE)resultType voditem:(downItem*)item;

/**
 @param recordInfo 点播件的基本信息，开始时间，大小，时长
 @param downloadID 点播件（录制件）的ID
 */
-(void)onRecordInfo:(NSString*)downloadID recordInfo:(GSRecordInfo*)recordInfo;

@end

/**
 *  VodDownLoader是管理点播件（录制件）下载的类
 */
@interface VodDownLoader : NSObject

/**
 *  VodDownLoadDelegate代理
 */
@property(nonatomic,weak)id<VodDownLoadDelegate>  delegate;

/**
 *   当前正在下载的点播件（录制件）的ID
 */
@property(nonatomic,strong)NSString *mCurrentDownloadId;


/**
 若需要在回调中获得点播件大小，请设置为YES，会导致前期加载时间变长
 */
@property (nonatomic, assign) BOOL vodTimeFlag;


/**
 是否强制使用http接口；默认为NO，使用https
 */
@property (nonatomic, assign) BOOL httpAPIEnabled;


/**
 *  初始化VodDownLoader 
 *
 *  @param delegate VodDownLoadDelegate代理
 *
 *  @return VodDownLoader实例
 */
- (id)initWithDelegate:(id<VodDownLoadDelegate>)delegate;

- (void)download:(GSConnectInfo *)info chatPost:(BOOL)chatPost completion:(void(^)(downItem *item,GSVodWebaccessError type))completion;
/**
 *  下载点播件（录制件）
 *
 *  @param vodItem 点播件（录制件）
 *  @param chatPost 聊天是否按时间顺序推送
 */
- (void)download:(downItem*)vodItem chatPost:(BOOL)chatPost;

/**
 *  下载点播件（录制件）
 *
 *  @param downloadID 要下载的点播件（录制件）的ID
 *   @param chatPost 聊天是否按时间顺序推送
 */
- (void)start:(NSString*)downloadID chatPost:(BOOL)chatPost;

/**
 *  删除点播件（录制件）
 *
 *  @param downloadID 要删除的点播件（录制件）的ID
 *
 *  @return 删除结果，YES表示成功
 */
- (BOOL)delete:(NSString*)downloadID;

/**
 @method remove:onDatabase:   V:@:B
 @abstract DownloadId 下载件id isDatabase 是否删除数据库记录
 @discussion isDatabase为NO时，只会删除缓存文件，不会删除该点播件在数据库中的记录，下次app启动仍然可以查询到
 */
- (BOOL)remove:(NSString*)DownloadId onDatabase:(BOOL)isDatabase;
/**
 *  停止下载，已下载的部分不会删除，可继续下载，也可以理解为暂停下载
 *
 *  @param downloadID 停止下载的点播件（录制件）的ID
 */
- (void)stop:(NSString*)downloadID;



/**
 *  添加到下载
 *
 *  @param domain        域名
 *  @param number        编号
 *  @param loginName     登录名
  *  @param nickName     昵称
 *  @param vodPassword   观看密码
 *  @param loginPassword 登录密码
 *  @param downFlag      1:需要下载  0:不需要下载  用于在线播放和下载播放
 *  @param serType       webcast或者training
 * @param isBox         是否box YES:将不再判断服务器返回的ipad字段 NO:默认为NO,是会判断服务器返回的ipad字段
 *  @param oldVersion    是否用新版本的接口
 *  @param token         第三方验证K值，只有在oldVersion为NO下才会起作用
 * @param customUser     自定义用户id，无特殊需求直接写0，若需要自定义，则需要大于十亿，否则无效
 */

- (void)addItem:(NSString *)domain
         number:(NSString*)number
      loginName:(NSString*)loginName
       nickName:(NSString*)nickName
    vodPassword:(NSString*)vodPassword
  loginPassword:(NSString*)loginPassword
       downFlag:(int)downFlag
        serType:(NSString*)serType
          isBox:(BOOL)isBox
     oldVersion:(BOOL) oldVersion
         kToken:(NSString*)token
   customUserID:(long long) customUserID DEPRECATED_MSG_ATTRIBUTE("请使用addItem:");





/**
 *  添加到下载
 *
 *  @param domain        域名
 *  @param number        编号
 *  @param loginName     登录名
 *  @param vodPassword   观看密码
 *  @param loginPassword 登录密码
 *  @param downFlag      1:需要下载  0:不需要下载  用于在线播放和下载播放
 *  @param serType       webcast或者training
 *  @param oldVersion    是否用新版本的接口
 *  @param token         第三方验证K值，只有在oldVersion为NO下才会起作用
 * @param customUser     自定义用户id，无特殊需求直接写0，若需要自定义，则需要大于十亿，否则无效
 */
- (void)addItem:(NSString *)domain
         number:(NSString*)number
      loginName:(NSString*)loginName
    vodPassword:(NSString*)vodPassword
  loginPassword:(NSString*)loginPassword
       downFlag:(int)downFlag
        serType:(NSString*)serType
     oldVersion:(BOOL) oldVersion
         kToken:(NSString*)token
   customUserID:(long long) customUserID DEPRECATED_MSG_ATTRIBUTE("请使用addItem:");

/**
 *  添加到下载
 *
 *  @param domain        域名
 *  @param number        编号
 *  @param loginName     登录名
 *  @param vodPassword   观看密码
 *  @param loginPassword 登录密码
 *  @param vodid         点播件（录制件）ID
 *  @param downFlag      1:需要下载  0:不需要下载  用于在线播放和下载播放
 *  @param serType       webcast或者training
 *  @param oldVersion    是否用新版本的接口
 *  @param token         第三方验证K值，只有在oldVersion为NO下才会起作用
 * @param customUser     自定义用户id，无特殊需求直接写0，若需要自定义，则需要大于十亿，否则无效
 */
- (void)addItem:(NSString *)domain
         number:(NSString*)number
      loginName:(NSString*)loginName
    vodPassword:(NSString*)vodPassword
  loginPassword:(NSString*)loginPassword
          vodid:(NSString*)vodid
       downFlag:(int)downFlag
        serType:(NSString*)serType
     oldVersion:(BOOL) oldVersion
         kToken:(NSString*)token
   customUserID:(long long) customUserID DEPRECATED_MSG_ATTRIBUTE("请使用addItem:");




/**
 添加到下载

 @param vodParam 点播参数
 */
- (void)addItem:(VodParam*)vodParam;

/**
 *  把点播件（录制件）添加到本地数据库
 *
 *  @param item 点播件（录制件）
 */
- (void)addItemToDataBase:(downItem*)item;

/**
 *  获取点播件（录制件）的下载路径
 *
 *  @param downloadID 点播件（录制件）的ID
 *
 *  @return 下载路径
 */
- (NSString*)vodDownloadPath:(NSString*)downloadID;


/**
 请自行检测wifi切换，同时调用此方法，否则有可能会导致切换wifi或3g／4g是导致长时间重连
 */
- (void) reconnect;


@end
