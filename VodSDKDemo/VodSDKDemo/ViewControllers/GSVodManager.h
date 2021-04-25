//
//  GSVodManager.h
//  VodSDKDemo
//
//  Created by Sheng on 2018/8/3.
//  Copyright © 2018年 Gensee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VodSDK/VodSDK.h>
@interface GSVodManager : NSObject

@property (nonatomic, strong) VodPlayer *player;
@property (nonatomic, assign) BOOL isFlv;
- (void)play:(downItem *)item online:(BOOL)isOnline;

+ (instancetype)sharedInstance;

@end
