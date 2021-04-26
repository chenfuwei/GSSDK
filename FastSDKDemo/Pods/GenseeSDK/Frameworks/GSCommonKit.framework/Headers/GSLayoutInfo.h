//
//  GSLayoutInfo.h
//  GSCommonKit
//
//  Created by net263 on 2020/11/4.
//  Copyright © 2020 gensee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, GSLayoutModule) {
    GSLM_NOUSED,  //不使用
    GSLM_MEDIA,   //媒体共享
    GSLM_SBB,      //小黑板
    GSLM_VICECAMERA //辅助摄像头
};

typedef NS_ENUM(NSInteger, GSLayoutState) {
    GSLAYOUT_STATE_NORMAL,//常规窗口
    GSLAYOUT_STATE_MINIMIZE,//最小化
    GSLAYOUT_STATE_FULL = 3,  //最大化
};

@interface GSLayoutInfo : NSObject
@property(nonatomic, assign)GSLayoutModule layoutModule;
@property(nonatomic, assign)int m_index;//layout index of module
@property(nonatomic, assign)float m_fl;//left
@property(nonatomic, assign)float m_ft;//top
@property(nonatomic, assign)float m_fw;//width

@property(nonatomic, assign)float m_fh;//height

@property(nonatomic, assign)int m_zorder;//z-order
@property(nonatomic, assign)BOOL m_changed;
@property(nonatomic, assign)BOOL m_visible;//show or not show
@property(nonatomic, assign)BOOL m_full;//全屏，全屏的时候，窗口的标题栏去掉
@property(nonatomic, assign)long long m_owner;//窗口同步的发布者
@property(nonatomic, assign)GSLayoutState m_state;//窗口的状态
@end

NS_ASSUME_NONNULL_END
