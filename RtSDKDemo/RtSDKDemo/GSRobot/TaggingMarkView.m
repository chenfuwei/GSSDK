//
//  TaggingMarkView.m
//  G-live
//
//  Created by jiangcj on 2017/9/18.
//  Copyright © 2017年 263. All rights reserved.
//

#import "TaggingMarkView.h"
#import "GSTagButton.h"
#import "SMColorSlider.h"
#define PenSizeSmall   1    //笔-粗细1
#define PenSizeMid   3    //笔-粗细3
#define PenSizeBig   6    //笔-粗细6
#define RGBFromHexadecimal(value) [UIColor colorWithRed:((float)((value & 0xFF0000) >> 16))/255.0 green:((float)((value & 0xFF00) >> 8))/255.0 blue:((float)(value & 0xFF))/255.0 alpha:1.0]
#define GAP 10
#define GAP_B 2.5
#define ITEM_H 44
#define ITEM_W (44)
@interface TaggingMarkView ()
@property (strong,nonatomic) SMColorSlider * customSlider;  //颜色选择
// -------  buttons  -----------
@property (nonatomic,strong) GSTagButton *pen;//笔
@property (nonatomic,strong) GSTagButton *eraser;//橡皮擦
@property (nonatomic,strong) GSTagButton *trash;//删除
@property (nonatomic,strong) GSTagButton *close;//下一步
@property (nonatomic,strong) GSTagButton *thin;//下一步
@property (nonatomic,strong) GSTagButton *middle;//下一步
@property (nonatomic,strong) GSTagButton *thick;//下一步
@property (nonatomic,strong) UIView *bottomView;//后四个按钮的bg
@end


@implementation TaggingMarkView
{
    int itemGap;
    int bottomCount;
    
    GSTagStyle bottomStyle;
    
    BOOL isAnnoStatu; //是否是标注状态
}
static int getModuleCount(int style){  //获取模块个数
    
    int c = 0;
    while (style > 0) {
        if ((style&1) == 1) {
            c++;
        }
        style >>= 1;
    }
    return c;
}




- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setTopView];
        [self setBottomView];
    }
    return self;
}



-(void)setTopView{
    
    _topPenView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, ITEM_H)];
    _topPenView.accessibilityLabel=@"_topPenView";
#if OPEN_THEME
    [_topPenView setZh_backgroundColorPicker:ThemePickerWithKey(GSThemeColorDocColorSelectorBack)];
#else
    _topPenView.backgroundColor=[UIColor blackColor];
#endif
    
    [self addSubview:_topPenView];
    
       GSTagStyle pens = GSTagPenThick | GSTagPenMiddle ;
    UIView *pView = nil;
    
    if (pens & GSTagPenThin) {
        _thin = [[GSTagButton alloc]initWithFrame:CGRectMake(0, 0, ITEM_W, ITEM_H) style:GSTagPenThin];
        [_thin addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        pView = _thin;
        [_topPenView addSubview:_thin];
    }
    if (pens & GSTagPenMiddle) {
        
        CGFloat X = 0;
        
        if (pView) {
            X = pView.frame.origin.x + pView.frame.size.width;
        }
        _middle = [[GSTagButton alloc]initWithFrame:CGRectMake(X, 0, ITEM_W, ITEM_H) style:GSTagPenMiddle];
        [_middle addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_topPenView addSubview:_middle];
        _middle.selected = YES;
        pView = _middle;
    }
    if (pens & GSTagPenThick) {
        CGFloat X = 0;
        
        if (pView) {
            X = pView.frame.origin.x + pView.frame.size.width;
        }
        _thick = [[GSTagButton alloc]initWithFrame:CGRectMake(X, 0, ITEM_W, ITEM_H)style:GSTagPenThick];
        [_thick addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_topPenView addSubview:_thick];
        
        pView = _thick;
    }
    
    
    _customSlider = [[SMColorSlider alloc]initWithFrame:CGRectMake(pView.frame.origin.x + pView.frame.size.width + 8, 8, _topPenView.frame.size.width-ITEM_W*2 - 8 -8,  _topPenView.frame.size.height - 16) colors:nil];
    
    [_customSlider addTarget:self action:@selector(sliderValuechange:) forControlEvents:UIControlEventValueChanged];
    [_customSlider addTarget:self action:@selector(sliderValuechangeInside:) forControlEvents:UIControlEventTouchUpInside];
    [_topPenView addSubview:_customSlider];
    
    _topPenView.hidden=YES;
}

- (CGFloat)getItemsGap{
    
    bottomCount = getModuleCount(bottomStyle);
    
    CGFloat MaxL = MAX(self.frame.size.width, self.frame.size.height);
    
    return (MaxL - bottomCount*ITEM_W - 20)/(bottomCount - 1);
}


- (void)resetSubViewsByLandscape:(BOOL)isLand{
    
    
    
    itemGap = [self getItemsGap];
        UIView *pView = nil;
    if (isLand) {
        CGFloat Y = 0;
        _topPenView.frame = CGRectMake(49, 0, ITEM_W, self.frame.size.height);
        
        if (_thin) {
            _thin.frame = CGRectMake(0, 0, ITEM_W, ITEM_H);
            Y = ITEM_H;
              pView = _thin;
        }
        if (_middle) {
            if (pView) {
                Y= pView.frame.origin.y + pView.frame.size.height;
            }
            _middle.frame = CGRectMake(0, Y, ITEM_W, ITEM_H);
            Y = 2*ITEM_H;
             pView = _middle;
        }
        if (_thick) {
            if (pView) {
                Y = pView.frame.origin.y + pView.frame.size.height;
            }
            _thick.frame = CGRectMake(0, Y, ITEM_W, ITEM_H);
            Y = 3*ITEM_H;
             pView = _thick;
        }
        if (pView) {
            Y = pView.frame.origin.y + pView.frame.size.height;
        }
        _customSlider.frame = CGRectMake(8, Y + 8, _topPenView.frame.size.height - Y - 8 - 8,  _topPenView.frame.size.width - 16);
        
        [_customSlider setLandscape:YES];
        
        Y = 0;
        
        _bottomView.frame = CGRectMake(0, 0, 49, self.frame.size.height);
        
        if (_pen) {
            [_pen setFrame:CGRectMake(GAP_B, GAP, ITEM_W, ITEM_H)];
            
            Y = Y + GAP + ITEM_W + itemGap;
        }
        
        if (_eraser) {
            [_eraser setFrame:CGRectMake(GAP_B, Y, ITEM_W, ITEM_H)];
            
            Y = Y + itemGap + ITEM_W;
        }
        
        if (_trash) {
            [_trash setFrame:CGRectMake(GAP_B, Y, ITEM_W, ITEM_H)];
            
            Y = Y + itemGap + ITEM_W;
        }
        
        if (_undo) {
            [_undo setFrame:CGRectMake(GAP_B, Y, ITEM_W, ITEM_H)];
            
            Y = Y + itemGap + ITEM_W;
        }
        
        if (_redo) {
            [_redo setFrame:CGRectMake(GAP_B, Y, ITEM_W, ITEM_H)];
            
            Y = Y + itemGap + ITEM_W;
        }
        if (_close) {
            [_close setFrame:CGRectMake(GAP_B, Y, ITEM_W, ITEM_H)];
            
            Y = Y + itemGap + ITEM_W;
        }
    }else{
        CGFloat X = 0;
        _topPenView.frame = CGRectMake(0, 0, self.frame.size.width, ITEM_H);
        
        
        if (_thin) {
            _thin.frame = CGRectMake(0, 0, ITEM_W, ITEM_H);
            X = ITEM_H;
              pView = _thin;
        }
        if (_middle) {
            if (pView) {
                X= pView.frame.origin.x + pView.frame.size.width;
            }
            _middle.frame = CGRectMake(X, 0, ITEM_W, ITEM_H);
            X = 2*ITEM_H;
            pView=_middle;
        }
        if (_thick) {
            if (pView) {
                X= pView.frame.origin.x + pView.frame.size.width;
            }
            _thick.frame = CGRectMake(X, 0, ITEM_W, ITEM_H);
            X = 3*ITEM_H;
            pView=_thick;
        }
        if (pView) {
            X= pView.frame.origin.x + pView.frame.size.width;
        }
        
        [_customSlider setLandscape:NO];
        
        _customSlider.frame = CGRectMake(ABS(X) + 8, 8, self.frame.size.width - X - 8 - 8,  _topPenView.frame.size.height - 16);
        
        X = 0;
        
        _bottomView.frame = CGRectMake(0, 44, self.frame.size.width, 49);
        
        if (_pen) {
            [_pen setFrame:CGRectMake(GAP, GAP_B, ITEM_W, ITEM_H)];
            
            X = GAP + ITEM_W +itemGap;
        }
        
        if (_eraser) {
            [_eraser setFrame:CGRectMake(X, GAP_B, ITEM_W, ITEM_H)];
            
            X = X + itemGap + ITEM_W;
        }
        
        if (_trash) {
            [_trash setFrame:CGRectMake(X, GAP_B, ITEM_W, ITEM_H)];
            
            X = X + itemGap + ITEM_W;
        }
        
        if (_undo) {
            [_undo setFrame:CGRectMake(X, GAP_B, ITEM_W, ITEM_H)];
            
            
            X = X + itemGap + ITEM_W;
        }
        
        if (_redo) {
            [_redo setFrame:CGRectMake(X, GAP_B, ITEM_W, ITEM_H)];
            
            
            X = X + itemGap + ITEM_W;
        }
        if (_close) {
            [_close setFrame:CGRectMake(X, GAP_B, ITEM_W, ITEM_H)];
            
            X = X + itemGap + ITEM_W;
        }
        
    }
    
}




- (void)sliderValuechange:(SMColorSlider*)sender {
    NSLog(@"sliderValuechange");
    if (self.valueChange) {
        self.valueChange(sender.selectColor);
    }
}

-(void)sliderValuechangeInside:(SMColorSlider*)sender {
    NSLog(@"sliderValuechangeInside");
    if (self.valueChange) {
        self.valueChange(sender.selectColor);
    }

}


-(void)setBottomView{
    
    
    GSTagStyle style = GSTagPen | GSTagTrash | GSTagEraser | GSTagUndo | GSTagRedo;
    _bottomView =  [[UIView alloc]initWithFrame:CGRectMake(0, 44, self.frame.size.width, 49)];
    _bottomView.accessibilityLabel=@"_bottomView";
    [self addSubview:_bottomView];
#if OPEN_THEME
    [_bottomView setZh_backgroundColorPicker:ThemePickerWithKey(GSThemeColorDocAnnocBack)];
#else
    _bottomView.backgroundColor=RGBFromHexadecimal(0x262626);
#endif
    
    
    CGFloat X = 0;
    
    bottomStyle = style;
    
    itemGap = [self getItemsGap];
    
    if (style & GSTagPen) {
        _pen = [[GSTagButton alloc]initWithFrame:CGRectMake(GAP, GAP_B, ITEM_W, ITEM_H) style:GSTagPen];
        [_pen addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:_pen];
        X = GAP + ITEM_W +itemGap;
        [self penClick:_pen];
    }
    
    
    if (style & GSTagTrash) {
        _trash = [[GSTagButton alloc]initWithFrame:CGRectMake(X, GAP_B, ITEM_W, ITEM_H) style:GSTagTrash];
        [_trash addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:_trash];
        X = X + itemGap + ITEM_W;
    }
    
    
    if (style & GSTagEraser) {
        _eraser = [[GSTagButton alloc]initWithFrame:CGRectMake(X, GAP_B, ITEM_W, ITEM_H) style:GSTagEraser];
        [_eraser addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:_eraser];
        X = X + itemGap + ITEM_W;
    }
    

    
    if (style & GSTagUndo) {
        _undo = [[GSTagButton alloc]initWithFrame:CGRectMake(X, GAP_B, ITEM_W, ITEM_H) style:GSTagUndo];
        [_undo addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _undo.enabled=NO;
        [_bottomView addSubview:_undo];
        X = X + itemGap + ITEM_W;
    }
    
    if (style & GSTagRedo) {
        _redo = [[GSTagButton alloc]initWithFrame:CGRectMake(X, GAP_B, ITEM_W, ITEM_H) style:GSTagRedo];
        _redo.enabled=NO;
        [_redo addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:_redo];
        X = X + itemGap + ITEM_W;
        
    }
    if (style & GSTagClose) {
        _close = [[GSTagButton alloc]initWithFrame:CGRectMake(X, GAP_B, ITEM_W, ITEM_H) style:GSTagClose];
        [_close addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:_close];
        X = X + itemGap + ITEM_W;
    }
    
    
    
    
}


- (void)btnClick:(GSTagButton*)btn{

    switch (btn.style) {
        case GSTagClose:{
            [self exitTraging:btn];
        }
            break;
        case GSTagPen:{
            [self penClick:btn];
        }
            break;
            
        case GSTagPenThin:{
            btn.selected = YES;
            _middle.selected = NO;
            _thick.selected = NO;
        }
            break;
            
        case GSTagPenMiddle:{
            btn.selected = YES;
            _thin.selected = NO;
            _thick.selected = NO;
        }
            break;
            
        case GSTagPenThick:{
            btn.selected = YES;
            _middle.selected = NO;
            _thin.selected = NO;
        }
            break;
        case GSTagEraser:{
        
            
        }
            break;
        case GSTagTrash:{
            [self deleteButtonClick];
            _eraser.selected=NO;
            
        }
            break;
        case GSTagUndo:{
        }
            break;
        case GSTagRedo:{
            
        }
            break;
            
        default:
            break;
    }
    
    if (self.topButton) {
        self.topButton(btn.style);
    }
    
}

/**
 退出文档标注
 */
-(void)exitTraging:(UIButton *)sender{
    
    
    NSLog(@"exittraging*******");
    
    [self packUp];
    
    _pen.selected=NO;
    _eraser.selected=NO;

}


-(void)publishShowNowTopview
{
    
    _pen.selected=YES;
    _topPenView.hidden=NO;
    _customSlider.hidden=NO;
    
    
    isAnnoStatu = YES;
    
    [self setUpAnnotationMode:YES];
    _trash.selected=NO;
    
    if ([self.delegate respondsToSelector:@selector(startTagDoc:)]) {
        [self.delegate startTagDoc:YES];
    }
    
}


/**
 笔按钮点击
 
 @param sender 按钮
 */
- (void)penClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    _eraser.selected=NO;
    if (sender.selected) {
        
        _topPenView.hidden=NO;
        _customSlider.hidden=NO;
        
        
        isAnnoStatu = YES;
        
        [self setUpAnnotationMode:YES];
        _trash.selected=NO;
        
        if ([self.delegate respondsToSelector:@selector(startTagDoc:)]) {
            [self.delegate startTagDoc:YES];
        }
        
    
        
    }else { //收起
        
             isAnnoStatu = NO;
             _topPenView.hidden=YES;
             _customSlider.hidden=YES;
            [self setUpAnnotationMode:NO];
        
        //开启标注功能
        if ([self.delegate respondsToSelector:@selector(startTagDoc:)]) {
            [self.delegate startTagDoc:NO];
        }
    
    }
    
    
}


-(void)packUp{
    
    _topPenView.hidden=YES;
    _customSlider.hidden=YES;
    [self setUpAnnotationMode:NO];
    if ([self.delegate respondsToSelector:@selector(startTagDoc:)]) {
        [self.delegate startTagDoc:NO];
    }
    _pen.selected=NO;
}




-(void)hideTopView{
    
    _topPenView.hidden=YES;
    _customSlider.hidden=YES;
}

-(void)showTopView{
    
    _topPenView.hidden=NO;
    _customSlider.hidden=NO;
}


//
///**
// 笔尖粗细
// 
// @param sender 按钮
// */
//- (void)tipClick:(UIButton *)sender {
//    if (sender.selected) {
//        return;
//    }
//    
//    sender.selected = YES;
////    _tipButton.selected = NO;
////    _tipButton = sender;
//    
//    
//    switch (sender.tag) {
//        case TipTAG+0:
//            [RoomModel.selfView.docView.gsDocView  setupDocAnnoLineSize:PenSizeSmall];
//            break;
//        case TipTAG+1:
//            [RoomModel.selfView.docView.gsDocView  setupDocAnnoLineSize:PenSizeMid];
//            break;
//        case TipTAG+2:
//            [RoomModel.selfView.docView.gsDocView  setupDocAnnoLineSize:PenSizeBig];
//            break;
//            
//        default:
//            break;
//    }
//}
//
///**
// 点击笔后面的按钮
// 
// @param sender 按钮
// */
//- (void)clearTypeClick:(UIButton *)sender {
//    switch (sender.tag) {
//        case OriginalTAG://橡皮擦
//            sender.selected = !sender.selected;
//            
//            /*
//            [self rubberButtonClick];
//            JCJLog(@"sender.selected =%d",sender.selected);
//            [self putAwayPen:sender.selected];
//            */
//            
//            [self rubberButtonClick];
//            JCJLog(@"sender.selected =%d",sender.selected);
//            
//            break;
//        case OriginalTAG+1://垃圾桶
//           
//            /*
//            [self deleteButtonClick];
//            [HDBroadcastRoomHandlerMgr.hdLiveView.docView.gsHdDocView setupDocAnnoType:GSDocumentAnnoTypeFreePen];//删除以后可以继续绘制
//            */
//            [self deleteButtonClick];
//            [RoomModel.selfView.docView.gsDocView setupDocAnnoType:GSDocumentAnnoTypeFreePen];//删除以后可以继续绘制
//   
//            
//            break;
//        case OriginalTAG+2://向左，上一步
//        
//            [self beforeButtonClick];
//            break;
//        case OriginalTAG+3://向右，下一步
//           
//            [self nextButtonClick];
//            break;
//            
//        default:
//            break;
//    }
//}





-(void)setUpAnnotationMode:(BOOL)isOpen
{
    
    

    
}







#pragma mark --action--
-(void)rubberButtonClick:(BOOL)isSelected{
    if (isSelected) {
        [self hideTopView];
        _pen.selected=NO;
    }else{
    }
    
    
}
-(void)deleteButtonClick{
 
}

-(void)beforeButtonClick{
  
}


-(void)nextButtonClick{
  

}


- (void)setIsLand:(BOOL)isLand
{
    if (_isLand != isLand) {
        _isLand = isLand;
        
        [self resetSubViewsByLandscape:_isLand];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *responseV = [super hitTest:point withEvent:event];
    
    if (CGRectContainsPoint(_topPenView.frame, point)) {
        if (!isAnnoStatu) {
            return nil;//如果不是标注状态 透过该视图
        }
    }
    return responseV;
}

//下提问席，恢复原状
-(void)restoreOriginalStatus{
    [self packUp];
    _eraser.selected=NO;
}


#pragma mark ---设置隐藏  taggingMarkView.hidde
/**
 设置标注栏的显示和隐藏
 */
-(void)setTaggingMarkViewHidde:(BOOL)isHide{
    self.hidden=isHide;
}



/**
 专门控制标注栏的位置
 */
-(void)updateFrameByChange{
   
}


-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    
}


-(void)keepStatusWithoutNet{
        _pen.enabled=NO;
        _eraser.enabled=NO;
        _trash.enabled=NO;
        _thin.enabled=NO;
        _middle.enabled=NO;
      _thick.enabled=NO;
       _undo.enabled=NO;
       _redo.enabled=NO;
    
}
-(void)recoveryStatusWithNet{
    
    _undo.enabled=_isUndoEnabled;
    _redo.enabled=_isRedoEnabled;
    
    _pen.enabled=YES;
    _eraser.enabled=YES;
    _trash.enabled=YES;
    _thin.enabled=YES;
    _middle.enabled=YES;
    _thick.enabled=YES;
}


@end
