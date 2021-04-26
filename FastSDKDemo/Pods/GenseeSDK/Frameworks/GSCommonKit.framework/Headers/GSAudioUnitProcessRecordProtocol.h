//
//  GSAudioUnitProcessRecordProtocol.h
//  GSCommonKit
//
//  Created by net263 on 2021/2/25.
//  Copyright © 2021 gensee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GSAudioUnitProcessRecordProtocol <NSObject>
- (void)captureOutput:(nullable NSData*)audioData;  //record
-(int)audioUnitRecordSampleRate;
@end

NS_ASSUME_NONNULL_END
