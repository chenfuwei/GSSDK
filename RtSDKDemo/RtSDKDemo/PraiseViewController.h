//
//  PraiseViewController.h
//  RtSDKDemo
//
//  Created by Sheng on 2018/6/15.
//  Copyright © 2018年 gensee. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import "BaseItemViewController.h"

@interface GSPraiseModel : NSObject
@property (nonatomic, strong) GSPraiseUserInfo *modalInfo;
@property (nonatomic, strong) GSUserInfo *userInfo;
@end

@interface GSPraiseViewCell : UITableViewCell
@property (nonatomic, strong) GSPraiseUserInfo *modalInfo;
@property (nonatomic, strong) UILabel *favour;
@property (nonatomic, strong) UILabel *modal;
@end
@interface PraiseViewController : BaseItemViewController
@end
