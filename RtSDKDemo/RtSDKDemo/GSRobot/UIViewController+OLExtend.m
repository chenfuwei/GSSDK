


//
//  UIViewController+OLExtend.m
//  OKLineDemo
//
//  Created by hxk on 17/4/5.
//  Copyright © 2017年 HZOL. All rights reserved.
//

#import "UIViewController+OLExtend.h"
@implementation UIViewController (OLExtend)
+(id)VCFromStoryBoardWithName:(NSString *)name WithIndentifier:(NSString *)indetifier;
{
    UIStoryboard *sb=[UIStoryboard storyboardWithName:name bundle:nil];
    if (indetifier) {
        return [sb instantiateViewControllerWithIdentifier:indetifier];
    }
    return [sb instantiateInitialViewController];
}
+(id)initialVCFromStoryBoardWithName:(NSString *)name;
{
    return [self VCFromStoryBoardWithName:name WithIndentifier:nil];
}
+(id)initialVCFromStoryBoard;
{
    return [self initialVCFromStoryBoardWithName:NSStringFromClass([self class])];
}
+(UIViewController *) currentViewController {
    UIViewController * viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [UIViewController findBestViewController:viewController];
}
//获取当前屏幕显示的viewcontroller
+(UIViewController *)findBestViewController:(UIViewController *)vc {
    if (vc.presentedViewController&&![vc.presentedViewController isKindOfClass:NSClassFromString(@"UIAlertController")]) {
        return [UIViewController findBestViewController:vc.presentedViewController];
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        UISplitViewController *svc = (UISplitViewController *) vc;
        if (svc.viewControllers.count > 0)
            return [UIViewController findBestViewController:svc.viewControllers.lastObject];
        else
            return vc;
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController *svc = (UINavigationController *) vc;
        if (svc.viewControllers.count > 0)
            return [UIViewController findBestViewController:svc.topViewController];
        else
            return vc;
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        UITabBarController *svc = (UITabBarController *) vc;
        if (svc.viewControllers.count > 0)
            return [UIViewController findBestViewController:svc.selectedViewController];
        else
            return vc;
    } else {
        return vc;
    }
}
-(void)ol_setItemTitleWithTitle:(NSString *)title;
{
    self.navigationItem.title=title;
}

- (BOOL)ol_isVisible {
    return [self isViewLoaded] && self.view.window;
}

-(void)ol_popMiddleVC;
{
    NSMutableArray *tempArr=[NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    if (tempArr.count<2) return;
    [tempArr removeObjectAtIndex:tempArr.count-2];
    [self.navigationController setViewControllers:tempArr animated:NO];
}
@end
