//
//  GSVodQueueCell.m
//  VodSDKDemo
//
//  Created by Sheng on 2018/8/24.
//  Copyright © 2018年 Gensee. All rights reserved.
//

#import "GSVodQueueCell.h"
#import "GSProgressView.h"
#import "UIView+SetRect.h"
#define FASTSDK_COLOR16(value) [UIColor colorWithRed:((float)((value & 0xFF0000) >> 16))/255.0 green:((float)((value & 0xFF00) >> 8))/255.0 blue:((float)(value & 0xFF))/255.0 alpha:1.0]

@interface GSVodQueueCell ()

@property (nonatomic, strong) GSProgressView *progress;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UIButton *start;
@property (nonatomic, strong) UIButton *stop;
@property (nonatomic, strong) UIButton *offlinePlay;
@property (nonatomic, strong) UIButton *onlinePlay;
@end

@implementation GSVodQueueCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(5, 5, Width - 10, 90) cornerRadius:5];
        
        CAShapeLayer *shape = [[CAShapeLayer alloc] init];
        shape.fillColor = [UIColor groupTableViewBackgroundColor].CGColor;
        shape.path = path.CGPath;
        [self.layer addSublayer:shape];
        
        CGFloat top = 10;
        CGFloat left = 10;
        CGFloat H = 25;
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, top, Width-30, 20)];
        _nameLabel.text = @"点播名称";
        _nameLabel.textColor = FASTSDK_COLOR16(0x009BD8);
        _nameLabel.font = [UIFont systemFontOfSize:12.f];
        [_nameLabel sizeToFit];
        [self addSubview:_nameLabel];
        top = _nameLabel.bottom + 5;
        
        _progress = [[GSProgressView alloc] initWithFrame:CGRectMake(left, top, Width - 20, 30)];
//        _progress.percent = 0.0;
        [self addSubview:_progress];
        top = _progress.bottom + 5;
        
        _start   = [[UIButton alloc] initWithFrame:CGRectMake(left, top, (Width-50.f)/4,H)];
        [_start setTitle:@"下载" forState:UIControlStateNormal];
        _start.tag = 0;
        [self resetCustomButton:_start flag:0];
        [self addSubview:_start];
        left = _start.right + 10;
        
        _stop   = [[UIButton alloc] initWithFrame:CGRectMake(left, top, (Width-50.f)/4 , H)];
        [_stop setTitle:@"停止" forState:UIControlStateNormal];
        _stop.tag = 1;
        [self resetCustomButton:_stop flag:0];
        [self addSubview:_stop];
        left = _stop.right + 10;
      
        _offlinePlay   = [[UIButton alloc] initWithFrame:CGRectMake(left, top, (Width-50.f)/4, H)];
        [_offlinePlay setTitle:@"离线观看" forState:UIControlStateNormal];
        _offlinePlay.tag = 2;
        [self resetCustomButton:_offlinePlay flag:0];
        [self addSubview:_offlinePlay];
        left = _offlinePlay.right + 10;
    
        _onlinePlay   = [[UIButton alloc] initWithFrame:CGRectMake(left, top, (Width-50.f)/4, H)];
        [_onlinePlay setTitle:@"在线观看" forState:UIControlStateNormal];
        _onlinePlay.tag = 3;
        [self resetCustomButton:_onlinePlay flag:1];
        [self addSubview:_onlinePlay];
        left = _onlinePlay.right + 10;

    }
    return self;
}



- (void)resetCustomButton:(UIButton *)btn flag:(int)i {
    if (i == 0) {
        btn.layer.cornerRadius         = 3.f;
        btn.layer.borderColor          = [UIColor grayColor].CGColor;
        btn.layer.borderWidth          = 0.5f;
        btn.layer.masksToBounds        = YES;
        btn.backgroundColor = [UIColor grayColor];
        btn.userInteractionEnabled = NO;
    }else if (i == 1) {
        btn.layer.cornerRadius         = 3.f;
        btn.layer.borderColor          = FASTSDK_COLOR16(0x009BD8).CGColor;
        btn.layer.borderWidth          = 0.5f;
        btn.layer.masksToBounds        = YES;
        btn.backgroundColor = FASTSDK_COLOR16(0x009BD8);
        btn.userInteractionEnabled = YES;
    }else if (i == 2) {
        btn.layer.cornerRadius         = 3.f;
        btn.layer.borderColor          = FASTSDK_COLOR16(0x336699).CGColor;
        btn.layer.borderWidth          = 0.5f;
        btn.layer.masksToBounds        = YES;
        btn.backgroundColor = FASTSDK_COLOR16(0x336699);
        btn.userInteractionEnabled = YES;
    }
    btn.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [btn addTarget:self action:@selector(customAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setItem:(downItem *)item {
    NSLog(@"GSVodQueueCell setItem item:%@", item);
    _item = item;

    _nameLabel.text = item.name;
    [_nameLabel sizeToFit];
    [_start setTitle:@"下载" forState:UIControlStateNormal];
    [_stop setTitle:@"停止" forState:UIControlStateNormal];
    if (item.state < 3 || item.state == 4) {
        if (item.state == PAUSE) {
            [self resetCustomButton:_stop flag:1];
            [self resetCustomButton:_start flag:1];
        }else if (item.state == BEGIN) {
            downItem *record = [GSVodManager sharedInstance].downloadingItem;
            if (record.strDownloadID) {
                if ([record.strDownloadID isEqualToString:self.item.strDownloadID]) {
                    [self resetCustomButton:_stop flag:1];
                }else{
                    [_start setTitle:@"队列中" forState:UIControlStateNormal];
                    [self resetCustomButton:_stop flag:0];
                }
                [self resetCustomButton:_start flag:0];
            }else{
                [self resetCustomButton:_stop flag:0];
                [self resetCustomButton:_start flag:1];
            }
            
        }else if (item.state == REDAY) {
            [self resetCustomButton:_start flag:1];
            [self resetCustomButton:_stop flag:0];
        }
        _progress.percent = self.item.percent;
        [self resetCustomButton:_offlinePlay flag:0];
    }else{
        _progress.percent = 1.f;
        [self resetCustomButton:_offlinePlay flag:1];
        [_stop setTitle:@"删除缓存" forState:UIControlStateNormal];
        [self resetCustomButton:_stop flag:1];
        [self resetCustomButton:_start flag:0];
    }
}

- (void)customAction:(UIButton *)sender {
    if (sender.tag == 0) {
        [[GSVodManager sharedInstance] startDownload:_item.strDownloadID];
        
    }else if (sender.tag == 1) {
        if (self.item.state == FINISH) {
            BOOL issuccess = [[GSVodManager sharedInstance] removeOnDisk:self.item.strDownloadID];
            if (issuccess) {
                self.item.state = REDAY;
                self.item.percent = 0;
                [self resetCustomButton:_start flag:1];
                [self resetCustomButton:_stop flag:0];
                [self resetCustomButton:_offlinePlay flag:0];
                [_start setTitle:@"下载" forState:UIControlStateNormal];
                [_stop setTitle:@"停止" forState:UIControlStateNormal];
                _progress.percent = 0.f;
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(vodQueueCell:didDelete:)]) {
                    [self.delegate vodQueueCell:self didDelete:self.item.strDownloadID];
                }
            }
            
        }else if ([[GSVodManager sharedInstance].downloadingItem.strDownloadID isEqualToString:self.item.strDownloadID]) {
            self.item.state = FAILED;
            [[VodManage shareManage] updateItem:self.item];
            [self resetCustomButton:_start flag:1];
            [self resetCustomButton:_stop flag:0];
            [self resetCustomButton:_offlinePlay flag:0];
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(vodQueueCell:didClickButton:)]) {
        [self.delegate vodQueueCell:self didClickButton:(int)sender.tag];
    }
}

@end
