//
//  TaggingMarkView.h
//  G-live
//
//  Created by jiangcj on 2017/9/18.
//  Copyright © 2017年 263. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSTagButton.h"

@protocol TaggingMarkViewDelegate <NSObject>
@optional
- (void)startTagDoc:(BOOL)isBegin;  //开始标注
@end

@interface TaggingMarkView : UIView 
@property (nonatomic,strong) GSTagButton *undo;//上一步
@property (nonatomic,strong) GSTagButton *redo;//下一步
@property (nonatomic,strong) UIView *topPenView;//顶部的笔的尺寸与颜色选择view
@property (nonatomic,assign) BOOL  isLand;  //是否横屏,
@property(nonatomic,copy)void(^topButton)(GSTagStyle style);
@property(nonatomic,copy)void(^valueChange)(UIColor *color);



-(void)hideTopView;
-(void)showTopView;
-(void)publishShowNowTopview;
-(void)restoreOriginalStatus;
@property (nonatomic, assign) id<TaggingMarkViewDelegate> delegate;
-(void)setTaggingMarkViewHidde:(BOOL)isHide;//设置隐藏显示
-(void)updateFrameByChange;
-(void)keepStatusWithoutNet;
-(void)recoveryStatusWithNet;
@property (nonatomic,assign) BOOL  isKeepStatus;
@property (nonatomic,assign) BOOL  isRedoEnabled;
@property (nonatomic,assign) BOOL  isUndoEnabled;
@end
