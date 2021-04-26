//
//  GSMarquee.h
//  MineDemo
//
//  Created by net263 on 2020/9/22.
//  Copyright © 2020 net263. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, GSMarqueeSpeed) {
    GSMarqueeSpeed_1,
    GSMarqueeSpeed_2,
    GSMarqueeSpeed_3,
    GSMarqueeSpeed_4,
    GSMarqueeSpeed_5
};

@interface GSMarquee : NSObject
@property(nonatomic, copy)NSString *content;   //跑马灯内容，最长100，超过100则截取
@property(nonatomic, assign)GSMarqueeSpeed speed; //跑马灯速度
@property(nonatomic, assign)CGFloat fontSize; //跑马灯内容字体大小
@property(nonatomic, strong)UIColor *fontColor;//跑马灯内容字体颜色
@end

NS_ASSUME_NONNULL_END
