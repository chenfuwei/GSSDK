//
//  GSChatView.h
//  RtSDKDemo
//
//  Created by Sheng on 2017/11/13.
//  Copyright © 2017年 gensee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSChatViewCell.h"

@interface GSChatView : UIView

@property (nonatomic, strong) NSMutableArray *dataModelArray;

//刷新视图
- (void)refresh;

//插入数据 并插入cell
- (void)insert:(GSChatModel*)model;
//插入数据 并插入cell
- (void)insert:(GSChatModel*)model forceBottom:(BOOL)isBottom;


@end
