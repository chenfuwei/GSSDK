//
//  GSFaceView.m
//  RtSDKDemo
//
//  Created by Sheng on 2017/11/20.
//  Copyright © 2017年 gensee. All rights reserved.
//

#import "GSFaceView.h"

#import "GSEmotionManager.h"


#define kButtomNum 5

@interface GSFaceView () 
{
    UIScrollView *_bottomScrollView;
    NSInteger _currentSelectIndex;
    NSArray *_emotionManagers;
}

@property (nonatomic, strong) GSBaseFaceView *facialView;

@end

@implementation GSFaceView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.facialView];
        [self _setupButtom];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview) {
        [self reloadEmotionData];
    }
}

#pragma mark - private

- (GSBaseFaceView*)facialView
{
    if (_facialView == nil) {
        _facialView = [[GSBaseFaceView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 150)];
        _facialView.delegate = self;
    }
    return _facialView;
}

- (void)_setupButtom
{
    _currentSelectIndex = 1000;
    
    _bottomScrollView = [[UIScrollView alloc] initWithFrame: CGRectMake(0, CGRectGetMaxY(_facialView.frame), 4 * CGRectGetWidth(_facialView.frame)/5, self.frame.size.height - CGRectGetHeight(_facialView.frame))];
    _bottomScrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_bottomScrollView];
    [self _setupButtonScrollView];
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.frame = CGRectMake((kButtomNum-1)*CGRectGetWidth(_facialView.frame)/kButtomNum, CGRectGetMaxY(_facialView.frame), CGRectGetWidth(_facialView.frame)/kButtomNum, CGRectGetHeight(_bottomScrollView.frame));
    [sendButton setBackgroundColor:[UIColor colorWithRed:30 / 255.0 green:167 / 255.0 blue:252 / 255.0 alpha:1.0]];
    [sendButton setTitle:@"Send" forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendFace) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:sendButton];
}

- (void)_setupButtonScrollView
{

    NSInteger number = [_emotionManagers count];
    if (number <= 0) {
        return;
    }
    
    for (UIView *view in [_bottomScrollView subviews]) {
        [view removeFromSuperview];
    }
    
    for (int i = 0; i < number; i++) {
        UIButton *defaultButton = [UIButton buttonWithType:UIButtonTypeCustom];
        defaultButton.frame = CGRectMake(i * CGRectGetWidth(_bottomScrollView.frame)/(kButtomNum-1), 0, CGRectGetWidth(_bottomScrollView.frame)/(kButtomNum-1), CGRectGetHeight(_bottomScrollView.frame));
        GSEmotionManager *emotionManager = [_emotionManagers objectAtIndex:i];
//        if (emotionManager.emotionType == GSEmotionDefault || !emotionManager.tagImage) {
//            GSEmotion *emotion = [emotionManager.emotions objectAtIndex:0];
//            [defaultButton setTitle:emotion.emotionOriginal forState:UIControlStateNormal];
//        } else {
//            [defaultButton setImage:emotionManager.tagImage forState:UIControlStateNormal];
//            [defaultButton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
//            defaultButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
//        }
        [defaultButton setImage:emotionManager.tagImage forState:UIControlStateNormal];
        [defaultButton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
        defaultButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [defaultButton setBackgroundColor:[UIColor clearColor]];
        defaultButton.layer.borderWidth = 0.5;
        defaultButton.layer.borderColor = [UIColor whiteColor].CGColor;
        [defaultButton addTarget:self action:@selector(didSelect:) forControlEvents:UIControlEventTouchUpInside];
        defaultButton.tag = 1000 + i;
        [_bottomScrollView addSubview:defaultButton];
    }
    [_bottomScrollView setContentSize:CGSizeMake(number*CGRectGetWidth(_bottomScrollView.frame)/(kButtomNum-1), CGRectGetHeight(_bottomScrollView.frame))];
    
    [self reloadEmotionData];
}

- (void)_clearupButtomScrollView
{
    for (UIView *view in [_bottomScrollView subviews]) {
        [view removeFromSuperview];
    }
}

#pragma mark - action

- (void)didSelect:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    UIButton *lastBtn = (UIButton*)[_bottomScrollView viewWithTag:_currentSelectIndex];
    lastBtn.selected = NO;
    
    _currentSelectIndex = btn.tag;
    btn.selected = YES;
    NSInteger index = btn.tag - 1000;
    
    GSEmotionManager *manager = _emotionManagers[index];
    
    [_facialView loadFacialViewWithPage:manager.emotionPageIndex];
}

- (void)reloadEmotionData
{
    NSInteger index = _currentSelectIndex - 1000;
    if (index < [_emotionManagers count]) {
        [_facialView loadFacialView:_emotionManagers size:CGSizeMake(30, 30)];
    }
}

#pragma mark - FacialViewDelegate

-(void)selectedFacialView:(NSString*)str{
    if (_delegate) {
        [_delegate selectedFacialView:str isDelete:NO];
    }
}

-(void)deleteSelected:(NSString *)str{
    if (_delegate) {
        [_delegate selectedFacialView:str isDelete:YES];
    }
}

- (void)sendFace
{
    if (_delegate) {
        [_delegate sendFace];
    }
}

- (void)sendFace:(GSBaseEmotion *)emotion
{
    if (_delegate) {
        [_delegate sendFaceWithEmotion:emotion];
    }
}

#pragma mark - public

- (BOOL)stringIsFace:(NSString *)string
{
    if ([_facialView.faces containsObject:string]) {
        return YES;
    }
    
    return NO;
}

- (void)setEmotionManagers:(NSArray *)emotionManagers
{
    _emotionManagers = emotionManagers;
//    for (GSEmotionManager *emotionManager in _emotionManagers) {
//        if (emotionManager.emotionType != GSEmotionGif) {
//            NSMutableArray *array = [NSMutableArray arrayWithArray:emotionManager.emotions];
//            NSInteger maxRow = emotionManager.emotionRow;
//            NSInteger maxCol = emotionManager.emotionCol;
//            NSInteger count = 1;
//            while (1) {
//                NSInteger index = maxRow * maxCol * count - 1;
//
//                if (index >= [array count]) {
//
//                    NSInteger c = index + 1 - [array count];
//
//                    for (NSInteger i = 1; i <= c; i ++) {
//                        if (i == c) {
//                            [array addObject:@"D"];
//                        }else{
//                            [array addObject:@""];
//                        }
//
//                    }
//
//                    break;
//                } else {
//                    [array insertObject:@"D" atIndex:index];
//                }
//                count++;
//            }
//            emotionManager.emotions = array;
//        }
//    }
    [self _setupButtonScrollView];
}

@end
