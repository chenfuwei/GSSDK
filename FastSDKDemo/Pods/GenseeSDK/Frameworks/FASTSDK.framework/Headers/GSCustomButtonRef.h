//
//  GSCustomButtonRef.h
//  FASTSDK
//
//  Created by Sheng on 2018/7/5.
//  Copyright © 2018年 Gensee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSCustomButtonRef : NSObject
- (NSComparisonResult)compareCustomButtonRef:(GSCustomButtonRef *)customButton;

#pragma mark - 分屏下的右上角内容

/**
 右上角更多标题
 */
@property (nonatomic, strong) NSString* title;

/**
 右上角更多的图片
 */
@property (nonatomic, strong) UIImage* moreImage;

#pragma mark - 全屏下的右侧按钮

/**
 button normal状态图片  推荐图片 2x 尺寸为88x88
 */
@property (nonatomic, strong) UIImage* normalImage;
/**
 button 选择状态图片
 */
@property (nonatomic, strong) UIImage* selectedImage;
/**
 button 背景图片
 */
@property (nonatomic, strong) UIImage* normalBackground;
/**
 button 选择背景图片
 */
@property (nonatomic, strong) UIImage* selectedBackground;
/**
 使用与gensee风格一致的backgroundImage
 */
@property (nonatomic, assign) BOOL useGenseeStyle;

/**
 按钮显示的顺序
 */
@property(nonatomic, assign) int sortIndex;//显示序号，用于排序 5， 15， 20， 25， 30，35， 40，45， 50， SDK内部已使用。

@end
