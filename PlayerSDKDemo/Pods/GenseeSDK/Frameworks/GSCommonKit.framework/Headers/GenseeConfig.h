//
//  GenseeConfig.h
//  GSCommonKit
//
//  Created by net263 on 2019/5/16.
//  Copyright © 2019年 gensee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

UIKIT_EXTERN BOOL gsSwitchOnMainThread;//用于配置底层回调是否需要从heartBeat线程切换到主线程
#define GSASYNC_SWITCHMAINBYSTATUS(block) (gsSwitchOnMainThread && ![[NSThread currentThread] isMainThread]) ? dispatch_async(dispatch_get_main_queue(), block) : block();

#define __WEAKSELF __weak typeof(self) wSelf = self;
#define __STRONGSELF __strong typeof(self) sSelf = wSelf;

NS_ASSUME_NONNULL_END
