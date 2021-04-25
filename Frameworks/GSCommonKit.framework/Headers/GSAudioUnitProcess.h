//
//  GSAudioUnitProcess.h
//  AudioUnit
//
//  Created by net263 on 2021/1/12.
//

#import <Foundation/Foundation.h>
#import "GSAudioUnitProcessPlayProtocol.h"
#import "GSAudioUnitProcessRecordProtocol.h"

NS_ASSUME_NONNULL_BEGIN
@interface GSAudioUnitProcess : NSObject
+(id)shareAudioUnitProcess;
/**
 音频session设置AVAudioSessionCategoryOptions 默认为  AVAudioSessionCategoryOptionDefaultToSpeaker |AVAudioSessionCategoryOptionAllowBluetooth|AVAudioSessionCategoryOptionMixWithOthers
 */
@property (nonatomic, assign) AVAudioSessionCategoryOptions sessionCategoryOption;
@property(nonatomic, weak)id<GSAudioUnitProcessPlayProtocol> audioUnitPlayDelegate;
@property(nonatomic, weak)id<GSAudioUnitProcessRecordProtocol> audioUnitRecordDelegate;

/**
 打开扬声器
 */
-(void)startSpeaker;

/**
 关闭扬声器
 */
-(void)stopSpeaker;

/**
 打开MIC
 */
-(void)startRecord;

/**
 关闭MIC
 */
-(void)stopRecord;
@end

NS_ASSUME_NONNULL_END
