//
//  GSCommonConst.h
//  GSCommonKit
//
//  Created by Sheng on 2018/8/29.
//  Copyright © 2018年 gensee. All rights reserved.
//

#import <UIKit/UIKit.h>
UIKIT_EXTERN NSString *const GSWebaccessInfoKey; //网络请求的字典数据
//以下是网络请求的字典数据的key 即GSWebaccessInfoKey中存储在本地的key值
UIKIT_EXTERN NSString *const GSParamDomain; //域名
UIKIT_EXTERN NSString *const GSParamServiceType; //站点类型
UIKIT_EXTERN NSString *const GSParamWebcastID; //webcastId
UIKIT_EXTERN NSString *const GSParamUserID; //用户id
UIKIT_EXTERN NSString *const GSParamSiteID; //site id
UIKIT_EXTERN NSString *const GSParamUserRole; //用户角色
UIKIT_EXTERN NSString *const GSParamUsername; //用户名称
UIKIT_EXTERN NSString *const GSParamWebUrl; //weburl
UIKIT_EXTERN NSString *const GSParamDiagnoseUploadUrl; //日志上传地址
UIKIT_EXTERN NSString *const GSParamSubject; //直播主题
UIKIT_EXTERN CGFloat const GSWebTimeOut;//请求的超时的时间

UIKIT_EXTERN NSString *const GSParamRewardUrl; //打赏Url
UIKIT_EXTERN NSString *const GSParamAlbAddress; //alb address
UIKIT_EXTERN NSString *const GSNotificationResetAVCCofig; //重发avc

#pragma mark -会议直播专用
UIKIT_EXTERN NSString *const GSExtraInitParamVideoMaxWidth;
UIKIT_EXTERN NSString *const GSExtraInitParamVideoMaxHeight;
UIKIT_EXTERN NSString *const GSExtraInitParamVideoMaxFps;
UIKIT_EXTERN NSString *const GSExtraInitParamVideoAutoFps;
UIKIT_EXTERN NSString *const GSExtraInitParamRecordOnServer;
UIKIT_EXTERN NSString *const GSExtraInitParamEnablePhoneSupport;
UIKIT_EXTERN NSString *const GSExtraInitParamFileshareMaxFileQuantity;
UIKIT_EXTERN NSString *const GSExtraInitParamFileshareMaxSizePerFile;

