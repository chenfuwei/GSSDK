//
//  GSVodPlayerBar.m
//  VodSDKDemo
//
//  Created by Sheng on 2018/8/3.
//  Copyright © 2018年 Gensee. All rights reserved.
//

#import "GSVodPlayerBar.h"
#import "UIView+SetRect.h"
#define FASTSDK_COLOR16(value) [UIColor colorWithRed:((float)((value & 0xFF0000) >> 16))/255.0 green:((float)((value & 0xFF00) >> 8))/255.0 blue:((float)(value & 0xFF))/255.0 alpha:1.0]




@implementation GSVodPlayerBar
{
    UIButton *_playStop;
    UISlider *_slider;
    UILabel *_currentLabel;
    UILabel *_totalLabel;
    UILabel *_speedLabel;
    int style;//时间格式
}

- (NSString*)_timeFormat:(int)time {
    int t = time;
    int hours = t/1000/60/60;
    int minutes = (t/1000/60)%60;
    int seconds = (t/1000)%60;
    if (style) {
        return [NSString stringWithFormat:@"%02d:%02d:%02d",hours,minutes,seconds];
    }else{
        return [NSString stringWithFormat:@"%02d:%02d",minutes,seconds];
    }
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        style = 0;
        _playStop = [[UIButton alloc] init];
        _isPlay = NO;
        [_playStop setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        _playStop.layer.cornerRadius         = 3.f;
        //        _playStop.layer.borderColor          = FASTSDK_COLOR16(0x009BD8).CGColor;
        //        _playStop.layer.borderWidth          = 0.5f;
        _playStop.layer.masksToBounds        = YES;
        _playStop.backgroundColor = FASTSDK_COLOR16(0x009BD8);
        [_playStop addTarget:self action:@selector(playOrStop:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_playStop];
        
        _slider = [[UISlider alloc]init];
        _slider.value = 0;
        [_slider addTarget:self action:@selector(slideDragAction:) forControlEvents:UIControlEventTouchDragInside];
        [_slider addTarget:self action:@selector(slideFinishAction:) forControlEvents:UIControlEventTouchUpInside];
        [_slider addTarget:self action:@selector(slideBeginAction:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:_slider];
        
        _currentLabel = [[UILabel alloc] init];
        _currentLabel.font = [UIFont systemFontOfSize:14];
        _currentLabel.textColor = [UIColor whiteColor];
        _currentLabel.layer.cornerRadius         = 3.f;
        _currentLabel.backgroundColor          = FASTSDK_COLOR16(0x009BD8);
        _currentLabel.layer.masksToBounds        = YES;
        _currentLabel.textAlignment = NSTextAlignmentCenter;
        _currentLabel.text = [NSString stringWithFormat:@"%@",[self _timeFormat:_currentTime]];
        [self addSubview:_currentLabel];
        
        _totalLabel = [[UILabel alloc] init];
        _totalLabel.font = [UIFont systemFontOfSize:14];
        _totalLabel.textColor = [UIColor whiteColor];
        _totalLabel.layer.cornerRadius         = 3.f;
        _totalLabel.backgroundColor          = FASTSDK_COLOR16(0x009BD8);
        _totalLabel.layer.masksToBounds        = YES;
        _totalLabel.textAlignment = NSTextAlignmentCenter;
        _totalLabel.text = [NSString stringWithFormat:@"%@",[self _timeFormat:_totalTime]];
        [self addSubview:_totalLabel];
        
        _speedLabel = [[UILabel alloc] init];
        _speedLabel.font = [UIFont systemFontOfSize:14];
        _speedLabel.textColor = [UIColor whiteColor];
        _speedLabel.layer.cornerRadius         = 3.f;
        _speedLabel.backgroundColor          = FASTSDK_COLOR16(0x009BD8);
        _speedLabel.layer.masksToBounds        = YES;
        _speedLabel.textAlignment = NSTextAlignmentCenter;
        _speedLabel.text = @"1X";
        [_speedLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagDidCLick:)]];
        [self addSubview:_speedLabel];
        _speedLabel.userInteractionEnabled = YES;
        
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return self;
}

- (void)tagDidCLick:(UIGestureRecognizer*)gesture {
    if (self.delegate && [self.delegate respondsToSelector:@selector(vodPlayerBar:didClickSpeed:)]) {
        [self.delegate vodPlayerBar:self didClickSpeed:_speedLabel];
    }
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    [self _setupSubviews];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    [self _layoutOtherView];
}

- (void)setSpeedValue:(NSString *)speedValue {
    _speedValue = speedValue;
    [self _layoutOtherView];
}

- (void)_layoutOtherView {
    _playStop.frame = CGRectMake(4, 4, 30, 30);
    _currentLabel.frame = CGRectZero;
    _currentLabel.text = [NSString stringWithFormat:@"%@",[self _timeFormat:_currentTime]];
    [_currentLabel sizeToFit];
    _currentLabel.width += 8;
    _currentLabel.left = _playStop.right + 4;
    
    _totalLabel.frame = CGRectZero;
    [_totalLabel sizeToFit];
    _totalLabel.width += 8;
    _totalLabel.right = self.right - 8 - 40;
    
    CGFloat x = CGRectGetMaxX(_currentLabel.frame)+4;
    
    _slider.frame = CGRectMake(x, 4, self.width - x - _totalLabel.width - 8 - 40, 30);
    [_speedLabel sizeToFit];
    _speedLabel.width += 8;
    _speedLabel.height += 8;
    _speedLabel.left = self.width- 40 + 4;
    _speedLabel.top = (self.height - _speedLabel.height)/2;;
    
    _currentLabel.top = (self.height - _currentLabel.height)/2;
    _totalLabel.top = (self.height - _totalLabel.height)/2;
    [self bringSubviewToFront:_speedLabel];
}

- (void)_setupSubviews {
    self.height = 38;
    [self _layoutOtherView];
}

- (void)setCurrentTime:(int)currentTime {
    
    _currentTime = currentTime;
    _slider.value = _currentTime;
    
    
    NSString *old = _currentLabel.text;
    _currentLabel.text = [NSString stringWithFormat:@"%@",[self _timeFormat:_currentTime]];
    if (_currentLabel.text.length > old.length) {
        [self _setupSubviews];
    }
}

- (void)setTotalTime:(int)totalTime {
    if (_totalTime != totalTime) {
        _slider.value = 0;
    }
    _totalTime = totalTime;
    _slider.maximumValue = _totalTime;
    //格式设置
    int hours = _totalTime/1000/60/60;
    style = hours > 0?1:0;
    //
    int len = (int)_totalLabel.text.length;
    _totalLabel.text = [NSString stringWithFormat:@"%@",[self _timeFormat:_totalTime]];
    
    if (_totalLabel.text.length != len) {
        [self _setupSubviews];
    }
    
}
- (void)setIsPlay:(BOOL)isPlay {
    _isPlay = isPlay;
    if (_isPlay) {
        [_playStop setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    }else{
        [_playStop setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    }
}
- (void)playOrStop:(UIButton *)sender{
    self.isPlay = !self.isPlay;
    if (self.delegate && [self.delegate respondsToSelector:@selector(vodPlayerBar:didSetPlay:)]) {
        [self.delegate vodPlayerBar:self didSetPlay:self.isPlay];
    }
}
- (void)slideFinishAction:(UISlider *)sender{
    if (_totalTime <= 0) {
        return;
    }
    _currentTime = sliderValue;
    _currentLabel.text = [NSString stringWithFormat:@"%@",[self _timeFormat:_currentTime]];
    if (self.delegate && [self.delegate respondsToSelector:@selector(vodPlayerBar:didSlideToValue:)]) {
        [self.delegate vodPlayerBar:self didSlideToValue:sliderValue];
    }
}

static int sliderValue = 0;

- (void)slideDragAction:(UISlider *)sender{
    if (_totalTime <= 0) {
        return;
    }
    sliderValue = (int)sender.value;
    _currentTime = sliderValue;
    _currentLabel.text = [NSString stringWithFormat:@"%@",[self _timeFormat:_currentTime]];
    
}


- (void)slideBeginAction:(UISlider *)sender{
    if (_totalTime <= 0) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(vodPlayerBar:beginSlide:)]) {
        [self.delegate vodPlayerBar:self beginSlide:(int)sender.value];
    }
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

@end
