//
//  DownLoadViewController.m
//  VodSDKDemo
//
//  Created by gs_mac_wjj on 15/9/21.
//  Copyright © 2015年 Gensee. All rights reserved.
//

#import "DownLoadViewController.h"
#import <VodSDK/VodSDK.h>
#import "NSUserDefaults+UserDefaults.h"
#import "ViewController.h"
#import "MBProgressHUD.h"

@interface DownLoadViewController ()<VodDownLoadDelegate>

{
    downItem *downloadItem;
}

@property (nonatomic, weak) IBOutlet UILabel *lable;
@property (nonatomic, weak) IBOutlet UIProgressView *progressbar;
@property (nonatomic, weak) IBOutlet UIButton *downloadBtn;
@property (nonatomic, weak) IBOutlet UIButton *pauseDownloadBtn;
@property (nonatomic, weak) IBOutlet UIButton *deleteDownloadBtn;
@property (nonatomic, weak) IBOutlet UIButton *vodPlayBtn;

@property (nonatomic,strong) VodDownLoader *voddownloader;
@property (nonatomic ,strong) NSString *vodId;

@end

@implementation DownLoadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //    控件初始化
    self.lable.text = @"下载进度: 0%";
    self.progressbar.progress = 0.0;
    self.vodPlayBtn.enabled = NO;
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(clickBackButton)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
    [self.downloadBtn addTarget:self action:@selector(doDownloader) forControlEvents:UIControlEventTouchUpInside];
    [self.pauseDownloadBtn addTarget:self action:@selector(doPauseDownload) forControlEvents:UIControlEventTouchUpInside];
    [self.deleteDownloadBtn addTarget:self action:@selector(doDeleteDownload) forControlEvents:UIControlEventTouchUpInside];
    [self.vodPlayBtn addTarget:self action:@selector(doVodPlay) forControlEvents:UIControlEventTouchUpInside];
    
    if (!self.voddownloader) {
        self.voddownloader = [[VodDownLoader alloc]init];
    }
    self.voddownloader.delegate = self;
    
}

//Navigation返回按钮方法
- (void)clickBackButton
{
    self.voddownloader = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

//添加到下载( 开始下载 )
- (void)doDownloader
{
//    self.voddownloader.vodTimeFlag = YES; //获取下载件大小
    
//    
//    VodParam *vodParam =  [VodParam new];
//    vodParam.domain = @"medtrib.gensee.com";
//    vodParam.number = @"41341478";
//    vodParam.loginName = @"";
//    vodParam.loginPassword = @"";
//    //    vodParam.vodID = @"a650fff1e386425690df66826dc69429";
//    //    vodParam.number = @"38074975";
//    vodParam.vodPassword = @"";
//    vodParam.downFlag = 1;
//    vodParam.serviceType = @"training";
//    vodParam.oldVersion = NO;
//    vodParam.thirdToken = @"";
//    //    vodParam.customUserID = customUserID;
//    vodParam.nickName = @"nihao";
//    [self.voddownloader addItem:vodParam];
    
//    VodParam *vodParam =  [VodParam new];
//    vodParam.domain = @"exam8.gensee.com";
//    vodParam.number = @"";
//    vodParam.loginName = @"";
//    vodParam.loginPassword = @"";
//    vodParam.vodID = @"a650fff1e386425690df66826dc69429";
//    vodParam.vodPassword = @"";
//    vodParam.downFlag = 0;
//    vodParam.serviceType = @"webcast";
//    vodParam.oldVersion = NO;
//    vodParam.thirdToken = @"";
//    //    vodParam.customUserID = customUserID;
//    vodParam.nickName = @"nihao";
//    [self.voddownloader addItem:vodParam ];
    
//    NSArray *tFinishList2 =[[VodManage shareManage] searchFinishedItems];
//    NSArray *tFinishList =[[VodManage shareManage] getListDownItem];
//    NSArray *tFinishList1 =[[VodManage shareManage] getListOfUnDownloadedItem];
    
//    VodParam *vodParam =  [VodParam new];
//    vodParam.domain = @"simuwang.gensee.com";
////    vodParam.number = @"54701932";
//    vodParam.loginName = @"";
//    vodParam.loginPassword = @"";
//    vodParam.downFlag = 1;
//    vodParam.serviceType = @"webcast";
//    vodParam.oldVersion = NO;
//    vodParam.thirdToken = @"";
//    vodParam.nickName = @"";
//    vodParam.vodID = @"f970492c7e10417ca0bfecd1027d8c7d";
//    [self.voddownloader addItem:vodParam];
//    [_voddownloader addItem:@"cjl.gensee.com" number:nil loginName:@"11111" vodPassword:nil loginPassword:nil vodid:@"qNpxBEWjsw" downFlag:1 serType:@"training" oldVersion:YES  kToken:nil customUserID:100000000];
//    
//    VodParam *vodParam =  [VodParam new];
//    vodParam.domain = @"qa100.gensee.com";
//    vodParam.number = @"59885575";
//    vodParam.loginName = @"";
//    vodParam.loginPassword = @"";
//    vodParam.downFlag = 1;
//    vodParam.serviceType = @"webcast";
//    vodParam.oldVersion = NO;
//    vodParam.thirdToken = @"";
//    vodParam.nickName = @"";
//    vodParam.vodPassword = @"333333";
//    [self.voddownloader addItem:vodParam ];
    
//    VodParam *params = [VodParam new];
//    params.domain =  @"duia.gensee.com";
//    //    params.number = @"";
//    params.loginName = @"";
//    params.vodPassword = @"";
//    params.loginPassword = @"";
//    params.downFlag = 1;
//    params.serviceType = @"webcast";
//    params.oldVersion = NO;
//    params.customUserID = 0;
//    params.vodID = @"f94317ec209c4985b05d085f43508f34";
//    //    self.voddownloader.httpAPIEnabled = YES;
//    [self.voddownloader addItem:params];
    
    

    [self.voddownloader addItem:_domain number:_number loginName:nil vodPassword:_vodPassword loginPassword:nil downFlag:0 serType:_seviceType oldVersion:NO
                         kToken:nil customUserID:0];
//
//    [self.voddownloader addItem:@"duia.gensee.com" number:@"" loginName:@"admin@gensee.com" vodPassword:@"" loginPassword:@"duia123456" vodid:@"d333a843d9aa46c3bee740564d22b35d"  downFlag:1 serType:@"webcast" oldVersion:YES kToken:nil customUserID:0];
//
//  [_voddownloader addItem:@"sunlands.gensee.com" number:@"" loginName:@"" vodPassword:@"999999" loginPassword:@"" vodid:@"22982b277a3b4cce91e3cba484e8f17e" downFlag:1 serType:@"webcast" oldVersion:NO kToken:nil customUserID:0];
//
//    
//    [self.voddownloader addItem:@"weiyiceshi.gensee.com" number:@"62239998" loginName:nil vodPassword:@"333333" loginPassword:nil downFlag:1 serType:@"webcast" oldVersion:NO
//                         kToken:nil customUserID:0];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

//暂停下载
- (void)doPauseDownload
{
    [_voddownloader stop:_vodId];
}

//删除下载
- (void)doDeleteDownload
{
    [self.voddownloader delete:_vodId];
    [self.progressbar setProgress:0.0];
    self.lable.text = @"下载进度: 0%";
    _vodPlayBtn.enabled = NO;
}

//离线播放
- (void)doVodPlay
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ViewController *vodViewController = [board instantiateViewControllerWithIdentifier:@"player"];
    [vodViewController setItem:downloadItem];
    [vodViewController setIsLivePlay:NO];
    [self.navigationController pushViewController:vodViewController animated:YES];
}

#pragma mark - VodDownLoadDelegate
//下载进度代理
- (void)onDLPosition:(NSString *)downLoadId percent:(float)percent
{
    NSString *percentstr = [NSString stringWithFormat:@"下载进度: %f",percent];
    _lable.text = percentstr;
    [_progressbar setProgress:percent/100 animated:YES];
}

//下载开始代理
- (void)onDLStart:(NSString *)downLoadId{
    NSLog(@"APP:下载开始");
}


- (void) onDLStop:(NSString*) downloadID {
    
}
//下载完成代理
- (void) onDLFinish:(NSString*) downLoadId
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"下载完成" ,@"") delegate:nil cancelButtonTitle:NSLocalizedString(@"知道了",@"") otherButtonTitles:nil, nil];
    [alertView show];
    _vodPlayBtn.enabled = YES;
}

//下载出错代理
- (void)onDLError:(NSString *)downloadID Status:(VodDownLoadStatus)errorCode
{
    NSLog(@"APP:下载出错");
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"下载出错" ,@"") delegate:nil cancelButtonTitle:NSLocalizedString(@"知道了",@"") otherButtonTitles:nil, nil];
    [alertView show];
}

//添加到下载代理
- (void)onAddItemResult:(RESULT_TYPE)resultType voditem:(downItem *)item{
    NSLog(@"APP: onAddItemResult:(RESULT_TYPE)resultType voditem:(downItem*)item");
    if (resultType == RESULT_SUCCESS) {
        _vodId = item.strDownloadID;
        downloadItem = [[VodManage shareManage]findDownItem:_vodId];
        [self.voddownloader download:downloadItem chatPost:NO];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"未知错误" ,@"") delegate:nil cancelButtonTitle:NSLocalizedString(@"知道了",@"") otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
