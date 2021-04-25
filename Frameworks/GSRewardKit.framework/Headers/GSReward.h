//
//  GSReward.h
//  GSRewardKit
//
//  Created by gensee on 2019/7/10.
//  Copyright © 2019年 gensee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSRewardMacro.h"
NS_ASSUME_NONNULL_BEGIN

@interface GSReward : NSObject
@property (nonatomic, strong) NSDictionary* paramDic;
@property (nonatomic, assign) unsigned count;
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, strong) NSString *extra;
@property (nonatomic, assign) GSRewardType type;
@property (nonatomic, assign) NSUInteger expireTime;

- (void)rewardWithCompletion:(void (^)(NSDictionary *dic))block;
- (void)reward:(unsigned)count comment:(NSString*)comment type:(GSRewardType)type expireTime:(NSUInteger)expireTime extra:(NSString*)extra completion:(void (^)(NSDictionary *dic))block;


+ (BOOL)handleDic:(NSDictionary *)rewardDic;

+ (NSString *)aSupportKey; //alipay支持key
+ (NSString *)bSupportKey; //微信支持key
+ (NSString *)rewardUrl;
@end

NS_ASSUME_NONNULL_END
