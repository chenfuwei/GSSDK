//
//  VideoPublishViewController.m
//  iOSDemo
//
//  Created by colin on 15/10/30.
//  Copyright © 2015年 gensee. All rights reserved.
//

#import "VideoPublishViewController.h"
#import <RtSDK/RtSDK.h>
#import <GSCommonKit/GSCommonKit.h>
#import "MBProgressHUD.h"
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"

@interface VideoPublishViewController ()<GSBroadcastRoomDelegate, GSBroadcastVideoDelegate>
{
    BOOL videoFullScreen; //视频全屏
}
@property (weak, nonatomic) IBOutlet UIView *cameraArea;
@property (weak, nonatomic) IBOutlet UIButton *cameraBtn;
@property (weak, nonatomic) IBOutlet UIButton *micBtn;
@property (weak, nonatomic) IBOutlet UIButton *activeBtn;
@property (weak, nonatomic) IBOutlet UIButton *beautyBtn;

@property (assign, nonatomic)CGRect originalVideoFrame;
@property (assign, nonatomic)long long myUserID;
@property (assign, nonatomic)BOOL isCameraVideoDisplaying;
@property (assign, nonatomic)BOOL isLodVideoDisplaying;
@property (assign, nonatomic)BOOL isDesktopShareDisplaying;

@property (strong, nonatomic)MBProgressHUD *progressHUD;
@property (strong, nonatomic)GSBroadcastManager *broadcastManager;
@property (strong, nonatomic)GSVideoView *videoView;
@property (strong, nonatomic)GSVideoView *videoView1;

@end

@implementation VideoPublishViewController
{
    AVCaptureVideoPreviewLayer *_previewLayer;
    struct {
       unsigned int flagCamera : 1;
       unsigned int flagMic : 1;
       unsigned int flagActiveVideo : 1;
       unsigned int flagBeautyFace : 1;
    } _state;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    //由于默认美颜打开 将状态置为1
    _state.flagBeautyFace = 1;
    [self initBroadCastManager];
    [self setup];
    
    self.progressHUD = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:self.progressHUD];
    self.progressHUD.labelText =  NSLocalizedString(@"BroadcastConnecting",  @"直播连接提示");
    [self.progressHUD show:YES];
    
    
    [self enterBackground];
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithTitle:@"离开直播" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = left;
    
    
}

- (void)back:(id)sender
{
    [self.progressHUD show:YES];
    self.progressHUD.labelText = @"Leaving...";
    [self.broadcastManager leaveAndShouldTerminateBroadcast:NO];
}


//设置后台运行
- (void)enterBackground
{
    
}
- (IBAction)cameraAction:(id)sender {
    if (!_state.flagCamera) {
        NSLog(@"open camera");
        //根据需求设置裁剪比例
//        _broadcastManager.publishVideoCropMode = GSCropMode9x16;
        // 打开摄像头
        [_broadcastManager activateCamera:NO landscape:NO];
        // 设置预览视频View
        _broadcastManager.videoView = self.videoView;
        [_cameraBtn setTitle:@"摄像头(打开)" forState:UIControlStateNormal];
        
        // 水印
        //    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 200, 200, 100)];
        //    imgView.image = [UIImage imageNamed:@"logo"];
        //
        //    [self.broadcastManager setWatermarkImage:imgView];
        
    }else{
        NSLog(@"close camera");
        [_broadcastManager inactivateCamera];
        [_cameraBtn setTitle:@"摄像头(关闭)" forState:UIControlStateNormal];

    }
    _state.flagCamera = !_state.flagCamera;
}
- (IBAction)micAction:(id)sender {
    if (!_state.flagMic) { //打开麦克风
        NSLog(@"open micphone");
        [[GSBroadcastManager sharedBroadcastManager] activateMicrophone];
        [_micBtn setTitle:@"麦克风(打开)" forState:UIControlStateNormal];
    }else{ //关闭麦克风
        NSLog(@"close micphone");
        [[GSBroadcastManager sharedBroadcastManager] inactivateMicrophone];
        [_micBtn setTitle:@"麦克风(关闭)" forState:UIControlStateNormal];
    }
    _state.flagMic = !_state.flagMic;
}
- (IBAction)activeAction:(id)sender {
    if (!_state.flagActiveVideo) {
        //training站点需要设置此值来设置主讲人的userId
        [self.broadcastManager setBroadcastInfo:@"user.rostrum" value:_myUserID];
        //将一路用户视频置为直播视频 - 这里将自己置为直播视频
        [self.broadcastManager setVideo:_myUserID active:YES];
        [_activeBtn setTitle:@"直播视频(是)" forState:UIControlStateNormal];
    }else{
        [self.broadcastManager setVideo:_myUserID active:NO];
        [_activeBtn setTitle:@"直播视频(否)" forState:UIControlStateNormal];
    }
    _state.flagActiveVideo = !_state.flagActiveVideo;
}

- (IBAction)beautifyFace:(id)sender {
    if (!_state.flagBeautyFace) {
        _broadcastManager.beautifyFace = YES;
        [_beautyBtn setTitle:@"美颜开启(YES)" forState:UIControlStateNormal];
    }else{
        _broadcastManager.beautifyFace = NO;
        [_beautyBtn setTitle:@"美颜开启(NO)" forState:UIControlStateNormal];
    }
    _state.flagBeautyFace = !_state.flagBeautyFace;
}

- (void)setup
{
    CGFloat y = self.navigationController.navigationBar.frame.size.height+[[UIApplication sharedApplication] statusBarFrame].size.height;
    
    double version = [[UIDevice currentDevice].systemVersion doubleValue];//判定系统版本。
    if (version < 7.0) {
        y -= 64;
    }
    
    self.videoView = [[GSVideoView alloc]initWithFrame:_cameraArea.bounds];
    self.videoView.userInteractionEnabled = NO;
    [self.cameraArea addSubview:self.videoView];
    // 设置预览视频View
    _broadcastManager.videoView = self.videoView;
    
    
    self.videoView1 = [[GSVideoView alloc]initWithFrame:CGRectMake(200, 400, 200, 200)];
    self.videoView1.userInteractionEnabled = NO;
    self.videoView1.backgroundColor=[UIColor redColor];
    [self.view addSubview:self.videoView1];
    
    
}

- (void)initBroadCastManager
{
    self.broadcastManager = [GSBroadcastManager sharedBroadcastManager];
    self.broadcastManager.broadcastRoomDelegate = self;
    self.broadcastManager.videoDelegate = self;
    
    if (![_broadcastManager connectBroadcastWithConnectInfo:self.connectInfo]) {
        
        [self.progressHUD show:NO];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"WrongConnectInfo", @"参数不正确") delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"知道了") otherButtonTitles:nil, nil];
        [alertView show];
    }
}

#pragma mark - AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==1004)
    {
        
        if (buttonIndex==1) {
            
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^(){
                
                GSDiagnosisInfo *DiagnosisInfo =[[GSDiagnosisInfo alloc] init];
                [DiagnosisInfo ReportDiagonse];
            });
            
        }else if (buttonIndex==0)
        {
            
        }
    }
    else if (alertView.tag == JoinFailed)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

#pragma mark -
#pragma mark GSBroadcastRoomDelegate


// 直播初始化代理
- (void)broadcastManager:(GSBroadcastManager*)manager didReceiveBroadcastConnectResult:(GSBroadcastConnectResult)result
{
    NSString *errorMsg = nil;
    switch (result) {
        case GSBroadcastConnectResultSuccess:
            // 直播初始化成功，加入直播
            if (![_broadcastManager join]) {
                errorMsg = @"加入失败";
            }
            break;
            
        case GSBroadcastConnectResultInitFailed:
        {
            errorMsg = @"初始化出错";
            break;
        }
            
        case GSBroadcastConnectResultJoinCastPasswordError:
        {
            errorMsg = @"口令错误";
            break;
        }
            
        case GSBroadcastConnectResultWebcastIDInvalid:
        {
            errorMsg = @"webcastID错误";
            break;
        }
            
        case GSBroadcastConnectResultRoleOrDomainError:
        {
            errorMsg = @"口令错误";
            break;
        }
            
        case GSBroadcastConnectResultLoginFailed:
        {
            errorMsg = @"登录信息错误";
            break;
        }
            
            
        case GSBroadcastConnectResultNetworkError:
        {
            errorMsg = @"网络错误";
            break;
        }
            
        case GSBroadcastConnectResultWebcastIDNotFound:
        {
            
            errorMsg = @"找不到对应的webcastID，roomNumber, domain填写有误";
            break;
        }
            
        case  GSBroadcastConnectResultThirdTokenError:
        {
            errorMsg = @"第三方验证错误";
            break;
        }
        default:
        {
            errorMsg = @"未知错误";
            break;
        }
            
    }
    
    
    if (errorMsg) {
        
        [_progressHUD hide:YES];
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:errorMsg delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        alertView.tag = JoinFailed;
        [alertView show];
        
    }
}

/*
 直播连接代理
 rebooted为YES，表示这次连接行为的产生是由于根服务器重启而导致的重连
 */
- (void)broadcastManager:(GSBroadcastManager*)manager didReceiveBroadcastJoinResult:(GSBroadcastJoinResult)joinResult selfUserID:(long long)userID rootSeverRebooted:(BOOL)rebooted;
{
    [_progressHUD hide:YES];
    
    NSString * errorMsg = nil;
    
    switch (joinResult) {
            
            /**
             *  直播加入成功
             */
        case GSBroadcastJoinResultSuccess:
        {
            // 服务器重启导致重连的相应处理
            // 服务器重启的重连，直播中的各种状态将不再保留，如果想要实现重连后恢复之前的状态需要在本地记住，然后再重连成功后主动恢复。
            if (rebooted) {
                
                
            }
            //设置直播状态为 直播中(即已开始)
            [[GSBroadcastManager sharedBroadcastManager] setStatus:GSBroadcastStatusRunning];
            _myUserID = userID;
            
            AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            appDelegate.manager =  _broadcastManager;
            
            
            break;
        }
            
            /**
             *  未知错误
             */
        case GSBroadcastJoinResultUnknownError:
            errorMsg = @"未知错误";
            break;
            /**
             *  直播已上锁
             */
        case GSBroadcastJoinResultLocked:
            errorMsg = @"直播已上锁";
            break;
            /**
             *  直播组织者已经存在
             */
        case GSBroadcastJoinResultHostExist:
            errorMsg = @"直播组织者已经存在";
            break;
            /**
             *  直播成员人数已满
             */
        case GSBroadcastJoinResultMembersFull:
            errorMsg = @"直播成员人数已满";
            break;
            /**
             *  音频编码不匹配
             */
        case GSBroadcastJoinResultAudioCodecUnmatch:
            errorMsg = @"音频编码不匹配";
            break;
            /**
             *  加入直播超时
             */
        case GSBroadcastJoinResultTimeout:
            errorMsg = @"加入直播超时";
            break;
            /**
             *  ip被ban
             */
        case GSBroadcastJoinResultIPBanned:
            errorMsg = @"ip地址被ban";
            
            break;
            /**
             *  组织者还没有入会，加入时机太早
             */
        case GSBroadcastJoinResultTooEarly:
            errorMsg = @"直播尚未开始";
            break;
            
        default:
            errorMsg = @"未知错误";
            break;
    }
    
    if (errorMsg) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:errorMsg delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        alertView.tag = JoinFailed;
        [alertView show];
        
    }
    
}


// 断线重连
- (void)broadcastManagerWillStartRoomReconnect:(GSBroadcastManager*)manager
{
    [_progressHUD show:YES];
    _progressHUD.labelText = @"正在重连...";
    
}


// 直播状态改变代理
- (void)broadcastManager:(GSBroadcastManager *)manager didSetStatus:(GSBroadcastStatus)status
{
    
}

// 自己离开直播代理
- (void)broadcastManager:(GSBroadcastManager*)manager didSelfLeaveBroadcastFor:(GSBroadcastLeaveReason)leaveReason
{
    [_progressHUD hide:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL) broadcastManager:(GSBroadcastManager *)manager querySettingsInfoKey:(NSString *)key numberValue:(int *)value
{
    if ([key isEqualToString:@"save.video.height"]) {
        *value = 640;
    }else if ([key isEqualToString:@"save.video.width"])
    {
        *value = 480;
    }
    return YES;
}

#pragma mark -
#pragma mark GSBroadcastVideoDelegate

// 视频模块连接代理
- (void)broadcastManager:(GSBroadcastManager*)manager didReceiveVideoModuleInitResult:(BOOL)result
{
    
}

// 摄像头是否可用代理
- (void)broadcastManager:(GSBroadcastManager*)manager isCameraAvailable:(BOOL)isAvailable
{
    
}

// 摄像头打开代理
- (void)broadcastManagerDidActivateCamera:(GSBroadcastManager*)manager
{
}

// 摄像头关闭代理
- (void)broadcastManagerDidInactivateCamera:(GSBroadcastManager*)manager
{
    
}

// 收到一路视频
- (void)broadcastManager:(GSBroadcastManager*)manager didUserJoinVideo:(GSUserInfo *)userInfo
{
    [manager displayVideo:userInfo.userID];
}




// 某个用户退出视频
- (void)broadcastManager:(GSBroadcastManager*)manager didUserQuitVideo:(long long)userID
{
    
}

// 某一路摄像头视频被激活
- (void)broadcastManager:(GSBroadcastManager*)manager didSetVideo:(GSUserInfo*)userInfo active:(BOOL)active
{
}

// 某一路视频被订阅代理
- (void)broadcastManager:(GSBroadcastManager*)manager didDisplayVideo:(GSUserInfo*)userInfo
{
    
}

// 某一路视频取消订阅代理
- (void)broadcastManager:(GSBroadcastManager*)manager didUndisplayVideo:(long long)userID
{
}


// 摄像头或插播视频每一帧的数据代理，软解
- (void)broadcastManager:(GSBroadcastManager*)manager userID:(long long)userID renderVideoFrame:(GSVideoFrame*)videoFrame
{
    [self.videoView1 renderVideoFrame:videoFrame];
}


// 硬解数据从这个代理返回
- (void)OnVideoData4Render:(long long)userId width:(int)nWidth nHeight:(int)nHeight frameFormat:(unsigned int)dwFrameFormat displayRatio:(float)fDisplayRatio data:(void *)pData len:(int)iLen
{

}

/**
 *  手机摄像头开始采集数据
 *
 *  @param manager 触发此代理的GSBroadcastManager对象
 */
- (BOOL)broadcastManagerDidStartCaptureVideo:(GSBroadcastManager*)manager
{
    return YES;
}

/**
 手机摄像头停止采集数据
 */
- (void)broadcastManagerDidStopCaptureVideo:(GSBroadcastManager*)manager
{
}

#pragma mark -
#pragma mark GSBroadcastAudioDelegate

// 音频模块连接代理
- (void)broadcastManager:(GSBroadcastManager*)manager didReceiveAudioModuleInitResult:(BOOL)result
{
    
}

#pragma mark -
#pragma mark System Default Code

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{

    
}

- (BOOL)shouldAutorotate {
    return NO;
}

@end
