//
//  GSAudioUnitPlayer.h
//  RtSDK
//
//  Created by gensee on 2020/5/7.
//  Copyright © 2020 Geensee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GSLiveAudioConfiguration.h"
#import <AudioToolbox/AudioToolbox.h>


//GSAudioUnitPlayer用于RtSDK,主要区别是需要改变sampleRate以适应webRTC的音频数据回调，而playerSDK不用，PlayerSDK默认是16000不变

@class GSAudioUnitPlayer;
/** LFAudioCapture callback audioData */
@protocol GSAudioUnitPlayerDelegate <NSObject>
- (void)audioUnitOnSetChannel:(int)nchannel sampleRate:(int)nSampleRate duration:(double)nDuration;
- (void)audioUnitOnGetData:(AudioUnitRenderActionFlags *)flag numberFrames:(UInt32)inNumberFrames audioData:(AudioBufferList *)ioData;
@end


@interface GSAudioUnitPlayer : NSObject

#pragma mark - Attribute
///=============================================================================
/// @name Attribute
///=============================================================================

/** The delegate of the capture. captureData callback */
@property (nullable, nonatomic, weak) id<GSAudioUnitPlayerDelegate> delegate;

/** The muted control callbackAudioData,muted will memset 0.*/
@property (nonatomic, assign) BOOL muted;

/** The running control start capture or stop capture*/
@property (nonatomic, assign) BOOL running;

#pragma mark - Initializer
///=============================================================================
/// @name Initializer
///=============================================================================
- (nullable instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (nullable instancetype)new UNAVAILABLE_ATTRIBUTE;

/**
   The designated initializer. Multiple instances with the same configuration will make the
   capture unstable.
 */
- (nullable instancetype)initWithAudioConfiguration:(nullable GSLiveAudioConfiguration *)configuration NS_DESIGNATED_INITIALIZER;
@end

