//
//  GSResponder.h
//  GSCommonKit
//
//  Created by net263 on 2020/11/5.
//  Copyright © 2020 gensee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, GSResponderStatus) {
    GSRESPONDER_PUBLISH,
    GSRESPONDER_SUCCESS,
    GSRESPONDER_CLOSE,
    GSRESPONDER_RESPONDER
};
@interface GSResponder : NSObject
@property(nonatomic, assign)GSResponderStatus status;
@property(nonatomic, assign)long long ownerId;   //所有者ID
@property(nonatomic, assign)long long successId;//抢答成功者ID
@property(nonatomic, copy)NSString* successName;//抢答成功者name
@property(nonatomic, assign)long long responderId;//抢答者ID
@end

@interface GSCommitResponder : NSObject
@property(nonatomic, assign)long long ownerId;   //所有者ID
@property(nonatomic, assign)long long responderId;   //抢答者ID

@end

NS_ASSUME_NONNULL_END
