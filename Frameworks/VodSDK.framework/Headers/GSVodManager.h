//
//  GSVodManager.h
//  VodSDKDemo
//
//  Created by Sheng on 2018/8/3.
//  Copyright © 2018年 Gensee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSVodBroadcastMessage.h"
#import <GSCommonKit/GSThreadSafeDictionary.h>
#import "GSVodMacro.h"
#import "downItem.h"
#import "VodPlayer.h"
#import "VodParam.h"
#import "VodDownLoader.h"

@class GSVodManager;
@protocol GSVodManagerDelegate <NSObject>
@optional
//开始下载
- (void)vodManager:(GSVodManager *)manager downloadBegin:(downItem *)item;
//下载进度
- (void)vodManager:(GSVodManager *)manager downloadProgress:(downItem *)item percent:(float)percent;
//下载暂停
- (void)vodManager:(GSVodManager *)manager downloadPause:(downItem *)item DEPRECATED_MSG_ATTRIBUTE("use vodManager:downloadPauseItems:");
- (void)vodManager:(GSVodManager *)manager downloadPauseItems:(NSArray<downItem *>*)item;
//下载停止
- (void)vodManager:(GSVodManager *)manager downloadStop:(downItem*)item;
//下载完成
- (void)vodManager:(GSVodManager *)manager downloadFinished:(downItem *)item;
//下载失败
- (void)vodManager:(GSVodManager *)manager downloadError:(downItem *)item state:(GSVodDownloadError)state;

/**
 @param recordInfo 点播件的基本信息，开始时间，大小，时长
 @param downloadID 点播件（录制件）的ID
 */
-(void)vodManager:(GSVodManager *)manager onRecordInfo:(NSString*)downloadID recordInfo:(GSRecordInfo*)recordInfo;
@end

@interface GSVodManager : NSObject
//play
@property (nonatomic, strong) VodPlayer *player;
@property (nonatomic, assign) BOOL isFlv;


@property (nonatomic, assign) GSVodDownloadState state;

//downlaod
@property (nonatomic, strong) VodDownLoader *downloader;
@property (nonatomic, weak) id<GSVodManagerDelegate> delegate;

/**
 记录正在下载的录制件信息
 */
@property (nonatomic, strong) downItem *downloadingItem;

/**
 下载处理队列
 */
@property (nonatomic, strong) NSMutableArray *downloadQueue;


@property (nonatomic, assign) BOOL isHttps;
/**
 是否自动请求点播件的开始时间、结束时间、文件大小等额外信息
 */
@property (nonatomic, assign) BOOL isAutoRequestMore;
/**
 是否自动下载
 */
@property (nonatomic, assign) BOOL isAutoDownload;




+ (instancetype)sharedInstance;

#pragma mark - request
/**
仅获取点播件信息,并加入队列
@param param 需要下载item的param信息
@param isdownload 是否加入下载队列
@param block 获取信息回调,异步请求,多次调用并不保证时序性
*/
- (void)request:(GSConnectInfo *)param download:(BOOL)isdownload completion:(void(^)(downItem *item,GSVodWebaccessError type))block;

#pragma mark - download

- (void)startDownload:(NSString *)downloadId; //开始下载

- (void)stopDownload:(NSString *)downloadId; //停止下载

//删除已下载的项目
- (BOOL)removeOnDisk:(NSString *)vodId;

- (void)play:(downItem *)item online:(BOOL)isOnline;


#pragma mark - oldversion

/**
 仅获取点播件信息,并加入队列
 @param param 需要下载item的param信息
 @param isqueue 是否加入下载队列
 @param block 获取信息回调,异步请求,多次调用并不保证时序性
 */
- (void)requestParam:(VodParam *)param enqueue:(BOOL)isqueue completion:(void(^)(downItem *item,GSVodWebaccessError type))block DEPRECATED_MSG_ATTRIBUTE("use request:download:completion:");


//手动插入item到队列 -1为插入到末尾
- (BOOL)insertQueue:(downItem *)item atIndex:(NSInteger)index DEPRECATED_MSG_ATTRIBUTE("不建议使用，后面版本将清除");
//开始队列下载
- (BOOL)startQueue DEPRECATED_MSG_ATTRIBUTE("不建议使用，后面版本将清除");
//取消下载 - 取消当前下载,并暂停队列下载队列
- (void)stopQueue:(void(^)(BOOL isSuccess))block DEPRECATED_MSG_ATTRIBUTE("不建议使用，后面版本将清除");
//暂停下载 - 暂停当前下载，恢复时继续下载
- (void)pauseQueue:(void(^)(BOOL isSuccess))block DEPRECATED_MSG_ATTRIBUTE("不建议使用，后面版本将清除");
//跳过当前下载 下载下一个
- (void)downloadNext DEPRECATED_MSG_ATTRIBUTE("不建议使用，后面版本将清除");
//清空所有下载相关的队列并停止下载
- (void)cleanQueue DEPRECATED_MSG_ATTRIBUTE("不建议使用，后面版本将清除");
//清空player
- (void)cleanPlayer DEPRECATED_MSG_ATTRIBUTE("不建议使用，后面版本将清除");

@end
