//
//  GSWebAccess.h
//  GSCommonKit
//
//  Created by Sheng on 2018/8/30.
//  Copyright © 2018年 gensee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSSMSCodeInfo.h"
typedef NS_ENUM(NSUInteger, GSSMSCodeInfoResult){
    GSSMSCodeSuccess,
    GSSMSCodeParamError = 101,    //缺少参数
    GSSMSCodePhoneNumberInvalid = 102,   //手机号无效
    GSSMSCodeTooQuickly = 103,     //同一手机号60s内只能发送一次验证码
    GSSMSCodeFailure = 105,     //短信发送失败
    GSSMSCodeNetworkError = 99999   //网络错误
};
/**
 *  直播连接结果
 */
typedef NS_ENUM(NSUInteger, GSBroadcastConnectResult) {
    
    /**
     *  直播初始化成功
     */
    GSBroadcastConnectResultSuccess = 0,
    
    /**
     *  网络错误
     */
    GSBroadcastConnectResultNetworkError = 1,
    
    /**
     *  找不到对应的webcastID，可能情况：roomNumber, domain填写有误，找不到对应的直播,调用AccessInfo接口产生的错误
     */
    GSBroadcastConnectResultWebcastIDNotFound = 2,
    
    /**
     *  webcastID 错误， 找不到对应的直播初始化参数, 调用LoginInfo接口产生的错误
     */
    GSBroadcastConnectResultWebcastIDInvalid = 3,
    
    /**
     *  登录信息错误， 调用LoginInfo接口产生的错误
     */
    GSBroadcastConnectResultLoginFailed = 4,
    
    /**
     *  加会口令错误, 调用LoginInfo接口产生的错误
     */
    GSBroadcastConnectResultJoinCastPasswordError = 5,
    
    /**
     *  其他错误，域名，角色拼接错误, 调用LoginInfo接口产生的错误
     */
    GSBroadcastConnectResultRoleOrDomainError = 6,
    
    /**
     *  加会参数都正确，但是初始化失败
     */
    GSBroadcastConnectResultInitFailed = 7,
    
    /**
     *  未知错误
     */
    GSBroadcastConnectResultUnknownError = 8,

    /**
     *  第三方验证错误
     */
    GSBroadcastConnectResultThirdTokenError = 9,
    
    /**
     * 不支持移动端
     */
    GSBroadcastConnectResultMobileUnsupported = 10,
    
    /**
     * 直播已过期
     */
    GSBroadcastConnectResultExpired = 11,
    
    /**
     * 没有权限观看直播
     **/
    GSBroadcastConnectResultPermissionDeny = 12,
    
    /**
     *短信验证码错误
     */
    GSBroadcastConnectResultSMSCodeError = 15,
    /**
     手机号错误
     */
    
    GSBroadcastConnectResultPhoneNumberError = 14,
    
    /**
     微课堂加载失败,1小时内才能入会
     */
    GSBroadcastMiniClassLoginInvalidStartTime = 17,
    
    /**
     微课堂加载失败,课堂未开启，无法进入
     */
    GSBroadcastMiniClassLoginNotStart = 18

};



//SDK类型
typedef NS_ENUM(NSInteger, GSSDKType) {
    GSSDKTypeRt,  //RtSDK
    GSSDKTypePlayer, //PlayerSDK
    GSSDKTypeVod  //vodsdk
};




NS_ASSUME_NONNULL_BEGIN
typedef void (^GSWebAccessCompletion)(NSUInteger result,NSDictionary *_Nullable resultDic);
@interface GSWebAccess : NSObject
@property (nonatomic, assign) BOOL httpsAPI; //是否使用https的API,默认为NO
@property (nonatomic, assign) BOOL isAlwaysTrustCertificate; //是否总是信任证书 https模式下有效,默认为YES
@property (nonatomic, assign, readonly) GSSDKType sdk; //SDK类型
- (instancetype _Nullable )init;
- (void)accessWithParam:(nonnull GSConnectInfo*)info
                sdkType:(GSSDKType)type
             completion:(GSWebAccessCompletion)completion;
- (void)cancel; //取消正在进行的access
- (NSString *)getParamString;

//单独获取accessInfo，cancel对其不影响
- (void)accessInfoByNumber:(nonnull GSConnectInfo*)info
                completion:(GSWebAccessCompletion)completion;

#pragma mark - vod fuc

- (void)accessWithParam:(nonnull GSConnectInfo*)info
               download:(BOOL)isDownload
             completion:(void (^)(NSDictionary *_Nullable resultDic, NSError *error))completion;

#pragma mark - 短信验证码
- (void)accessSMSCode:(NSString*)phoneNumber domain:(NSString*)domain serviceType:(GSBroadcastServiceType) serviceType success:(void(^)(GSSMSCodeInfoResult code))success failure:(void(^)(GSSMSCodeInfoResult errCode))failure;
- (void)accessWithSMSCodeInfo:(GSSMSCodeInfo*)smsCodeInfo completion:(GSWebAccessCompletion)completion;
@end
NS_ASSUME_NONNULL_END
