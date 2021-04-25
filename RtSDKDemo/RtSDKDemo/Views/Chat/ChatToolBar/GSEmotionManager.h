//
//  GSEmotionManager.h
//  RtSDKDemo
//
//  Created by Sheng on 2017/11/20.
//  Copyright © 2017年 gensee. All rights reserved.
//

#import <Foundation/Foundation.h>

#define GENSEE_EMOTION_DEFAULT_EXT @"gs_emotion"

#define MESSAGE_ATTR_IS_BIG_EXPRESSION @"gs_is_big_expression"
#define MESSAGE_ATTR_EXPRESSION_ID @"gs_expression_id"

@interface GSEmotionManager : NSObject

@property (nonatomic, strong) NSArray *emotions;

/*!
 @property
 @brief number of lines of emotion
 */
@property (nonatomic, assign) NSInteger emotionRow;

/*!
 @property
 @brief number of columns of emotion
 */
@property (nonatomic, assign) NSInteger emotionCol;

@property (nonatomic, strong) UIImage *tagImage;

@property (nonatomic, assign) NSInteger emotionPageIndex;//表情所指向section


- (id)initWithEmotionRow:(NSInteger)emotionRow
        emotionCol:(NSInteger)emotionCol
          emotions:(NSArray*)emotions;

- (id)initWithEmotionRow:(NSInteger)emotionRow
        emotionCol:(NSInteger)emotionCol
          emotions:(NSArray*)emotions
          tagImage:(UIImage*)tagImage;

@end
