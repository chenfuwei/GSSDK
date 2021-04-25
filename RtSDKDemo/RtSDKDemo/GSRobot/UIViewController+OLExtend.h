//
//  UIViewController+OLExtend.h
//  OKLineDemo
//
//  Created by hxk on 17/4/5.
//  Copyright © 2017年 HZOL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (OLExtend)
/**
 从storyBord中加载是initial控制器
 @param name storyBord名字
 @return  UIViewController对象
 */
+(id)initialVCFromStoryBoardWithName:(NSString *)name;


/**
 从storyBord中加载是initial控制器
 @return  UIViewController对象
 */
+(id)initialVCFromStoryBoard;



/**
 从storyBord中加载不是initial的控制器
 @param name       storyBord名字
 @param indetifier 标识符
 @return UIViewController对象
 */
+(id)VCFromStoryBoardWithName:(NSString *)name WithIndentifier:(NSString *)indetifier;




/**
 获取当前屏幕显示的viewcontroller(不包含tabbar和nav)
 */
+(UIViewController *) currentViewController;


/**
 生成带有图片+文字的item的title
 @param title 导航栏标题的名字
 */
-(void)ol_setItemTitleWithTitle:(NSString *)title;


/**
 当前控制器的View是否可见
 */
- (BOOL)ol_isVisible;


/**
 *  pop栈中倒数第二个控制器
 */
-(void)ol_popMiddleVC;
@end
