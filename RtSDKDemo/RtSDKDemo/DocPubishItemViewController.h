//
//  DocPubishItemViewController.h
//  iOSDemo
//
//  Created by Gaojin Hsu on 6/27/16.
//  Copyright © 2016 gensee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RtSDK/RtSDK.h>
#import "BaseItemViewController.h"


#import "GestureDocPanelView.h"


@interface DocPubishItemViewController : BaseItemViewController


@property (nonatomic, strong) GestureDocPanelView *gestureDocPanelView;


@end
