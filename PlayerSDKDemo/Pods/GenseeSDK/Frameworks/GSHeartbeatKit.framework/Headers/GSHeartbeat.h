//
//  GSHeartbeat.h
//  RtSDK
//
//  Created by net263 on 2019/5/14.
//  Copyright © 2019年 Geensee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSHeartbeatDelegate.h"
NS_ASSUME_NONNULL_BEGIN

@interface GSHeartbeat : NSObject
-(void)startHeartbeat;
-(void)stopHeartbeat;
-(BOOL)addTask:(QueueBlock)block;
-(void)setCastHeartbeat:(HeartbeatBlock)heartbeatBlock;
@end

NS_ASSUME_NONNULL_END
