//
//  GSTagButton.h
//  G-live
//
//  Created by Sheng on 2017/9/27.
//  Copyright © 2017年 263. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    GSTagNone = 0,  //无
    GSTagPenThin = 1 << 0,   //笔 - 细线
    GSTagPenMiddle = 1 << 1, //笔 - 中等线
    GSTagPenThick = 1 << 2,  //笔 - 粗线
    GSTagPen = 1 << 3,       //笔(图案)
    GSTagEraser = 1 << 4,    //橡皮
    GSTagTrash = 1 << 5,     //垃圾桶
    GSTagUndo = 1 << 6,      //撤销
    GSTagRedo = 1 << 7,      //撤回
    GSTagClose = 1 << 8,     //关闭
} GSTagStyle;

@interface GSTagButton : UIButton

@property (nonatomic, assign) GSTagStyle style;

- (instancetype)initWithFrame:(CGRect)frame style:(GSTagStyle)style;

@end
