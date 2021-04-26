//
//  GSHeartbeatFactory.h
//  GSHeartbeatKit
//
//  Created by net263 on 2019/5/16.
//  Copyright © 2019年 gensee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSHeartbeatDelegate.h"
NS_ASSUME_NONNULL_BEGIN

@interface GSHeartbeatFactory : NSObject
/**
 * 初始化单实例
 */
+ (nonnull id<GSHeartbeatDelegate>)instanceHeartbeat;
@end

NS_ASSUME_NONNULL_END
