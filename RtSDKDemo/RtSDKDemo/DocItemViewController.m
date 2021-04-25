//
//  DocItemViewController.m
//  iOSDemo
//
//  Created by Gaojin Hsu on 3/23/15.
//  Copyright (c) 2015 gensee. All rights reserved.
//

#import "DocItemViewController.h"
#import "MBProgressHUD.h"

/*
 文档的实现细节已经被封装，唯一需要注意的是，要在设置GSBroadcastManager的documentDelegate之前，
 设置它的documentView属性。
 */
@interface DocItemViewController ()<GSBroadcastRoomDelegate, GSBroadcastDocumentDelegate,GSDocViewDelegate>
@property (strong, nonatomic)GSBroadcastManager *broadcastManager;
@property (strong, nonatomic)GSDocView *docView;
@property (strong, nonatomic)MBProgressHUD *progressHUD;
@property (weak, nonatomic) IBOutlet UIView *docArea;
@end

@implementation DocItemViewController

#pragma mark -
#pragma mark View Did Load/Unload

- (void)viewDidLoad {
    [super viewDidLoad];
    // 注意下列代码的顺序
    [self setup];
    
    self.progressHUD = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:self.progressHUD];
    self.progressHUD.labelText =  NSLocalizedString(@"BroadcastConnecting",  @"直播连接提示");
    [self.progressHUD show:YES];
    
    [self initBroadCastManager];
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithTitle:@"back" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = left;
    
}

- (void)back:(id)sender
{
    [self.progressHUD show:YES];
    self.progressHUD.labelText = @"Leaving...";
    [self.broadcastManager leaveAndShouldTerminateBroadcast:NO];
}

- (void)initBroadCastManager
{
    self.broadcastManager = [GSBroadcastManager sharedBroadcastManager];
    
    // 注意下列代码的顺序
      NSLog(@"self.docView=%@",self.docView);  //打印一下
    self.broadcastManager.documentView = self.docView;
    self.broadcastManager.broadcastRoomDelegate = self;
    
    self.broadcastManager.documentDelegate = self;
    
    if (![_broadcastManager connectBroadcastWithConnectInfo:self.connectInfo]) {
        
        [self.progressHUD show:NO];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"WrongConnectInfo", @"参数不正确") delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"知道了") otherButtonTitles:nil, nil];
        [alertView show];
        
    }
    
}

- (void)setup
{
    double version = [[UIDevice currentDevice].systemVersion doubleValue];//判定系统版本。
    CGFloat y;
    
    if (version < 7.0) {
        y = 0;
    }
    else
    {
        if (version >= 8.0)
        {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        y = [[UIApplication sharedApplication]statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;
    }
    
    CGFloat screenW=[UIScreen mainScreen].bounds.size.width;
    _docView = [[GSDocView alloc]initWithFrame:CGRectMake(0, 0,screenW-16,(screenW-16)*3/4 + 20) ];
    self.docArea.backgroundColor=[UIColor redColor];
    _docView.backgroundColor=[UIColor greenColor];
    self.docView.showMode = GSDocViewShowModeScaleAspectFit;
    [self.docArea addSubview:_docView];
    self.docView.delegate = self;
    //old version
//    self.docView.gSDocShowType=GSDocEqualWidthType;
//    self.docView.zoomEnabled = YES;
//    self.docView.isVectorScale= YES;
//    self.docView.fullMode = YES;
//    [self.docArea addSubview:self.docView];
//    self.docView.docDelegate=self;
//    self.docView.hidden=YES;

    
//    self.docView.zoomEnabled = YES;
//    self.docView.isVectorScale= YES;
//    self.docView.fullMode = YES;
    
//    self.broadcastManager.documentView = self.docView;
}

#pragma mark -
#pragma mark GSBroadcastRoomDelegate

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
            
        case GSBroadcastConnectResultLoginFailed:
            
        case GSBroadcastConnectResultNetworkError:
            
        case  GSBroadcastConnectResultThirdTokenError:
            
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
        // 相应处理
    }
}




// 断线重连
- (void)broadcastManagerWillStartRoomReconnect:(GSBroadcastManager*)manager
{
    [self.progressHUD show:YES];
    self.progressHUD.labelText = NSLocalizedString(@"Reconnect", @"正在重连");

}

- (void)broadcastManager:(GSBroadcastManager*)manager didSelfLeaveBroadcastFor:(GSBroadcastLeaveReason)leaveReason
{
    [self.progressHUD hide:YES];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark GSBroadcastDocDelegate

// 文档模块连接代理
- (void)broadcastManager:(GSBroadcastManager*)manager didReceiveDocModuleInitResult:(BOOL)result
{
}

// 文档打开代理
- (void)broadcastManager:(GSBroadcastManager *)manager didOpenDocument:(GSDocument *)doc
{
    
}

// 文档关闭代理
- (void)broadcastManager:(GSBroadcastManager *)manager didCloseDocument:(unsigned int)docID
{
    
}

// 文档切换代理
- (void)broadcastManager:(GSBroadcastManager *)manager didSlideToPage:(unsigned int)pageID ofDoc:(unsigned int)docID step:(int)step
{
    
}





#pragma mark GSDocViewDelegate-----

- (void)docViewOpenFinishSuccess:(GSDocPage*)page   docID:(unsigned)docID
{

    NSLog(@"***docViewOpenFinishSuccess****");
    

    if ( self.docView.hidden) {
        self.docView.hidden=NO;
    }
    

}




#pragma mark -
#pragma mark System Default Code

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    NSLog(@"*********dealloc************");
}
@end
