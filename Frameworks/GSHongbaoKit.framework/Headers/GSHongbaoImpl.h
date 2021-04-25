//
//  GSHongbaoImpl.h
//  GSHongbaoKit
//
//  Created by net263 on 2019/12/2.
//  Copyright © 2019 net263. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GSCommonKit/GSCommonKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GSHongbaoImpl : NSObject
@property(nonatomic, strong)GSHongbaoImplParams *params;
@property(nonatomic, weak)id<GSHongbaoImplDelegate> hongbaoImplDelegate;

+(instancetype)sharedInstance;
-(void)updateHongbaoConfiID:(NSString *)confiID;
-(void)handleHongbaoParams:(GSHongbaoImplParams *)params delegate:(id<GSHongbaoImplDelegate>)delegate;
-(NSString *)createRandomHongbao:(NSInteger)hongbaoMoneyNum hongbaoCount:(NSInteger)hongbaoCount timeLimit:(NSInteger)timeLimit fixed:(BOOL)fixed comment:(NSString *)comment;
-(NSString *)createHongbaoForSomeBody:(NSInteger)hongbaoMoneyNum timeLimit:(NSInteger)timeLimit recvUserId:(NSInteger)recvUserId recvUserName:(NSString *)recvUserName comment:(NSString *)comment;

-(BOOL)grabHongbao:(NSString *)hongbaoId;
-(BOOL)queryHongbaoList;
-(BOOL)querySelfGrabList;
-(BOOL)queryBalance;
-(BOOL)queryHongbaoGrabList:(NSString *)strHongbaoID;
@end

NS_ASSUME_NONNULL_END
