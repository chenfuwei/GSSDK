//
//  GSAudioUnitProcessPlayProtocol.h
//  GSCommonKit
//
//  Created by net263 on 2021/2/25.
//  Copyright © 2021 gensee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GSAudioUnitProcessPlayProtocol <NSObject>
- (void)audioUnitOnGetData:(AudioUnitRenderActionFlags *)flag numberFrames:(UInt32)inNumberFrames audioData:(AudioBufferList *)ioData; //play
- (int)audioUnitPlaySampleRate;
@optional
-(void)resetPlayData;
@end

NS_ASSUME_NONNULL_END
