//
//  GSFastVodSDKDelegate.h
//  FASTSDK
//
//  Created by net263 on 2020/8/14.
//  Copyright © 2020 Gensee. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@protocol GSFastVodSDKDelegate <VodPlayDelegate>
- (BOOL)onVodPlayNoVideoView:(UIImageView *)iamgeView;
@end

NS_ASSUME_NONNULL_END
