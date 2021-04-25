//
//  GSChatViewCell.h
//  RtSDKDemo
//
//  Created by Sheng on 2017/11/13.
//  Copyright © 2017年 gensee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSVodChatModel.h"
#import <GSCommonKit/GSTextAttributeLabel.h>
//#import "YYLabel.h"

@interface GSVodChatViewCell : UITableViewCell


@property (nonatomic,retain) UILabel *nickName;

@property (nonatomic,retain) UILabel *timeLab;

@property (nonatomic,retain) UILabel *typeLabel;

@property (nonatomic,strong) GSTextAttributeLabel *content;

@property (nonatomic,strong) GSVodChatModel *model;


@end
