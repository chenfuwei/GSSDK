//
//  GSBaseViewController.h
//  VodSDKDemo
//
//  Created by Sheng on 2018/8/3.
//  Copyright © 2018年 Gensee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+SetRect.h"
@interface GSBaseViewController : UIViewController

@property (nonatomic, assign) BOOL isTester;

- (UILabel *)createTagLabel:(NSString *)tagContent top:(CGFloat)top;
- (UILabel *)createTagLabel:(NSString *)tagContent top:(CGFloat)top left:(CGFloat)left;
- (UIView *)createWhiteBGViewWithTop:(CGFloat)top itemCount:(NSInteger)count;
@end
