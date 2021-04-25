//
//  OLCustomView.h
//  OkLine
//
//  Created by oule on 16/12/13.
//  Copyright © 2016年 ding juanjuan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MBProgressHUD;
@interface OLCustomView : NSObject

/**
 * 展示菊花
 * @param text 缓冲显示文字
 * @param view view对象
 */
+ (MBProgressHUD *)showHUDWithText:(NSString *)text toView:(UIView *)view;


/**
 展示菊花
 @param view 将添加在那个View上
 @return MBProgressHUD
 */
+(MBProgressHUD *)showHudToView:(UIView *)view;



/**
 *  隐藏缓冲视图
 *  @param view 对象
 */
+ (BOOL)hideHUDFromView:(UIView *)view;



/**
 MBProgressHUDModeText模式，仅展示文字
 @param text  显示文字
 @param view  将添加的视图
 @param Delay 显示时间
 @param afterHide 隐藏后调用该Block
 @return hud
 */
+(MBProgressHUD *)showText:(NSString *)text toView:(UIView *)view withAfterDelay:(CGFloat)Delay withBlock:(void(^)())afterHide;



/**
 MBProgressHUDModeText模式，仅展示文字，默认文字状态下Delay时间是3s
 @param text      hud显示的文字
 @param view      hud将要添加的视图
 @param afterHide 当hud隐藏后会调用该block
 */
+(MBProgressHUD *)showText:(NSString *)text toView:(UIView *)view withBlock:(void(^)())afterHide;



/**
 MBProgressHUDModeText模式，仅展示文字，默认文字状态下Delay时间是3s
 @param text      hud显示的文字
 @param view      hud将要添加的视图
 */
+(MBProgressHUD *)showText:(NSString *)text toView:(UIView *)view;

@end
