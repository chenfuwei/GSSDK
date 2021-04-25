//
//  GSVodManager.m
//  VodSDKDemo
//
//  Created by Sheng on 2018/8/3.
//  Copyright © 2018年 Gensee. All rights reserved.
//

#import "GSVodManager.h"

@interface GSVodManager ()
@property (nonatomic, strong) downItem *item;
@end

@implementation GSVodManager

static GSVodManager *manager = nil;
static dispatch_once_t onceToken;

+ (instancetype)sharedInstance {
    dispatch_once(&onceToken, ^{
        manager = [[super allocWithZone:NULL] init];
    });
    return manager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}

//防止通过copy来创建新的实例
- (instancetype)copyWithZone:(NSZone*)zone {
    return self;
}

- (instancetype)mutableCopyWithZone:(NSZone*)zone {
    return self;
}

- (VodPlayer *)player {
    if (!_player) {
        _player = [[VodPlayer alloc] init];
    }
    return _player;
}

- (void)play:(downItem *)item online:(BOOL)isOnline{
    if (_item) {
        [self.player stop];
    }
    _item = item;
    self.player.playItem = item;
    
    [self.player OnlinePlay:isOnline audioOnly:NO];
    
    [self.player getChatListWithPageIndex:1];
}

@end
