//
//  GSChatMessage.h
//  RtSDK
//
//  Created by Gaojin Hsu on 3/24/15.
//  Copyright (c) 2015 Geensee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GSCommonKit/GSUserInfo.h>
#define GS_CHAT_CONTENTTYPE_PICTURE @"picture"
#define GS_CHAT_CONTENTTYPE_TEXT @"text"

typedef enum : NSUInteger {
    GSChatPublic,
    GSChatGuest,
    GSChatPrivate,
} GSChatType;

typedef enum : NSUInteger {
    GSText,
    GSPicture,
} GSChatContentType;
/**
 *  封装了文本聊天信息
 */
@interface GSChatMessage : NSObject

/**
 *  聊天数据的富文本字符串
 */
@property(strong, nonatomic)NSString* richText;

/**
 *  聊天数据的普通文本字符串
 */
@property(strong, nonatomic)NSString* text;

/**
 *  聊天数据的UUID
 */
@property(strong, nonatomic)NSString* msgID;

/**
 用户信息
 */
@property (strong, nonatomic) GSUserInfo* userInfo;

/**
 聊天类型
 */
@property (nonatomic, assign) GSChatType type;

/**
 聊天内容类型，文本或图片
 */
@property (nonatomic,assign)GSChatContentType contentType;

@end
