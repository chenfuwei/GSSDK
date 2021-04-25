//
//  FastConfigViewController.m
//  FastDemo
//
//  Created by Sheng on 2017/8/17.
//  Copyright © 2017年 263. All rights reserved.
//

#import "FastConfigViewController.h"
#import <FASTSDK/FASTSDK.h>
#import <RtSDK/RtSDK.h>
#import "ViewController.h"
#import <PlayerSDK/PlayerSDK.h>
#import <GSCommonKit/GSCommonKit.h>
//#import <VodSDK/VodSDK.h>
//
//#import "PlayerViewController.h"

#define MO_NO_COLOR [UIColor blackColor]
#define MO_YES_COLOR [UIColor greenColor]

#define MO_DOMAIN @"FAST_CONFIG_DOMAIN"
#define MO_SERVICE @"FAST_CONFIG_SERVICE_TYPE"
#define MO_ROOMID @"FAST_CONFIG_ROOMID"
#define MO_NICKNAME @"FAST_CONFIG_NICKNAME"
#define MO_PWD @"FAST_CONFIG_PWD"
//#define MO_DOMAIN @"FAST_CONFIG_DOMAIN"
//#import "IQKeyboardManager.h"

@interface FastConfigViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *contentView;

#pragma mark - 参数

@property (weak, nonatomic) IBOutlet UIButton *watchBtn;
@property (weak, nonatomic) IBOutlet UITextField *domain;
//@property (weak, nonatomic) IBOutlet UITextField *serviceType;
    @property (weak, nonatomic) IBOutlet UISegmentedControl *serviceType;
    
    
@property (weak, nonatomic) IBOutlet UITextField *roomID;
@property (weak, nonatomic) IBOutlet UITextField *nickName;
@property (weak, nonatomic) IBOutlet UITextField *watchPassword;
@property (weak, nonatomic) IBOutlet UISegmentedControl *blackAndWhite;

#pragma mark - 模块

@property (nonatomic, assign) BOOL isHttps;

#pragma mark - 打赏数组

@property (weak, nonatomic) IBOutlet UITextField *num1;

@property (weak, nonatomic) IBOutlet UITextField *num2;
@property (weak, nonatomic) IBOutlet UITextField *num3;
@property (weak, nonatomic) IBOutlet UITextField *num4;
@property (weak, nonatomic) IBOutlet UITextField *num5;
@property (weak, nonatomic) IBOutlet UITextField *num6;

#pragma mark -

@property (nonatomic, strong) GSFastSDKConfig *config;

#pragma mark - vod
//@property (nonatomic, strong) GSWebAccess *gsWebAccess;

@end

@implementation FastConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.config = [GSFastSDKConfig sharedInstance];
    
    self.config.popupStyle = GSFastPopupMenuNetworkOptimization | GSFastPopupMenuFaultReport |GSFastPopupMenuOpenOrCloseVideo;
    self.config.surfaceStyle = GSFastLiveSurfaceButtonAllStyles;
    self.config.topStyle = GSFastTopBarAllStyles;
    self.config.moduleStyle = GSFastModuleAllStyles;
    self.config.themeStyle = GSFastThemeWhite;
    
    
    
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideAll)];
    tapGR.numberOfTapsRequired = 1;
    tapGR.numberOfTouchesRequired = 1;
    
    [_contentView addGestureRecognizer:tapGR];
    _contentView.contentSize = _contentView.bounds.size;
    [self setTagViews];
    
    // Do any additional setup after loading the view.
}

- (void)setTagViews {
    GSTagsContentView *tagContent = [[GSTagsContentView alloc] initWithFrame:CGRectMake(15, _blackAndWhite.bounds.size.height + _blackAndWhite.frame.origin.y + 15, self.view.bounds.size.width - 30, 40) tags:@[@"文档",@"聊天",@"问答",@"举手",@"弹幕",@"画中画",@"优选网络",@"视频开关",@"简介",@"HTTPS"] handler:^(NSInteger index, NSString *text,BOOL isSelect) {
        NSLog(@"选择 %d : %@ ,Select : %d",index,text,isSelect);
        switch (index) {
            case 0://文档
                self.config.moduleStyle = (self.config.moduleStyle)^(GSFastModuleDoc);
                break;
            case 1://聊天
                self.config.moduleStyle = (self.config.moduleStyle)^(GSFastModuleChat);
                break;
            case 2://问答
                self.config.moduleStyle = (self.config.moduleStyle)^(GSFastModuleQa);
                break;
            case 3://举手
                self.config.surfaceStyle = (self.config.surfaceStyle)^(GSFastLiveSurfaceButtonHandup);
                break;
            case 4://弹幕
                self.config.topStyle = (self.config.topStyle)^(GSFastTopBarBarrage);
                break;
            case 5://画中画
                self.config.isClosePIP = !isSelect;
                break;
            case 6://优选网络
                self.config.popupStyle = (self.config.popupStyle)^(GSFastPopupMenuNetworkOptimization);
                break;
            case 7://视频开关
                self.config.popupStyle = (self.config.popupStyle)^(GSFastPopupMenuOpenOrCloseVideo);
                break;
            case 8://简介
                self.config.moduleStyle = (self.config.moduleStyle)^(GSFastModuleIntroduction);
                break;
            case 9://HTTPS
                _isHttps = isSelect;
                break;
            default:
                break;
        }
        
        
    }];
    tagContent.selectOnload = YES;
    tagContent.allowSelect = YES;
    tagContent.supportMultiSelect = YES;
    [self.contentView addSubview:tagContent];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.watchBtn.userInteractionEnabled = YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)hideAll{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
//    [[IQKeyboardManager sharedManager] setEnable:NO];
}

#pragma mark - param



#pragma mark - module

- (BOOL)handleBtn:(id)sender{
    UIButton *btn = sender;
    btn.selected = !btn.selected;
    
    if (btn.selected) {
        btn.backgroundColor = MO_NO_COLOR;
    }else{
        btn.backgroundColor = MO_YES_COLOR;
    }
    
    return btn.selected;
}

- (IBAction)segementChange:(id)sender {
    
    UISegmentedControl *tmp = sender;
    
    if (tmp.selectedSegmentIndex == 0) {
        self.config.themeStyle = GSFastThemeWhite;
        
    }else{
        self.config.themeStyle = GSFastThemeBlack;
    }
    
}

#pragma mark - action

- (IBAction)publish:(id)sender {
    
//    [self presentViewController:[[ViewController alloc]init] animated:NO completion:nil];
    [self presentViewController:[[ViewController alloc]init] animated:NO completion:nil];

    
}


- (IBAction)watch:(id)sender {
    
    NSMutableArray *rewards = [NSMutableArray array];
    
    if (_num1.text.length > 0) {
        float n = [_num1.text floatValue] / 100;
        [rewards addObject:[NSString stringWithFormat:@"%.02f",n]];
    }
    
    if (_num2.text.length > 0) {
        float n = [_num2.text floatValue] / 100;
        [rewards addObject:[NSString stringWithFormat:@"%.02f",n]];
    }
    if (_num3.text.length > 0) {
        float n = [_num3.text floatValue] / 100;
        [rewards addObject:[NSString stringWithFormat:@"%.02f",n]];
    }
    if (_num4.text.length > 0) {
        float n = [_num4.text floatValue] / 100;
        [rewards addObject:[NSString stringWithFormat:@"%.02f",n]];
    }
    if (_num5.text.length > 0) {
        float n = [_num5.text floatValue] / 100;
        [rewards addObject:[NSString stringWithFormat:@"%.02f",n]];
    }
    if (_num6.text.length > 0) {
        float n = [_num6.text floatValue] / 100;
        [rewards addObject:[NSString stringWithFormat:@"%.02f",n]];
    }
    
    self.config.rewardArray = rewards;
    
    GSConnectInfo *connectInfo = [GSConnectInfo new];
    connectInfo.domain = self.domain.text;
    connectInfo.serviceType = self.serviceType.selectedSegmentIndex == 0?GSBroadcastServiceTypeWebcast:GSBroadcastServiceTypeTraining;
//    connectInfo.loginName = self.loginName;
//    connectInfo.loginPassword = self.loginPassword;
    connectInfo.roomNumber = self.roomID.text;
    connectInfo.nickName = self.nickName.text;
    connectInfo.watchPassword = self.watchPassword.text;
//    connectInfo.thirdToken = self.token;

    [self saveParams];
    
    if (_isHttps) {
        NSLog(@"ishttps : 1");
        [GSFastSDKConfig sharedInstance].isHttps = YES;
    }else{
        NSLog(@"ishttps : 0");
        [GSFastSDKConfig sharedInstance].isHttps = NO;
    }
    [GSPPlayerManager sharedManager].hardwareAccelerateEncode = YES;
//    [GSPPlayerManager sharedManager].hardwareAccelerateDecode = NO;
    
//    self.config.rewardArray = @[@"0.01",@"1.00",@"5.00",@"0.01",@"1.00",@"5.00"];

    GSCustomButtonRef *ref = [[GSCustomButtonRef alloc]init];
    ref.normalImage = [UIImage imageNamed:@"打赏"];
    ref.useGenseeStyle = YES;
    ref.title = @"测试按钮";
    ref.moreImage = [UIImage imageNamed:@"nav_status_wifi@2x.png"];
    [GSFastSDKConfig sharedInstance].customButtonRefs = @[ref,ref,ref];
    [GSFastSDKConfig sharedInstance].customButtonAction = ^(id sender, int index, UIControlEvents event) {
        NSLog(@"custom action : %d",index);
    };
    [[GSFastSDK sharedInstance] enterLive:connectInfo config:self.config animate:YES completion:nil];
    [[GSFastSDK sharedInstance] setLeaveCompletion:^{
        NSLog(@"leavce success");
    }];
    
    self.watchBtn.userInteractionEnabled = NO;
    self.watchBtn.backgroundColor = [UIColor grayColor];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.watchBtn.userInteractionEnabled = YES;
        self.watchBtn.backgroundColor = [UIColor yellowColor];
    });
    
}
- (IBAction)vodAction:(id)sender {

//    NSString *domain = @"zhixue.gensee.com";
//    NSString *nickname = @"Fast Demo";
//    NSString *watchPWD = @"941394";
//    NSString *number = @"83604390";
//    NSString *vodID = @"";
//    NSString *loginName = @"";
//    NSString *loginPWD = @"";
////    NSString *token = [dic objectForKey:@"Third-Part Token"];
//    BOOL isWebcast = NO;;
//    __weak typeof(self) weakSelf = self;
//
//    __block BOOL isfind = NO;
//
////    if ([[GSVodManager sharedInstance]findAllItems].count > 0) {//优先在本地找，如果本地没有验证过的信息，再进行网络请求
////        NSArray *array = [[GSVodManager sharedInstance]findAllItems];
////
////        [array enumerateObjectsUsingBlock:^(GSVodItem* _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
////            if (obj.hostID == number.longLongValue) {
////                PlayerViewController *playerController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"playerVC"];
////                playerController.vodItem = obj;
////                __strong typeof (weakSelf)strongSelf = weakSelf;
////                __weak typeof(playerController) weakPlayerVC = playerController;
////                playerController.dismissBlock = ^{
////                    //                        __strong typeof(weakPlayerVC) strongPlayerVC = weakPlayerVC;
////                    [weakPlayerVC dismissViewControllerAnimated:YES completion:nil];
////                };
////                [strongSelf showViewController:playerController sender:nil];
////                isfind = YES;
////                *stop = YES;
////            }
////        }];
////
////    }
//    if (!isfind) {
//        _gsWebAccess = [[GSWebAccess alloc]initWithSDKType:GSSDKTypeVod];
//        _gsWebAccess.httpsAPI = [GSFastSDKConfig sharedInstance].isHttps;
//        _gsWebAccess.completion = ^(GSWebAccessResult result) {
//            NSString *errorInfo = @"";
//            switch (result) {
//                case GSWebAccessResult_Success:{
//                    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"Gensee_Vod"];
//                    PlayerViewController *playerController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"playerVC"];
//                    playerController.vodItem = [[GSVodManager sharedInstance]findVodItem:[dic objectForKey:@"vodId"]];
//                    __strong typeof (weakSelf)strongSelf = weakSelf;
//                    __weak typeof(playerController) weakPlayerVC = playerController;
//                    playerController.dismissBlock = ^{
////                        __strong typeof(weakPlayerVC) strongPlayerVC = weakPlayerVC;
//                        [weakPlayerVC dismissViewControllerAnimated:YES completion:nil];
//                    };
//                    [strongSelf showViewController:playerController sender:nil];
//                }
//                    break;
//                case GSWebAccessResult_LoginFailed:
//                    errorInfo = [errorInfo stringByAppendingString:[NSString stringWithFormat:@"登录用户名或密码错误\n"]];
//                    break;
//                case GSWebAccessResult_NetworkError:
//                    errorInfo = [errorInfo stringByAppendingString:[NSString stringWithFormat:@"无法连接到服务器\n"]];
//                    break;
//                case GSWebAccessResult_PasswordError:
//                    errorInfo = [errorInfo stringByAppendingString:[NSString stringWithFormat:@"观看密码错误\n"]];
//                    break;
//                case GSWebAccessResult_ThirdTokenError:
//                    errorInfo = [errorInfo stringByAppendingString:[NSString stringWithFormat:@"第三方K值验证错误\n"]];
//                    break;
//                case GSWebAccessResult_RoleOrDomainError:
//                    errorInfo = @"角色或域名错误";
//                    break;
//                case GSWebAccessResult_WebcastID_Invalid:
//                    errorInfo = [errorInfo stringByAppendingString:[NSString stringWithFormat:@"webcastID不正确\n"]];
//                    break;
//                case GSWebAccessResult_UnknownError:
//                    errorInfo = [errorInfo stringByAppendingString:[NSString stringWithFormat:@"未知错误\n"]];
//                    break;
//                default:
//                    break;
//
//                    if (errorInfo && ![errorInfo isEqualToString:@""]) {
//                        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:errorInfo preferredStyle:UIAlertControllerStyleAlert];
//                        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction* action){
//                        }]];
//                        [self presentViewController:alertController animated:YES completion:nil];
//                    }
//            }
//        };
//        //优先使用vodID进行请求，不推荐使用number
//        if ([vodID isEqualToString:@""] || !vodID) {
//            [_gsWebAccess accessWithDomain:domain
//                            serviceType:isWebcast ? GSServiceTypeWebcast : GSServiceTypeTraining
//                                 number:number
//                               nickName:nickname
//                           joinPassword:watchPWD
//                              LoginName:loginName
//                          LoginPassword:loginPWD
//                             thirdToken:nil];
//        } else {
//            [_gsWebAccess accessWithDomain:domain
//                            serviceType:isWebcast ? GSServiceTypeWebcast : GSServiceTypeTraining
//                                     ID:vodID
//                               nickName:nickname
//                           joinPassword:watchPWD
//                              LoginName:loginName
//                          LoginPassword:loginPWD
//                             thirdToken:nil];
//        }
//    }
}


- (void)saveParams{
    
    if (self.domain.text.length > 0) {
        [[NSUserDefaults standardUserDefaults] setObject:self.domain.text forKey:MO_DOMAIN];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:self.serviceType.selectedSegmentIndex] forKey:MO_SERVICE];
    if (self.roomID.text.length > 0) {
        [[NSUserDefaults standardUserDefaults] setObject:self.roomID.text forKey:MO_ROOMID];
    }
    
    if (self.nickName.text.length > 0) {
        [[NSUserDefaults standardUserDefaults] setObject:self.nickName.text forKey:MO_NICKNAME];
    }
    
    if (self.watchPassword.text.length > 0) {
        [[NSUserDefaults standardUserDefaults] setObject:self.watchPassword.text forKey:MO_PWD];
    }
    
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
