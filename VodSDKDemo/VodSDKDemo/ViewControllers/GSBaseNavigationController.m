//
//  GSBaseNavigationController.m
//  VodSDKDemo
//
//  Created by Sheng on 2018/8/3.
//  Copyright © 2018年 Gensee. All rights reserved.
//

#import "GSBaseNavigationController.h"

@interface GSBaseNavigationController ()

@end

@implementation GSBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate {
    UIViewController *controller = self.visibleViewController;
    if (controller && [controller isKindOfClass:[UIAlertController class]]) {
        return YES;
    }
    return [controller shouldAutorotate];
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    UIViewController *controller = self.visibleViewController;
    if (controller && [controller isKindOfClass:[UIAlertController class]]) {
        return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeRight;
    }
    return [controller supportedInterfaceOrientations];
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    UIViewController *controller = self.visibleViewController;
    if (controller && [controller isKindOfClass:[UIAlertController class]]) {
        return UIInterfaceOrientationPortrait|UIInterfaceOrientationLandscapeRight;
    }
    return [controller preferredInterfaceOrientationForPresentation];
}

@end
