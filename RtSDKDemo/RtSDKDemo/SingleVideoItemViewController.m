//
//  SingleVideoItemViewController.m
//  iOSDemo
//
//  Created by Gaojin Hsu on 3/18/15.
//  Copyright (c) 2015 gensee. All rights reserved.
//

#import "SingleVideoItemViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "Reachability.h"
#import <GSCommonKit/GSCommonKit.h>


/*
 以视频形式展现的数据有两种，一种是真正意义上的视频即『视频』（Video），另一种是『桌面共享』（DesktopShare）; 尽管
 他们的形式很接近，但是它们所需要实现的代理是不同的，所以要对它们分开处理， 视频需要实现GSBroadcastVideoDelegate，
 而桌面共享需要实现GSBroadcastDesktopShareDelegate；『视频』（Video）又可以细分为『摄像头视频』（Camera Video）』和
 『插播』（Lod Video），他们之间没有本质的区别，唯一的区别是插播的UserID 是固定值（LOD_USER_ID），插播是指在直播端客户端播放媒体文件，
 而所谓的一路视频的场景是指只有一个View可以显示视频，但是有的直播端（有时候也称教师端，一般是PC或Mac客户端）能同时发送桌面共享和视频，
 因此需要自己实现逻辑控制他们的播放优先级，一般来说桌面共享和插播的优先级要大于摄像头视频，桌面共享和和插播在直播端是无法同时打开的，
 因此他们之前没有优先级之分。下面的例子是实现一路视频，桌面共享或者插播的优先级要大于摄像头视频。
 */


#define DegreesToRadians(x) ((x) * M_PI / 180.0)



@interface SingleVideoItemViewController ()<GSBroadcastRoomDelegate, GSBroadcastVideoDelegate, GSBroadcastDesktopShareDelegate, GSBroadcastAudioDelegate, UIAlertViewDelegate>
{
   BOOL videoFullScreen; //视频全屏
    
    Reachability* reach;

    NetworkStatus status;
}

@property (strong, nonatomic)GSBroadcastManager *broadcastManager;
@property (strong, nonatomic)GSVideoView *videoView;
@property (strong, nonatomic)GSVideoView *asVideoView;
@property (assign, nonatomic)long long currentActiveUserID; // 当前激活的视频ID

@property (assign, nonatomic)BOOL isCameraVideoDisplaying;
@property (assign, nonatomic)BOOL isLodVideoDisplaying;
@property (assign, nonatomic)BOOL isDesktopShareDisplaying;

@property (strong, nonatomic)MBProgressHUD *progressHUD;
@property (assign, nonatomic)CGRect originalVideoFrame;

@property (weak, nonatomic) IBOutlet UIButton *receiveVideoBtn;
@property (weak, nonatomic) IBOutlet UIButton *rejectVideoBtn;
@property (weak, nonatomic) IBOutlet UIButton *receiveAudioBtn;
@property (weak, nonatomic) IBOutlet UIButton *rejectAudioBtn;

@property (weak, nonatomic) IBOutlet UIView *ActiveVideoView;
@property (weak, nonatomic) IBOutlet UIView *CameraView;

@property (nonatomic, copy) NSString *askKey;
@property (strong, nonatomic) NSMutableDictionary *trainingDic;
@end

@implementation SingleVideoItemViewController {
    GSVideoView *previewView;
    long long _userID;
}

#pragma mark -
#pragma mark View Did Load/Undload

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _userID = 0;
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *isException= [defaults objectForKey:IsException];
    if ([isException isEqualToString:@"YES"]) {
        UIAlertView *alert =
        [[UIAlertView alloc]
         initWithTitle:NSLocalizedString(@"错误报告", nil)
         message:@"检测到程序意外终止，是否发送错误报告"
         delegate:self
         cancelButtonTitle:NSLocalizedString(@"忽略", nil)
         otherButtonTitles:NSLocalizedString(@"发送", nil), nil];
        alert.tag=1004;
        [alert show];
    }
    [defaults setObject:@"NO" forKey:IsException];
    
    
    [self setup];
    
    _progressHUD = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:_progressHUD];
    _progressHUD.labelText =  NSLocalizedString(@"BroadcastConnecting",  @"直播连接提示");
    [_progressHUD show:YES];
    
    _trainingDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@0,@"user.asker",@0,@"user.asker1",@0,@"user.asker2",@0,@"user.asker3",@0,@"user.asker4",@0,@"user.rostrum", nil];
    
    
    [self initBroadCastManager];

    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithTitle:@"退出直播" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = left;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(reachabilityChanged:)
     
                                                 name:kReachabilityChangedNotification object:nil];
    
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(onBackground:)
                                            name:UIApplicationWillResignActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(onForeground:)
     
                                                 name:UIApplicationDidBecomeActiveNotification object:nil];

    // 获取访问指定站点的Reachability对象
    reach = [Reachability
             
             reachabilityWithHostName:@"www.baidu.com"];
    
    // 让Reachability对象开启被监听状态
    [reach startNotifier];
    
}


- (void)onBackground:(NSNotification*)notify
{
    if (!_isDesktopShareDisplaying) {
        [_broadcastManager undisplayVideo:_currentActiveUserID];
    }

}

- (void)onForeground:(NSNotification*)notify
{
    if (!_isDesktopShareDisplaying) {
        [_broadcastManager displayVideo:_currentActiveUserID];
      }
}


- (void)reachabilityChanged:(NSNotification *)note

{
    
    
    // 通过通知对象获取被监听的Reachability对象
    
    Reachability *curReach = [note object];
    
    // 获取Reachability对象的网络状态
    
    status = [curReach currentReachabilityStatus];
    
    if (status == NotReachable)
        
    {
        // 强制重连
        [[GSBroadcastManager sharedBroadcastManager]setCurrentIDC:@""];
        
    }else if (status ==ReachableViaWiFi||status ==ReachableViaWWAN){
        
        // 强制重连
        [[GSBroadcastManager sharedBroadcastManager]setCurrentIDC:@""];
    }
    
    
    
}

#pragma mark -


- (void)initBroadCastManager
{
    _broadcastManager = [GSBroadcastManager sharedBroadcastManager];
    _broadcastManager.broadcastRoomDelegate = self;
    _broadcastManager.videoDelegate = self;
    _broadcastManager.desktopShareDelegate = self;
    _broadcastManager.audioDelegate = self;

    if (![_broadcastManager connectBroadcastWithConnectInfo:self.connectInfo]) {
        
        [_progressHUD show:NO];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"WrongConnectInfo", @"参数不正确") delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"知道了") otherButtonTitles:nil, nil];
        [alertView show];

    }

}

- (void)setup
{

    CGFloat y = self.navigationController.navigationBar.frame.size.height+[[UIApplication sharedApplication] statusBarFrame].size.height;
    
    double version = [[UIDevice currentDevice].systemVersion doubleValue];//判定系统版本。
    if (version < 7.0) {
        y -= 64;
    }
    
    _originalVideoFrame = CGRectMake(0, y, self.view.frame.size.width, self.view.frame.size.width - 70);
    
    self.videoView = [[GSVideoView alloc]initWithFrame:_ActiveVideoView.bounds];
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleVideoViewTap:)];
    tapGes.numberOfTapsRequired = 2;
    [self.ActiveVideoView addGestureRecognizer:tapGes];
    self.videoView.videoViewContentMode = GSVideoViewContentModeRatioFill;
    [self.ActiveVideoView addSubview:self.videoView];
    
    self.asVideoView = [[GSVideoView alloc] initWithFrame:self.ActiveVideoView.bounds];
    self.asVideoView.videoViewContentMode = GSVideoViewContentModeRatioFill;
}

#pragma mark -
#pragma mark Actions

- (void)switchFullScreen:(UIGestureRecognizer*)tapGes
{
    
    AppDelegate *appDelegate = ( AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.allowRotation =  !appDelegate.allowRotation;
    
    //强制旋转
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {

            [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIDeviceOrientationPortrait] forKey:@"orientation"];

    } else {

            [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger: UIInterfaceOrientationLandscapeRight ] forKey:@"orientation"];
        
    }

}


//自动旋转
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)
interfaceOrientation duration:(NSTimeInterval)duration {
    
    if (!UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        self.videoView.frame = _originalVideoFrame;
        
        [_receiveAudioBtn setHidden:NO];
        [_receiveVideoBtn setHidden:NO];
        [_rejectAudioBtn setHidden:NO];
        [_rejectVideoBtn setHidden:NO];
        
    }else {
        
        [_receiveAudioBtn setHidden:YES];
        [_receiveVideoBtn setHidden:YES];
        [_rejectAudioBtn setHidden:YES];
        [_rejectVideoBtn setHidden:YES];
        
        CGFloat y = self.navigationController.navigationBar.frame.size.height+[[UIApplication sharedApplication] statusBarFrame].size.height;
        
        double version = [[UIDevice currentDevice].systemVersion doubleValue];//判定系统版本。
        if (version < 7.0) {
            y = 0;
        }
        self.videoView.frame = CGRectMake(0, y, self.view.frame.size.width, self.view.frame.size.height - y);
        
        
    }
    
}


- (void)handleVideoViewTap:(UITapGestureRecognizer*)recognizer
{
    if (!videoFullScreen)
    {
        [UIView animateWithDuration:0.5 animations:^{
            self.view.transform = CGAffineTransformMakeRotation(M_PI/2);
            self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
            self.videoView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
            
            videoFullScreen = YES;

            [_receiveAudioBtn setHidden:YES];
            [_receiveVideoBtn setHidden:YES];
            [_rejectAudioBtn setHidden:YES];
            [_rejectVideoBtn setHidden:YES];
            
            self.navigationController.navigationBarHidden = YES;
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
        }];
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            self.view.transform = CGAffineTransformInvert(CGAffineTransformMakeRotation(0));
            self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);

            self.videoView.frame = _originalVideoFrame;
            videoFullScreen = NO;
            [_receiveAudioBtn setHidden:NO];
            [_receiveVideoBtn setHidden:NO];
            [_rejectAudioBtn setHidden:NO];
            [_rejectVideoBtn setHidden:NO];
            
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
            self.navigationController.navigationBarHidden = NO;
        }];
    }
}


- (long long)myUserID {
    if (!_userID) {
        GSUserInfo *info = [[GSBroadcastManager sharedBroadcastManager] queryMyUserInfo];
        _userID = info.userID;
    }
    return _userID;
}


- (IBAction)turnOnVideo:(id)sender {
    
    if (_isLodVideoDisplaying) {
        [_broadcastManager displayVideo:LOD_USER_ID];
    }else
    {
        [_broadcastManager displayVideo:_currentActiveUserID];
    }
}

- (IBAction)turnOffVideo:(id)sender {
    if (_isLodVideoDisplaying)
    {
        [_broadcastManager undisplayVideo:LOD_USER_ID];
    }else
    {
        
        [_broadcastManager undisplayVideo:_currentActiveUserID];
    }
    
}

- (IBAction)turnOnSpeaker:(id)sender {
    [_broadcastManager activateSpeaker];

}

- (IBAction)trunOffSpeaker:(id)sender {
    [_broadcastManager inactivateSpeaker];
}

- (void)back:(id)sender
{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [_progressHUD show:YES];
    _progressHUD.labelText = @"Leaving...";
    [_broadcastManager leaveAndShouldTerminateBroadcast:NO];
    
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
        case GSBroadcastConnectResultSuccess:{
            // 直播初始化成功，加入直播
            BOOL rl = [_broadcastManager join];
            if (!rl) {
                errorMsg = @"加入失败";
            }
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

//小班课上
- (void)broadcastManager:(GSBroadcastManager *)manager didReceiveBroadcastInfoKey:(NSString *)key value:(long long)value {
    if ([key containsString:@"user.asker"]) { //上提问席
        if (value == [self myUserID]) {
            self.askKey = key;
            [[GSBroadcastManager sharedBroadcastManager] activateCamera:NO landscape:NO];
            [[GSBroadcastManager sharedBroadcastManager] activateMicrophone];
        }else if (value == 0 && [self.askKey isEqualToString:key]){
            self.askKey = nil;
            [[GSBroadcastManager sharedBroadcastManager] inactivateCamera];
            [[GSBroadcastManager sharedBroadcastManager] inactivateMicrophone];
        }
    }else if ([key isEqualToString:@"user.rostrum"]) { //上讲台
        if (value == [self myUserID]) {
            self.askKey = key;
            _currentActiveUserID = value;
            [[GSBroadcastManager sharedBroadcastManager] activateCamera:NO landscape:NO];
            [[GSBroadcastManager sharedBroadcastManager] activateMicrophone];
        }else if (value == 0 ){
            if ([self.askKey isEqualToString:key]) {
                self.askKey = nil;
                _currentActiveUserID = 0;
                [[GSBroadcastManager sharedBroadcastManager] inactivateCamera];
                [[GSBroadcastManager sharedBroadcastManager] inactivateMicrophone];
            }else{
                if (_currentActiveUserID > 0) {
                    [[GSBroadcastManager sharedBroadcastManager] undisplayVideo:_currentActiveUserID];
                }
                _isCameraVideoDisplaying = NO;
                _currentActiveUserID = 0;
            }
            
        }else { //别人上讲台
            [[GSBroadcastManager sharedBroadcastManager] displayVideo:value];
            _currentActiveUserID = value;
            _isCameraVideoDisplaying = NO;
            _videoView.videoLayer.hidden = NO;
        }
    }
}

// 断线重连
- (void)broadcastManagerWillStartRoomReconnect:(GSBroadcastManager*)manager
{
    [_progressHUD show:YES];
    _progressHUD.labelText = @"正在重连...";
    
}


 // 自己离开直播代理
- (void)broadcastManager:(GSBroadcastManager*)manager didSelfLeaveBroadcastFor:(GSBroadcastLeaveReason)leaveReason
{
    [_broadcastManager invalidate];

    [_progressHUD hide:YES];

    [self.navigationController popViewControllerAnimated:YES];

}

#pragma mark -
#pragma mark GSBroadcastVideoDelegate
// 收到一路视频
- (void)broadcastManager:(GSBroadcastManager*)manager didUserJoinVideo:(GSUserInfo *)userInfo
{
    // 判断是否是插播，插播优先级比摄像头视频大
  if (userInfo.userID == LOD_USER_ID)
  {
      //为了删掉最后一帧的问题， 收到新数据的时候GSVideoView的videoLayer自动创建
      [_videoView.videoLayer removeFromSuperlayer];
      _videoView.videoLayer = nil;
      
      // 如果之前有摄像头视频作为直播视频，先要取消订阅摄像头视频
      if (_isCameraVideoDisplaying) {
          [_broadcastManager undisplayVideo:_currentActiveUserID];
      }
      
      [_broadcastManager displayVideo:LOD_USER_ID];
      _isLodVideoDisplaying = YES;
  }
}

// 某个用户退出视频
- (void)broadcastManager:(GSBroadcastManager*)manager didUserQuitVideo:(long long)userID
{
    // 判断是否是插播结束
    if (userID == LOD_USER_ID)
    {
        //为了删掉最后一帧的问题， 收到新数据的时候GSVideoView的videoLayer自动创建
        [_videoView.videoLayer removeFromSuperlayer];
        _videoView.videoLayer = nil;
        _isLodVideoDisplaying = NO;
        // 如果之前有摄像头视频在直播，需要恢复之前的直播视频
        if (_currentActiveUserID != 0) {
            [_broadcastManager displayVideo:_currentActiveUserID];
        }
        
        
    }

}

// 某一路摄像头视频被激活
- (void)broadcastManager:(GSBroadcastManager*)manager didSetVideo:(GSUserInfo*)userInfo active:(BOOL)active
{
    if (active)
    {
        // 桌面共享和插播的优先级比摄像头视频大
        if (!_isDesktopShareDisplaying && !_isLodVideoDisplaying) {//直播
            
            // 订阅当前激活的视频
            [_broadcastManager displayVideo:userInfo.userID];
            _currentActiveUserID = userInfo.userID;
            _isCameraVideoDisplaying = YES;
            _videoView.videoLayer.hidden = NO;
        }
    }
    else//其它
    {
        if (userInfo.userID == _currentActiveUserID) {
            _isCameraVideoDisplaying = NO;
        }
        
        _currentActiveUserID = 0;
        [_broadcastManager undisplayVideo:userInfo.userID];
    }
}



// 摄像头或插播视频每一帧的数据代理，软解
- (void)broadcastManager:(GSBroadcastManager*)manager userID:(long long)userID renderVideoFrame:(GSVideoFrame*)videoFrame
{
    // 指定Videoview渲染每一帧数据
    [_videoView renderVideoFrame:videoFrame];
}


// 硬解数据从这个代理返回
- (void)OnVideoData4Render:(long long)userId width:(int)nWidth nHeight:(int)nHeight frameFormat:(unsigned int)dwFrameFormat displayRatio:(float)fDisplayRatio data:(void *)pData len:(int)iLen
{
    
    [_videoView hardwareAccelerateRender:pData size:iLen dwFrameFormat:dwFrameFormat];
}

/**
 *  手机摄像头开始采集数据
 *  @param manager 触发此代理的GSBroadcastManager对象
 */
- (BOOL)broadcastManagerDidStartCaptureVideo:(GSBroadcastManager*)manager
{
    
    previewView = [[GSVideoView alloc]initWithFrame:_CameraView.bounds];
    [self.CameraView addSubview: previewView];
    [GSBroadcastManager sharedBroadcastManager].videoView = previewView;
    
    if ([self.askKey isEqualToString:@"user.rostrum"]) {
        [[GSBroadcastManager sharedBroadcastManager] setVideo:[self myUserID] active:YES];
    }
    return YES;
}


/**
  索取直播设置信息代理
 */
- (BOOL) broadcastManager:(GSBroadcastManager *)manager querySettingsInfoKey:(NSString *)key numberValue:(int *)value
{
    if ([key isEqualToString:@"save.video.height"]) {
        *value = 360;
    }else if ([key isEqualToString:@"save.video.width"])
    {
        *value = 480;
    }
    return YES;
}



/**
 手机摄像头停止采集数据
 */
- (void)broadcastManagerDidStopCaptureVideo:(GSBroadcastManager*)manager
{
    [previewView removeFromSuperview];
    previewView = nil;
}




#pragma mark GSBroadcastDesktopShareDelegate
// 开启桌面共享代理
- (void)broadcastManager:(GSBroadcastManager*)manager didActivateDesktopShare:(long long)userID
{
    _isDesktopShareDisplaying = YES;
    _videoView.hidden = YES;
    _asVideoView.hidden = NO;
    [self.ActiveVideoView addSubview:_asVideoView];
    // 桌面共享时，需要主动取消订阅当前直播的摄像头视频
    if (_currentActiveUserID != 0) {
        [_broadcastManager undisplayVideo:_currentActiveUserID];
    }
}


// 桌面共享视频每一帧的数据代理, 软解数据
- (void)broadcastManager:(GSBroadcastManager*)manager renderDesktopShareFrame:(UIImage*)videoFrame
{
    // 指定Videoview渲染每一帧数据
    if (_isDesktopShareDisplaying) {
        [_asVideoView renderAsVideoByImage:videoFrame];
    }
}


// 桌面共享关闭代理
- (void)broadcastManagerDidInactivateDesktopShare:(GSBroadcastManager*)manager
{
    _asVideoView.hidden = YES;
    _videoView.hidden = NO;
    [_asVideoView removeFromSuperview];
    // 如果桌面共享前，有摄像头视频在直播，需要在结束桌面共享后恢复
    if (_currentActiveUserID != 0)
    {
        _videoView.videoLayer.hidden = NO;
        [_broadcastManager displayVideo:_currentActiveUserID];
    }
     _isDesktopShareDisplaying = NO;
}
@end
