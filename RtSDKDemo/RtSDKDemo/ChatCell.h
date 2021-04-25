//
//  ChatCell.h
//  iOSDemo
//
//  Created by Gaojin Hsu on 5/6/15.
//  Copyright (c) 2015 gensee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatMessageInfo.h"

@interface ChatCell : UITableViewCell

- (void)setContent:(ChatMessageInfo*)messageInfo;

@property (strong, nonatomic) NSDictionary *key2fileDic;

@end
