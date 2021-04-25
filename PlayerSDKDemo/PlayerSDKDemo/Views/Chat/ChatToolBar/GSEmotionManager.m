//
//  GSEmotionManager.m
//  RtSDKDemo
//
//  Created by Sheng on 2017/11/20.
//  Copyright © 2017年 gensee. All rights reserved.
//

#import "GSEmotionManager.h"

@implementation GSEmotionManager

- (id)initWithEmotionRow:(NSInteger)emotionRow
        emotionCol:(NSInteger)emotionCol
          emotions:(NSArray*)emotions
{
    self = [super init];
    if (self) {
        _emotionRow = emotionRow;
        _emotionCol = emotionCol;
        _emotions = emotions;
        _tagImage = nil;
    }
    return self;
}

- (id)initWithEmotionRow:(NSInteger)emotionRow
        emotionCol:(NSInteger)emotionCol
          emotions:(NSArray*)emotions
          tagImage:(UIImage*)tagImage

{
    self = [super init];
    if (self) {
        _emotionRow = emotionRow;
        _emotionCol = emotionCol;
        _emotions = emotions;
        _tagImage = tagImage;
    }
    return self;
}

@end
