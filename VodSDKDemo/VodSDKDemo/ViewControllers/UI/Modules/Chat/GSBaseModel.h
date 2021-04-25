//
//  GSBaseModel.h
//  RtSDKDemo
//
//  Created by Sheng on 2017/11/14.
//  Copyright © 2017年 gensee. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GSBaseModel : NSObject

@property (nonatomic, strong) NSString *info;//标题信息
@property (nonatomic, strong) NSString *timeStr;//时间信息
@property (nonatomic, strong) NSAttributedString *message;//显示内容
@property (strong, nonatomic) NSString *msgID; //消息id

@property (nonatomic, assign) CGFloat   infoHeight;
@property (nonatomic, assign) CGFloat   messageHeight;
@property (nonatomic, assign) CGFloat   totalHeight;

+ (CGFloat)heightWithString:(NSString *)string LabelFont:(UIFont *)font withLabelWidth:(CGFloat)width;

@end
