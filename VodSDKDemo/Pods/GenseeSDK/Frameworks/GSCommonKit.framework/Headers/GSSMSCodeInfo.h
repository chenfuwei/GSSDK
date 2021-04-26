//
//  GSSMSCodeInfo.h
//  GSCommonKit
//
//  Created by net263 on 2020/10/29.
//  Copyright © 2020 gensee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSConnectInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface GSSMSCodeInfo : NSObject
@property(nonatomic, copy)NSString* phoneNumber;//手机号码
@property(nonatomic, copy)NSString* webcastID;//直播ID
@property(nonatomic, copy)NSString* domain;//域名
@property(nonatomic, copy)NSString* smsCode;//验证码
@property(nonatomic, copy)NSString* watchPassword;//课堂参加者口令
@property(nonatomic, assign)GSBroadcastServiceType serviceType;
@end

NS_ASSUME_NONNULL_END
