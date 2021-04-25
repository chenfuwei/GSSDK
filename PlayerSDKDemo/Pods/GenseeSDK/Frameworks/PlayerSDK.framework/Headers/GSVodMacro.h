//
//  GSVodMacro.h
//  VodSDK
//
//  Created by gensee on 2019/5/30.
//  Copyright © 2019年 gensee. All rights reserved.
//

#ifndef GSVodMacro_h
#define GSVodMacro_h


typedef enum : NSUInteger {
    GSVodDownloadNetworkError,
    GSVodDownloadWriteFailed,
    GSVodDownloadHAVEEXIST,
} GSVodDownloadError;

//public static final String RESULT_SUCCESS = "1";      public static final String RESULT_FAIL_TOKEN = "4";      public static final String RESULT_FAIL_LOGIN = "5";      public static final String RESULT_FIAL_NOT_EXIT_LOGIN_OR_PASSWORD = "7";      public static final String RESULT_FAIL = "2";      public static final String RESULT_FAIL_NOT_EXIT_VOD_ID = "6";      public static final String RESULT_FAIL_NOT_EXIT_VOD = "3";//number      public static final String RESULT_FAIL_K = "10";

typedef enum : NSUInteger {
    GSVodWebaccessRoomNumberUnexist = 0,
    GSVodWebaccessSuccess = 1,          //成功
    GSVodWebaccessFailed = 2,           //错误 - 内部错误
    GSVodWebaccessNumberError = 3,      //房间号错误 或者 webcast/training设置错误
    GSVodWebaccessWrongPassword = 4,    //观看密码错误
    GSVodWebaccessLoginFailed = 5,      //登录失败
    GSVodWebaccessVodIdError = 6,       //VodID错误
    GSVodWebaccessNoAccountOrPwd = 7,   //账号为空 或 密码为空
    GSVodWebaccessRoomUneable = 8,                   //点播间不可用
    GSVodWebaccessOwnerError = 9,                    //内部问题
    GSVodWebaccessThirdKeyError = 10,   //第三方验证错误
    GSVodWebaccessRoomOverdue = 11,                  //点播过期
    GSVodWebaccessAuthorizationNotEnough = 12,      //授权不够
    GSVodWebaccessInitDownloadFailed = 13,          //下载初始化失败
    GSVodWebaccessNetworkError = 14,    //网络请求失败
    GSVodWebaccessUnsupportMobile = 18, // 不支持移动设备
} GSVodWebaccessError;

typedef enum : NSUInteger {
    GSVodDownloadStateStop,
    GSVodDownloadStateDownloading,
    GSVodDownloadStatePause,
} GSVodDownloadState;

#endif /* GSVodMacro_h */
