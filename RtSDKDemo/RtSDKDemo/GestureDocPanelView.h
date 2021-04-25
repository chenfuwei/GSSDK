//
//  GestureDocPanelView.h
//  G-live
//
//  Created by jiangcj on 16/10/27.
//  Copyright © 2016年 陈伯伦. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol GestureDocPanelViewDelegate <NSObject>

@optional

- (void)setAnnoMode:(int)annoMode;



@end



@interface GestureDocPanelView : UIView



@property (nonatomic, weak)id<GestureDocPanelViewDelegate> docPaneDelegate;

@property(nonatomic,strong)UIButton *openAnimationModeBtn;

@property(nonatomic,strong)UIButton *circleBtn;

@property(nonatomic,strong)UIButton *lineBtn;


@property(nonatomic,strong)UIButton *rectBtn;

@property(nonatomic,strong)UIButton *frenPenBtn;

@property(nonatomic,strong)UIButton *AnnoPointEx;

@property(nonatomic,strong)UIButton * clearBtn;


@property(nonatomic,assign)BOOL  isOpenAnnotation;


@end
