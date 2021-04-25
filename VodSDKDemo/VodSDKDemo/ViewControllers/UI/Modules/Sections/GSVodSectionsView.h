//
//  GSVodSectionsView.h
//  VodSDKDemo
//
//  Created by gensee on 2020/4/17.
//  Copyright © 2020年 Gensee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GSVodSectionsView : UIView
@property (nonatomic, strong) NSMutableArray *dataModelArray;

- (void)reloadView;

@end

NS_ASSUME_NONNULL_END
