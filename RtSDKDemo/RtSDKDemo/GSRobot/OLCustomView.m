//
//  OLCustomView.m
//  OkLine
//
//  Created by oule on 16/12/13.
//  Copyright © 2016年 ding juanjuan. All rights reserved.
//

#import "OLCustomView.h"
#define OLCustomViewHudDuration 0.5f
@implementation OLCustomView
+(void)initialize
{
    MBProgressHUD *hud=[MBProgressHUD appearance];
}
+ (MBProgressHUD *)showHUDWithText:(NSString *)text toView:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *hud=[self basicConfigurationToView:view];
    hud.labelText = text;
    return hud;
}


+ (BOOL)hideHUDFromView:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
     return [MBProgressHUD hideHUDForView:view animated:YES];
}

+(MBProgressHUD *)showHudToView:(UIView *)view;
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    return [self basicConfigurationToView:view];
}

+(MBProgressHUD *)showText:(NSString *)text toView:(UIView *)view withBlock:(void(^)())afterHide;
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *hud=[self creatTextModeWithText:text toView:view withBlock:afterHide];
    [hud hide:YES afterDelay:OLCustomViewHudDuration];
    return hud;
}

+(MBProgressHUD *)showText:(NSString *)text toView:(UIView *)view withAfterDelay:(CGFloat)Delay withBlock:(void(^)())afterHide;
{
    MBProgressHUD *hud=[self creatTextModeWithText:text toView:view withBlock:afterHide];
    [hud hide:YES afterDelay:Delay];
    return hud;
}

+(MBProgressHUD *)showText:(NSString *)text toView:(UIView *)view;
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    MBProgressHUD *hud=[self creatTextModeWithText:text toView:view withBlock:nil];
    [hud hide:YES afterDelay:OLCustomViewHudDuration];
    return hud;
}


/**
 初始化hud<指定模式Text>
 @param view 显示在哪个View上面
 @return MBProgressHUD
 */
+(MBProgressHUD *)creatTextModeWithText:(NSString *)text toView:(UIView *)view withBlock:(void(^)())afterHide;
{
    if ([MBProgressHUD HUDForView:view]) {
        [self hideHUDFromView:view];
    }
    MBProgressHUD *hud=[self basicConfigurationToView:view];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    hud.completionBlock=^{
        !afterHide?:afterHide();
    };
    return hud;
}


/**
 所有hud的基本配置<默认模式Indeterminate>
 @param view 显示在哪个View上面
 @return MBProgressHUD
 */
+(MBProgressHUD *)basicConfigurationToView:(UIView *)view
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.graceTime=1.5f;
    return hud;
}

@end
