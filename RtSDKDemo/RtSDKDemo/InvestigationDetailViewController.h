//
//  InvestigationDetailViewController.h
//  iOSDemo
//
//  Created by Gaojin Hsu on 5/19/15.
//  Copyright (c) 2015 gensee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RtSDK/RtSDK.h>

@interface InvestigationDetailViewController : UIViewController

@property (nonatomic, strong) GSInvestigation *investigation;

@property (nonatomic, strong) GSBroadcastManager *broadcastManager;
@end
