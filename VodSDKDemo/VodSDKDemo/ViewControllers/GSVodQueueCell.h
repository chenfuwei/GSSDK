//
//  GSVodQueueCell.h
//  VodSDKDemo
//
//  Created by Sheng on 2018/8/24.
//  Copyright © 2018年 Gensee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VodSDK/VodSDK.h>

@class GSVodQueueCell;
@protocol GSVodQueueCellDelegate
@optional
- (void)vodQueueCell:(GSVodQueueCell*)cell didClickButton:(int)index;
- (void)vodQueueCell:(GSVodQueueCell *)cell didDelete:(NSString*)strDownloadId;
@end

@interface GSVodQueueCell : UICollectionViewCell

@property (nonatomic, strong) downItem *item;

@property (nonatomic, weak) id delegate;

@end
