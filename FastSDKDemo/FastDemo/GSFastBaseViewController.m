//
//  GSFastBaseViewController.m
//  FastDemo
//
//  Created by Sheng on 2018/7/31.
//  Copyright © 2018年 263. All rights reserved.
//

#import "GSFastBaseViewController.h"
#import "MBProgressHUD.h"
#import <FASTSDK/FASTSDK.h>
#define FASTSDK_COLOR16(value) [UIColor colorWithRed:((float)((value & 0xFF0000) >> 16))/255.0 green:((float)((value & 0xFF00) >> 8))/255.0 blue:((float)(value & 0xFF))/255.0 alpha:1.0]

@interface GSFastBaseViewController ()
{
    UIButton *testButton;
}
@end

@implementation GSFastBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!testButton) {
        testButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 80,60, 30)];
        [testButton setTitle:@"直播时间" forState:UIControlStateNormal];
        testButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [testButton setBackgroundColor: [UIColor blueColor]];
        [testButton addTarget:self action:@selector(showTime) forControlEvents:UIControlEventTouchUpInside];
        [[UIApplication sharedApplication].keyWindow addSubview:testButton];
    }
    
}

- (void)showTime {
    
    
    UIView *view = [[UIApplication sharedApplication].windows lastObject];
    if (view == nil) view = [[UIApplication sharedApplication] keyWindow];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    int t = [GSFastSDK sharedInstance].playTime;
    int hours = t/1000/60/60;
    int minutes = (t/1000/60)%60;
    int seconds = (t/1000)%60;
    NSString *str = [NSString stringWithFormat:@"%02d:%02d:%02d",hours,minutes,seconds];
    hud.labelText = str;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.dimBackground = YES;
    [hud hideAnimated:YES afterDelay:2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - extern

- (UILabel *)createTagLabel:(NSString *)tagContent top:(CGFloat)top {
    return [self createTagLabel:tagContent top:top left:15];
}

- (UILabel *)createTagLabel:(NSString *)tagContent top:(CGFloat)top left:(CGFloat)left{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(left, top, 100, 20)];
    label.text = tagContent;
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:12.f];
    [label sizeToFit];
    return label;
}

- (UIView *)createWhiteBGViewWithTop:(CGFloat)top itemCount:(NSInteger)count {
    
    UIView *view         = [[UIView alloc] initWithFrame:CGRectMake(0, top, Width, count * 40.f)];
    view.backgroundColor = [UIColor whiteColor];
    
    // Top line.
    {
        UIView *line         = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, 0.5f)];
        line.backgroundColor = FASTSDK_COLOR16(0xE8E8E8);
        [view addSubview:line];
    }
    
    // Bottom line.
    {
        UIView *line         = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, 0.5f)];
        line.backgroundColor = FASTSDK_COLOR16(0xE8E8E8);
        line.bottom          = view.height;
        [view addSubview:line];
    }
    
    // Middle lines.
    for (int i = 1; i < count; i++) {
        
        UIView *line         = [[UIView alloc] initWithFrame:CGRectMake(15, i * 40.f - 0.5f, Width - 15.f, 0.5f)];
        line.backgroundColor = FASTSDK_COLOR16(0xE8E8E8);
        [view addSubview:line];
    }
    
    return view;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end


