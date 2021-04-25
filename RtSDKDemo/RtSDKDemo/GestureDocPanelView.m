//
//  GestureDocPanelView.m
//  G-live
//  Created by jiangcj on 16/10/27.
//  Copyright © 2016年 陈伯伦. All rights reserved.
#import "GestureDocPanelView.h"
@implementation GestureDocPanelView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        NSBundle *resourceBundle = [NSBundle bundleWithPath: [[NSBundle mainBundle] pathForResource:@"RtSDK" ofType:@"bundle"]];
        
        
        UIImage*   pencilImage = [UIImage imageWithContentsOfFile:[resourceBundle pathForResource:@"pencil@2x" ofType:@"png"]];
        
        
        _openAnimationModeBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        [_openAnimationModeBtn addTarget:self action:@selector(openAnimationClick:) forControlEvents:UIControlEventTouchUpInside];
        [_openAnimationModeBtn setImage:pencilImage forState:UIControlStateNormal];
        //[_openAnimationModeBtn setBackgroundImage:pencilImage forState:UIControlStateNormal];
        [_openAnimationModeBtn setImage:pencilImage forState:UIControlStateSelected];
        
        [self addSubview:_openAnimationModeBtn];
        
        
        
        _circleBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        [_circleBtn addTarget:self action:@selector(circleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_circleBtn setImage:pencilImage forState:UIControlStateNormal];
       // [_circleBtn setBackgroundImage:pencilImage forState:UIControlStateNormal];
        [_circleBtn setImage:pencilImage forState:UIControlStateSelected];
        [self addSubview:_circleBtn];
        _circleBtn.hidden=YES;
        
        
        _lineBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        [_lineBtn addTarget:self action:@selector(lineBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_lineBtn setImage:pencilImage forState:UIControlStateNormal];
       // [_lineBtn setBackgroundImage:pencilImage forState:UIControlStateNormal];
        [_lineBtn setImage:pencilImage forState:UIControlStateSelected];
        [self addSubview:_lineBtn];
        
        _lineBtn.hidden=YES;
        
        _rectBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        [_rectBtn addTarget:self action:@selector(rectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_rectBtn setImage:pencilImage forState:UIControlStateNormal];
        //[_rectBtn setBackgroundImage:pencilImage forState:UIControlStateNormal];
        [_rectBtn setImage:pencilImage forState:UIControlStateSelected];
        [self addSubview:_rectBtn];
        
        _rectBtn.hidden=YES;
        
        
        
        _frenPenBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        [_frenPenBtn addTarget:self action:@selector(frenPenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_frenPenBtn setImage:pencilImage forState:UIControlStateNormal];
       // [_frenPenBtn setBackgroundImage:pencilImage forState:UIControlStateNormal];
        [_frenPenBtn setImage:pencilImage forState:UIControlStateSelected];
        [self addSubview:_frenPenBtn];
        _frenPenBtn.hidden=YES;
        
        _AnnoPointEx= [UIButton buttonWithType:UIButtonTypeCustom];
        [_AnnoPointEx addTarget:self action:@selector(AnnoPointExClick:) forControlEvents:UIControlEventTouchUpInside];
        [_AnnoPointEx setImage:pencilImage forState:UIControlStateNormal];
     //   [_AnnoPointEx setBackgroundImage:pencilImage forState:UIControlStateNormal];
        [_AnnoPointEx setImage:pencilImage forState:UIControlStateSelected];
        [self addSubview:_AnnoPointEx];
        _AnnoPointEx.hidden=YES;
        
        _clearBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        [_clearBtn addTarget:self action:@selector(clearBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_clearBtn setImage:pencilImage forState:UIControlStateNormal];
      //  [_clearBtn setBackgroundImage:pencilImage forState:UIControlStateNormal];
        [_clearBtn setImage:pencilImage forState:UIControlStateSelected];
        [self addSubview:_clearBtn];
        _clearBtn.hidden=YES;
        
        
        
        
    }
    return self;
}




-(void)openAnimationClick:(UIButton*)sender
{
    
    if ([self.docPaneDelegate respondsToSelector:@selector(setAnnoMode:)]) {
        [self.docPaneDelegate setAnnoMode:1];
    }
    
}


-(void)circleBtnClick:(UIButton*)sender
{
    
    if ([self.docPaneDelegate respondsToSelector:@selector(setAnnoMode:)]) {
        [self.docPaneDelegate setAnnoMode:2];
    }
    
    
}


-(void)lineBtnClick:(UIButton*)sender
{
    
    if ([self.docPaneDelegate respondsToSelector:@selector(setAnnoMode:)]) {
        [self.docPaneDelegate setAnnoMode:3];
    }
    
    
}






-(void)rectBtnClick:(UIButton*)sender
{
    if ([self.docPaneDelegate respondsToSelector:@selector(setAnnoMode:)]) {
        [self.docPaneDelegate setAnnoMode:4];
    }
    
    
}


-(void)frenPenBtnClick:(UIButton*)sender
{
    
    if ([self.docPaneDelegate respondsToSelector:@selector(setAnnoMode:)]) {
        [self.docPaneDelegate setAnnoMode:5];
    }
    
}



-(void)AnnoPointExClick:(UIButton*)sender
{
    
    if ([self.docPaneDelegate respondsToSelector:@selector(setAnnoMode:)]) {
        [self.docPaneDelegate setAnnoMode:6];
    }
    
}


-(void)clearBtnClick:(UIButton*)sender
{
    
    if ([self.docPaneDelegate respondsToSelector:@selector(setAnnoMode:)]) {
        [self.docPaneDelegate setAnnoMode:7];
    }
}



-(void)setIsOpenAnnotation:(BOOL)isOpenAnnotation
{
    _isOpenAnnotation=isOpenAnnotation;
    if (_isOpenAnnotation) {
        _circleBtn.hidden=NO;
        _lineBtn.hidden=NO;
        _rectBtn.hidden=NO;
        _frenPenBtn.hidden=NO;
        _AnnoPointEx.hidden=NO;
        _clearBtn.hidden=NO;
        
    }else{
        
        _circleBtn.hidden=YES;
        _lineBtn.hidden=YES;
        _rectBtn.hidden=YES;
        _frenPenBtn.hidden=YES;
        _AnnoPointEx.hidden=YES;
        _clearBtn.hidden=YES;
    }
    
    
}





-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat  internal=10;
    
    
    CGFloat btnW=25;
    CGFloat btnH=44;
    
    
    _openAnimationModeBtn.frame=CGRectMake(internal, 0, btnW, btnH);
    _circleBtn.frame=CGRectMake(btnW+2*internal, 0, btnW, btnH);
    _lineBtn.frame=CGRectMake(2*btnW+3*internal, 0, btnW, btnH);
    _rectBtn.frame=CGRectMake(3*btnW+4*internal, 0, btnW, btnH);
    _frenPenBtn.frame=CGRectMake(4*btnW+5*internal, 0, btnW, btnH);
    
    _AnnoPointEx.frame=CGRectMake(5*btnW+6*internal, 0, btnW, btnH);
    
    
    _clearBtn.frame=CGRectMake(CGRectGetMaxX(_AnnoPointEx.frame), 0, btnW, btnH);
    NSLog(@"%@---%@---%@",NSStringFromCGRect(_lineBtn.frame),NSStringFromCGRect(_rectBtn.frame),NSStringFromCGRect(_frenPenBtn.frame));
    
    
}






@end
