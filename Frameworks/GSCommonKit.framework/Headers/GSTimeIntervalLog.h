//
//  GSTimeIntervalLog.h
//  GSCommonKit
//
//  Created by net263 on 2021/4/1.
//  Copyright © 2021 gensee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GSTimeIntervalLog : NSObject
@property(nonatomic, copy)NSString* moduleName;   //需要打日志的模块
@property(nonatomic, assign)NSInteger timeInterval; //打日志的时间间隔，单位秒

-(instancetype)initWithTimeInterval:(NSInteger)timeInterval;

-(void)logCount:(void(^)(NSInteger total))block;//根据时长间隔统计调用次数
@end


NS_ASSUME_NONNULL_END
