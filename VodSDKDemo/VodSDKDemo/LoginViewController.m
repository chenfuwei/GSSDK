//
//  LoginViewController.m
//  VodSDKDemo
//
//  Created by gs_mac_wjj on 15/9/21.
//  Copyright © 2015年 Gensee. All rights reserved.
//

#import "ViewController.h"
#import "NSUserDefaults+UserDefaults.h"
#import "LoginViewController.h"
#import "DownLoadViewController.h"
#import "MBProgressHUD.h"


@interface LoginViewController ()<UITextFieldDelegate,VodDownLoadDelegate>
{
    BOOL islivePlay;
    MBProgressHUD *progressHUD;
    NSMutableArray *vodItems;
    NSUInteger index;
}

@property (weak, nonatomic) IBOutlet UITextField *domain;
@property (weak, nonatomic) IBOutlet UITextField *serviceType;
@property (weak, nonatomic) IBOutlet UITextField *number;
@property (weak, nonatomic) IBOutlet UITextField *vodPassword;
@property (weak, nonatomic) IBOutlet UIButton *downloadBtn;
@property (weak, nonatomic) IBOutlet UIButton *livePlayBtn;
@property (weak, nonatomic) IBOutlet UITextField *thirdTokenTextField;


@property (nonatomic, strong) VodDownLoader *voddownloader;
@property (nonatomic, strong) ViewController *liveViewController;
@property (nonatomic, strong) DownLoadViewController *downloadViewController;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    vodItems = [NSMutableArray array];
    
    VodParam * param = [[VodParam alloc]init];
    param.domain = @"yimengsh.gensee.com";
    param.vodID = @"7a6cf4930b2d47b5aeae92183bf9ac29";
    param.serviceType = @"webcast";
    param.oldVersion = YES;
    param.customUserID = 0;
    param.downFlag = 0;
    [vodItems addObject:param];

    VodParam *vodParam = [[VodParam alloc]init];
    vodParam.domain = @"sunlands.gensee.com";
    vodParam.vodID = @"22982b277a3b4cce91e3cba484e8f17e";
    vodParam.loginName = @"";
    vodParam.loginPassword = @"";
    vodParam.vodPassword = @"999999";
    vodParam.downFlag = 0;
    vodParam.serviceType = @"webcast";
    [vodItems addObject:vodParam];
    
    VodParam *vodParam2 = [[VodParam alloc]init];
    vodParam2.domain = @"exam8.gensee.com";
    vodParam2.number = @"63636424";
    vodParam2.vodPassword = @"";
    vodParam2.serviceType = @"webcast";
    vodParam2.downFlag = 0;
    [vodItems addObject:vodParam2];
    
//    获取上次输入的数据
    _domain.text = [[NSUserDefaults standardUserDefaults] getDomain];
    _serviceType.text = [[NSUserDefaults standardUserDefaults] getServiceType];
    _number.text = [[NSUserDefaults standardUserDefaults] getNumber];
    _vodPassword.text = [[NSUserDefaults standardUserDefaults] getVodPassword];
    
    _domain.delegate = self;
    _serviceType.delegate = self;
    _number.delegate = self;
    _vodPassword.delegate = self;
    _thirdTokenTextField.delegate = self;
    
//    _domain.text = @"wansecheng.gensee.com";
//    _serviceType.text = @"webcast";
//    _number.text = @"22869015";
//    _vodPassword.text = @"";

    [_downloadBtn addTarget:self action:@selector(doDownload) forControlEvents:UIControlEventTouchUpInside];
    [_livePlayBtn addTarget:self action:@selector(doLivePlay) forControlEvents:UIControlEventTouchUpInside];
    
    if (!_voddownloader) {
        _voddownloader = [[VodDownLoader alloc]init];
    }
    _voddownloader.delegate = self;

}

/**
 *下载
 */
- (void)doDownload
{
    islivePlay = NO;
//    存入输入的数据
    [[NSUserDefaults standardUserDefaults] setDomain:_domain.text];
    [[NSUserDefaults standardUserDefaults] setServiceType:_serviceType.text];
    [[NSUserDefaults standardUserDefaults] setNumber:_number.text];
    [[NSUserDefaults standardUserDefaults] setVodPassword:_vodPassword.text];
    [[NSUserDefaults standardUserDefaults] synchronize];


//    NSArray *tFinishList =[[VodManage shareManage] searchFinishedItems];
    
//
//    VodParam *vodParam =  [VodParam new];
//    vodParam.domain = @"mingding.gensee.com";
//    vodParam.number = @"54701932";
//    vodParam.loginName = @"";
//    vodParam.loginPassword = @"";
//    vodParam.downFlag = 1;
//    vodParam.serviceType = @"webcast";
//    vodParam.oldVersion = NO;
//    vodParam.thirdToken = @"";
//    vodParam.nickName = @"";
//    [self.voddownloader addItem:vodParam ];
    
//    [_voddownloader addItem:@"cjl.gensee.com" number:nil loginName:@"11111" vodPassword:nil loginPassword:nil vodid:@"qNpxBEWjsw" downFlag:1 serType:@"training" oldVersion:YES  kToken:nil customUserID:100000000];
    
//    
//    VodParam *vodParam =  [VodParam new];
    
//    
//    vodParam.domain = @"nami.gensee.com";
//    vodParam.number = @"53599168";
//    vodParam.loginName = @"";
//    vodParam.loginPassword = @"";
//    vodParam.vodPassword = @"088196";
//    vodParam.downFlag = 0;
//    vodParam.serviceType = @"webcast";
    
    
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

    
    [_voddownloader addItem:_domain.text number:_number.text loginName:nil vodPassword:_vodPassword.text loginPassword:nil downFlag:0 serType:_serviceType.text oldVersion:NO
                     kToken:_thirdTokenTextField.text customUserID:0];

    
    NSArray *array =  [[VodManage shareManage] getListOfUnDownloadedItem];
    
    for (downItem *item in array) {
        NSLog(@"item size: %@", item.fileSize);
    }
    

//    [_voddownloader addItem:@"sunlands.gensee.com" number:@"" loginName:@"" vodPassword:@"999999" loginPassword:@"" vodid:@"22982b277a3b4cce91e3cba484e8f17e" downFlag:1 serType:@"webcast" oldVersion:NO kToken:nil customUserID:0];
    
//    [_voddownloader addItem:@"svmuu.gensee.com" number:nil loginName:nil vodPassword:nil loginPassword:nil vodid:@"efd71d9424ad48f2a71c1be5d7e12d73" downFlag:0 serType:@"webcast" oldVersion:NO kToken:nil];

    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    _downloadViewController = [board instantiateViewControllerWithIdentifier:@"downloader"];

//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}


//URLEncode
- (NSString*)encodeString:(NSString*)unencodedString{
    
    // CharactersToBeEscaped = @":/?&=;+!@#$()~',*";
    // CharactersToLeaveUnescaped = @"[].";
    
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)unencodedString,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    
    return encodedString;
}

/**
 *在线播放
 */
- (void)doLivePlay
{
    islivePlay = YES;
    //    存入输入的数据
    [[NSUserDefaults standardUserDefaults] setDomain:_domain.text];
    [[NSUserDefaults standardUserDefaults] setServiceType:_serviceType.text];
    [[NSUserDefaults standardUserDefaults] setNumber:_number.text];
    [[NSUserDefaults standardUserDefaults] setVodPassword:_vodPassword.text];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
//    VodParam *params = [VodParam new];
//    params.domain =  @"gtja.gensee.com";
////    params.number = @"";
//    params.loginName = @"";
//    params.vodPassword = @"";
//    params.loginPassword = @"";
//    params.downFlag = 0;
//    params.serviceType = @"webcast";
//    params.oldVersion = NO;
//    params.customUserID = 0;
//    params.vodID = @"2edc9c6225564f4cbe68e58329b427f5";
////    self.voddownloader.httpAPIEnabled = YES;
//    [self.voddownloader addItem:params];
    self.voddownloader.vodTimeFlag = YES;
    
//    VodParam *vodParam =  [VodParam new];
//    vodParam.domain = @"htexam.gensee.com";
//    vodParam.number = @"72835150";
//    vodParam.loginName = @"";
//    vodParam.loginPassword = @"";
//    vodParam.vodPassword = @"yi1232018qi";
//    vodParam.downFlag = 0;
//    vodParam.serviceType = @"webcast";
//    //    vodParam.oldVersion = YES;
//    vodParam.thirdToken = @"";
//    vodParam.nickName = @"nihao";
//    vodParam.vodID = @"ffd72bd289794bb3b88789bfe6ab0485";
//    [_voddownloader addItem:vodParam];
    
//    [_voddownloader addItem:@"medtrib.gensee.com"
//                     number:@"45732996"
//                  loginName:@""
//                vodPassword:@""
//              loginPassword:@""
//                   downFlag:0
//                    serType:@"training"
//                 oldVersion:NO
//                     kToken:@"" customUserID:0];
//
    
//    http://simuwang.gensee.com/webcast/site/vod/play-f970492c7e10417ca0bfecd1027d8c7d
#if 0
    VodParam *vodParam =  [VodParam new];
    vodParam.domain = @"simuwang.gensee.com";
    //    vodParam.number = @"87079577";
    vodParam.loginName = @"";
    vodParam.loginPassword = @"";
    vodParam.vodPassword = @"";
    vodParam.vodID = @"c9206ab8b4144f20af20bb9e52a4f994";
    vodParam.downFlag = 0;
    vodParam.serviceType = @"webcast";
    //    vodParam.number = @"85010722";
    vodParam.customUserID = 1010507411;
    
//    VodParam *vodParam =  [VodParam new];
//    vodParam.domain = @"simuwang.gensee.com";
////    vodParam.number = @"87079577";
//    vodParam.loginName = @"";
//    vodParam.loginPassword = @"";
//    vodParam.vodPassword = @"";
//    vodParam.vodID = @"f970492c7e10417ca0bfecd1027d8c7d";
//    vodParam.downFlag = 0;
//    vodParam.serviceType = @"webcast";
////    vodParam.number = @"85010722";
//    vodParam.customUserID = 1010507411;
#else
    VodParam *vodParam =  [VodParam new];
    vodParam.domain = _domain.text;
    //    vodParam.number = @"";
    vodParam.loginName = @"";
    vodParam.nickName = @"Vod demo";
    vodParam.loginPassword = @"";
    vodParam.vodPassword = _vodPassword.text;
    //    vodParam.vodID = @"a7583f1e5df84f598034d486fe323f9a";
    vodParam.number = _number.text;
    vodParam.downFlag = 0;
    vodParam.serviceType = _serviceType.text;
#endif

    [self.voddownloader setHttpAPIEnabled:YES];
//    vodParam.oldVersion = YES;
    [self.voddownloader addItem:vodParam];
//    self.voddownloader.vodTimeFlag = YES;
    
//    VodParam *vodParam =  [VodParam new];
//    vodParam.domain = @"miaocode.gensee.com";
//    vodParam.number = @"03520928";
//    vodParam.loginName = @"";
//    vodParam.loginPassword = @"";
//    vodParam.vodPassword = @"254438";
////    vodParam.vodID = @"8SxrbEGHbY";
//    vodParam.downFlag = 0;
//    vodParam.nickName = @"ios";
//    vodParam.serviceType = @"training";
////    vodParam.thirdToken = @"1508206521a61aa58910993657e1a03d";
////    vodParam.customUserID = 1010507411;
//    vodParam.oldVersion = NO;
//    self.voddownloader.vodTimeFlag = YES;
//    [self.voddownloader addItem:vodParam];
    
//    
//    VodParam *_docParam = [VodParam new];
//    _docParam.domain = @"zhibo.instrument.com.cn";
//    _docParam.number = @"27248851";
//    _docParam.vodPassword = @"123456";
//    _docParam.loginName = @"";
//    _docParam.serviceType = @"training";
//    _docParam.downFlag = 0;
//    _docParam.oldVersion = NO;
//    _docParam.thirdToken = nil;
//    _docParam.customUserID = 0;
////    self.voddownloader.vodTimeFlag = YES;
    
//    VodParam *vodParam =  [VodParam new];
//    vodParam.domain = @"yuanmeng100.gensee.com";
//    vodParam.number = @"90573731";
//    vodParam.loginName = @"";
//    vodParam.loginPassword = @"";
//    vodParam.vodPassword = @"333333";
//    vodParam.downFlag = 0;
//    vodParam.serviceType = @"training";
//    vodParam.oldVersion = YES;
//    vodParam.thirdToken = @"";
//    vodParam.nickName = @"nihao";
//    vodParam.vodID = @"ZJl7csbOyM";
//    [self.voddownloader addItem:vodParam ];
    
//    if (++index > vodItems.count - 1) {
//        index = 0;
//    }
    
//    VodParam *param = [[VodParam alloc]init];
//    param.domain = @"btsj.gensee.com";
//    param.vodID = @"B0EhbxDwyM";
//    param.number = @"58585749";
//    param.vodPassword = @"717683";
//    param.nickName = @"小王";
//    param.downFlag = 0;
//    param.serviceType = @"training";
//    [self.voddownloader addItem:param];
    
//    [_voddownloader addItem:_domain.text number:_number.text loginName:nil vodPassword:_vodPassword.text loginPassword:nil downFlag:0 serType:_serviceType.text oldVersion:NO
//                     kToken:_thirdTokenTextField.text customUserID:0];

    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    _liveViewController = [board instantiateViewControllerWithIdentifier:@"player"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}




#pragma mark - VodDownLoadDelegate
//添加item的回调方法
- (void)onAddItemResult:(RESULT_TYPE)resultType voditem:(downItem *)item
{
    if (resultType == RESULT_SUCCESS) {
        

//        vodId = item.strDownloadID;
        if (islivePlay) {
            [_liveViewController setItem:item];
            [_liveViewController setIsLivePlay:YES];
            [self.navigationController pushViewController:_liveViewController animated:YES];
        } else {
            [_downloadViewController setDomain:_domain.text];
            [_downloadViewController setNumber:_number.text];
            [_downloadViewController setVodPassword:_vodPassword.text];
            [_downloadViewController setSeviceType:_serviceType.text];
            
            [self.navigationController pushViewController:_downloadViewController animated:YES];
        }

//        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }else if (resultType == RESULT_ROOM_NUMBER_UNEXIST){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"点播间不存在" ,@"") delegate:nil cancelButtonTitle:NSLocalizedString(@"知道了",@"") otherButtonTitles:nil, nil];
        [alertView show];
    }else if (resultType == RESULT_FAILED_NET_REQUIRED){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"网络请求失败" ,@"") delegate:nil cancelButtonTitle:NSLocalizedString(@"知道了",@"") otherButtonTitles:nil, nil];
        [alertView show];
    }else if (resultType == RESULT_FAIL_LOGIN){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"用户名或密码错误" ,@"") delegate:nil cancelButtonTitle:NSLocalizedString(@"知道了",@"") otherButtonTitles:nil, nil];
        [alertView show];
    }else if (resultType == RESULT_NOT_EXSITE){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"该点播的编号的点播不存在" ,@"") delegate:nil cancelButtonTitle:NSLocalizedString(@"知道了",@"") otherButtonTitles:nil, nil];
        [alertView show];
    }else if (resultType == RESULT_INVALID_ADDRESS){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"无效地址" ,@"") delegate:nil cancelButtonTitle:NSLocalizedString(@"知道了",@"") otherButtonTitles:nil, nil];
        [alertView show];
    }else if (resultType == RESULT_UNSURPORT_MOBILE){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"不支持移动设备" ,@"") delegate:nil cancelButtonTitle:NSLocalizedString(@"知道了",@"") otherButtonTitles:nil, nil];
        [alertView show];
    }else if (resultType == RESULT_FAIL_TOKEN){
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"口令错误" ,@"") delegate:nil cancelButtonTitle:NSLocalizedString(@"知道了",@"") otherButtonTitles:nil, nil];
    [alertView show];
}
    [MBProgressHUD hideHUDForView:self.view animated:YES];
//    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

#pragma mark - UITextFieldDelgate
/**
 *处理键盘遮盖
 */
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 216.0);
    
    if(offset > 0) {
        NSTimeInterval animationDuration = 0.30f;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        
        //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    int offset = self.view.frame.origin.y;
    if (offset < 0) {
        NSTimeInterval animationDuration = 0.30f;
        [UIView beginAnimations:@"ResizeforKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        
        //将视图的Y坐标向下移动offset个单位，以使下面腾出地方用于软键盘的显示
        self.view.frame = CGRectMake(0.0f, 0.0, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
}

#pragma mark Actions
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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

@implementation UINavigationController (rotation)

- (BOOL)shouldAutorotate
{
    return NO;
}


@end
