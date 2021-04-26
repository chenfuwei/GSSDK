//
//  GSCountDownCmd.h
//  GSCommonKit
//
//  Created by net263 on 2020/11/5.
//  Copyright © 2020 gensee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, GSCountDownStatus) {
    GSCD_CLOSE,
    GSCD_BEGIN,
    GSCD_PAUSE
};
@interface GSCountDownCmd : NSObject
@property(nonatomic, assign)GSCountDownStatus status; //计时器状态
@property(nonatomic, assign)long long userId;  //发起计时器用户ID
@property(nonatomic, assign)int time; //计时器时长
@end

NS_ASSUME_NONNULL_END
