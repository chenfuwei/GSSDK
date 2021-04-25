//
//  GSRecordInfo.h
//  VodSDK
//
//  Created by net263 on 2020/10/23.
//  Copyright © 2020 gensee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GSRecordInfo : NSObject
@property(nonatomic, strong)NSString *startTime;
@property(nonatomic, strong)NSString *duration;
@property(nonatomic, strong)NSString *storage;
@end

NS_ASSUME_NONNULL_END
