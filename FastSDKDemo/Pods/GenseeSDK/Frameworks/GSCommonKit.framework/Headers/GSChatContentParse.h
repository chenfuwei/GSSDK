//
//  GSEmotionEscape.h
//  GSCommonKit
//
//  Created by net263 on 2019/8/12.
//  Copyright © 2019 gensee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GSChatContentParse : NSObject
@property (nonatomic, strong) NSDictionary *key2file; //emotion\emotion.smile.gif --> 微笑

@property (nonatomic, strong) NSDictionary *text2file; // 【微笑】--> emotion\emotion.smile.gif

@property (nonatomic, strong) NSDictionary *text2key; //【微笑】--> 微笑

@property (nonatomic, strong) NSMutableDictionary *emotionsData;

+ (GSChatContentParse *)sharedInstance;

// <IMG src="emotion\emotion.qq.gif" custom="false"> --> attachment + text
- (NSMutableAttributedString *) attributeStringFromHtml:(NSString *)html
                                        textFont:(UIFont*)font
                                       imageType:(NSString * _Nullable)type;

// 【表情】--> <IMG src="emotion\emotion.qq.gif" custom="false">
- (NSString *)htmlFromEmotionText:(NSString *)emotion;


+ (BOOL)stringContainsEmoji:(NSString *)string;

-(NSArray*) allEmotions;

- (NSArray *)all36Emotions;

@end

NS_ASSUME_NONNULL_END
