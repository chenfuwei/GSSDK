//
//  GSHeartbeatDelegate.h
//  GSHeartbeatKit
//
//  Created by net263 on 2019/5/16.
//  Copyright © 2019年 gensee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^TaskBlock)(BOOL, int) ;
typedef void(^QueueBlock)();
typedef void(^HeartbeatBlock)();
@protocol GSHeartbeatDelegate <NSObject>
-(void)startHeartbeat;
-(void)stopHeartbeat;
-(BOOL)addTask:(QueueBlock)block;
-(void)setCastHeartbeat:(HeartbeatBlock)heartbeatBlock;
@end

NS_ASSUME_NONNULL_END
