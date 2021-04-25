//
//  GSFastBaseViewController.h
//  FastDemo
//
//  Created by Sheng on 2018/7/31.
//  Copyright © 2018年 263. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+SetRect.h"

@interface GSFastBaseViewController : UIViewController

- (UILabel *)createTagLabel:(NSString *)tagContent top:(CGFloat)top;

- (UILabel *)createTagLabel:(NSString *)tagContent top:(CGFloat)top left:(CGFloat)left;

- (UIView *)createWhiteBGViewWithTop:(CGFloat)top itemCount:(NSInteger)count;

@end
