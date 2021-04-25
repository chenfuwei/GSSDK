//  ViesAnswerViewController.m
//  RtSDKDemo
//  Created by Sheng on 2017/11/13.
//  Copyright © 2017年 gensee. All rights reserved.
#import "ViesAnswerViewController.h"
#import "MBProgressHUD.h"
@interface ViesAnswerViewController () <GSBroadcastInvestigationDelegate,GSBroadcastRoomDelegate>
@property (nonatomic, strong) GSBroadcastManager *broadcastManager;
@property (nonatomic, strong) MBProgressHUD *progressHUD;
@property (weak, nonatomic) IBOutlet UIButton *viesBtn;
@property (weak, nonatomic) IBOutlet UIButton *publishBtn;
@end
@implementation ViesAnswerViewController
{
    UIButton *viesAnswerBtn;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _progressHUD = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:_progressHUD];
    _progressHUD.labelText =  NSLocalizedString(@"BroadcastConnecting",  @"直播连接提示");
    [_progressHUD show:YES];
    [self initBroadCastManager];
    [self setupButtons];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupButtons{
}


- (IBAction)viesClick:(id)sender {
    [self.broadcastManager viesAnswerSubmit];
}


- (IBAction)publishClick:(id)sender {
    [self.broadcastManager viesAnswerStart:5 delaySec:0];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.broadcastManager viesAnswerEnd];
    });
}


- (void)initBroadCastManager
{
    self.broadcastManager = [GSBroadcastManager sharedBroadcastManager];
    self.broadcastManager.investigationDelegate = self;
    self.broadcastManager.broadcastRoomDelegate = self;
    if (![_broadcastManager connectBroadcastWithConnectInfo:self.connectInfo]) {
        
        [self.progressHUD show:NO];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"WrongConnectInfo", @"参数不正确") delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"知道了") otherButtonTitles:nil, nil];
        [alertView show];
        
    }
    
}

- (void)broadcastManager:(GSBroadcastManager *)manager OnVieToAnswerFirstStart:(int)nDurationSec delaySec:(int)nDelaySec
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"抢答将于%d秒后开始，共持续%d秒",nDelaySec,nDurationSec] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    
    [alertVC addAction:sure];
    [self dismissViewControllerAnimated:NO completion:nil];
    [self presentViewController:alertVC animated:YES completion:nil];
    
    
    
    _publishBtn.hidden = YES;
    
    _viesBtn.userInteractionEnabled = YES;
}

- (void)broadcastManagerOnVieToAnswerFirstEnd:(GSBroadcastManager *)broadcastManager{
    
    viesAnswerBtn.selected = NO;
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"抢答已经结束了！亲！" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
    
    [alertVC addAction:sure];
    [self dismissViewControllerAnimated:NO completion:nil];
    [self presentViewController:alertVC animated:YES completion:nil];
    
    _publishBtn.hidden = NO;
    
    _viesBtn.userInteractionEnabled = NO;
}

- (void)broadcastManager:(GSBroadcastManager *)broadcastManager OnVieToAnswerFirstSubmit:(long long)userID userName:(NSString *)strUserName{
    
    
    
    NSString *name = [NSString stringWithFormat:@"%@,这个人领先一步,快鄙视他",strUserName];
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:name preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"竖起中指" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *no = [UIAlertAction actionWithTitle:@"饶他一命..." style:UIAlertActionStyleDefault handler:nil];
    
    [alertVC addAction:sure];
    [alertVC addAction:no];
    
    [self dismissViewControllerAnimated:NO completion:nil];
    [self presentViewController:alertVC animated:YES completion:nil];
    
    _viesBtn.userInteractionEnabled = NO;
    
}


// 直播初始化代理
- (void)broadcastManager:(GSBroadcastManager*)manager didReceiveBroadcastConnectResult:(GSBroadcastConnectResult)result
{
    switch (result) {
        case GSBroadcastConnectResultSuccess:
            // 直播初始化成功，加入直播
            if (![self.broadcastManager join]) {
                [self.progressHUD hide:YES];
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:  NSLocalizedString(@"BroadcastConnectionError",  @"直播连接失败提示") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",  @"确认") otherButtonTitles:nil, nil];
                [alertView show];
            }
            break;
        case GSBroadcastConnectResultInitFailed:
        case GSBroadcastConnectResultJoinCastPasswordError:
        case GSBroadcastConnectResultWebcastIDInvalid:
        case GSBroadcastConnectResultRoleOrDomainError:
        case  GSBroadcastConnectResultThirdTokenError:
        case GSBroadcastConnectResultLoginFailed:
        case GSBroadcastConnectResultNetworkError:
        case GSBroadcastConnectResultWebcastIDNotFound:
        {
            [self.progressHUD hide:YES];
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:  NSLocalizedString(@"BroadcastConnectionError",  @"直播连接失败提示") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",  @"确认") otherButtonTitles:nil, nil];
            [alertView show];
        }
            break;
        default:
            break;
    }
}

/*
 直播连接代理
 rebooted为YES，表示这次连接行为的产生是由于根服务器重启而导致的重连
 */
- (void)broadcastManager:(GSBroadcastManager*)manager didReceiveBroadcastJoinResult:(GSBroadcastJoinResult)joinResult selfUserID:(long long)userID rootSeverRebooted:(BOOL)rebooted;
{
    [self.progressHUD hide:YES];
    // 服务器重启导致重连
    if (rebooted) {
    }
}



// 断线重连
- (void)broadcastManagerWillStartRoomReconnect:(GSBroadcastManager*)manager
{
    [self.progressHUD show:YES];
    self.progressHUD.labelText = NSLocalizedString(@"Reconnect", @"正在重连");
}



- (void)dealloc
{
    [self.broadcastManager leaveAndShouldTerminateBroadcast:NO];
}

- (BOOL)shouldAutorotate {
    return NO;
}
@end
