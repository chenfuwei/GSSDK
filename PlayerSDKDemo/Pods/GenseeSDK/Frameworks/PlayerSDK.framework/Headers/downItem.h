//
//  downItem.h
//  genseeFrameWork
//
//  Created by gs_mac_fjb on 15-1-26.
//  Copyright (c) 2015年 gensee. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "vodHead.h"

@interface downItem : NSObject
/**
@property strDownloadID
@discussion 等于VodID,表示该点播件的唯一标识
*/
@property(nonatomic,strong)NSString *strDownloadID;
@property(nonatomic,strong)NSString *number;
/**
 @property strURL
 @discussion xmlUrl，包含此点播件详细信息的xml地址
 */
@property(nonatomic,strong)NSString *strURL;
/**
 @property state
 @discussion 点播的下载状态
 */
@property(nonatomic,assign) GSDownloadState state;
/**
 @property name
 @discussion 点播件的名字
 */
@property(nonatomic,strong)NSString *name;


@property(nonatomic,strong)NSString *fileSize;
@property(nonatomic,strong)NSString *downLoadedSize;
/**
 @property llUserID
 @discussion 用户id
 */
@property(nonatomic,assign)LONGLONG llUserID;

@property (nonatomic,strong) NSString *tid;
@property (nonatomic,assign) long long llSiteID;
@property(nonatomic,strong)NSString *strUserName;
@property(nonatomic,strong)NSString *strAlbAddress;
@property(nonatomic,assign)int  nServiceType;

@property(nonatomic,assign)int  downFlag;
@property(nonatomic,strong)NSString *mDomain;

@property(nonatomic,strong)NSString *endtime;
@property(nonatomic,strong)NSString *starttime;

@property (nonatomic, assign) NSInteger sc;

@property (nonatomic, assign) long long hostID;

@property (nonatomic, copy) NSString *cdnList;

@property (nonatomic, assign)int loopFlag;

//3.6.3
//下载进度
@property (nonatomic, assign) float percent;

//3.7.4
@property (nonatomic,strong) NSString *albport;

//3.7.9
@property (nonatomic, strong) NSString *vodDescription;
@property (nonatomic, strong) NSString *scheduleInfo;
@property (nonatomic, strong) NSString *speakerInfo;


//3.7.11
@property (nonatomic, assign) NSTimeInterval requestStartTime;
@property (nonatomic, assign) NSTimeInterval requestEndTime;
// 获取点播的大小，日期信息
- (void)requestMoreInfo:(void (^)(BOOL isSuccess, NSString* fileSize, NSString* startTime, NSString *endTime))completion;

@end
