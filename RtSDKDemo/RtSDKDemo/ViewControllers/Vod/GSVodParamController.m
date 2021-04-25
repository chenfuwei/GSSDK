//
//  GSVodParamController.m
//  VodSDKDemo
//
//  Created by Sheng on 2018/8/3.
//  Copyright © 2018年 Gensee. All rights reserved.
//

#import "GSVodParamController.h"
#import "GSTextFieldTitleView.h"
#import <GSCommonKit/GSCommonKit.h>

#import "IQKeyboardManager.h"
//#import "GSVodQueueController.h"
#define FASTSDK_COLOR16(value) [UIColor colorWithRed:((float)((value & 0xFF0000) >> 16))/255.0 green:((float)((value & 0xFF00) >> 8))/255.0 blue:((float)(value & 0xFF))/255.0 alpha:1.0]

#define MO_DOMAIN @"V_FAST_CONFIG_DOMAIN"
#define MO_SERVICE @"V_FAST_CONFIG_SERVICE_TYPE"
#define MO_ROOMID @"V_FAST_CONFIG_ROOMID"
#define MO_NICKNAME @"V_FAST_CONFIG_NICKNAME"
#define MO_PWD @"V_FAST_CONFIG_PWD"
#define MO_LOGIN_NAME @"V_FAST_CONFIG_LOGIN_NAME"
#define MO_LOGIN_PWD @"V_FAST_CONFIG_LOGIN_PWD"
#define MO_THIRD_KEY @"V_FAST_CONFIG_THIRD_KEY"
#define MO_REWARD @"V_FAST_CONFIG_REWARD"
#define MO_USERID @"V_FAST_CONFIG_USERID"

#import "GSVodPlayerController.h"
#import "GSVodDownloadController.h"

@interface GSVodParamController () <UITextFieldDelegate,VodDownLoadDelegate>
//UI
@property (nonatomic, strong) UIScrollView  *scrollView;
@property (nonatomic, strong) NSMutableDictionary  *fieldViewsDic;
//config
@property (strong, nonatomic) UISegmentedControl *serviceType;
@property (strong, nonatomic) UISegmentedControl *flvType;
@property (strong, nonatomic) UISegmentedControl *httpType;
@property (nonatomic, strong) VodDownLoader *voddownloader;

@end

@implementation GSVodParamController
{
    struct {
        unsigned int isOnline : 1;
    } _state;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!_voddownloader) {
        _voddownloader = [[VodDownLoader alloc]init];
    }
    _voddownloader.delegate = self;
    
    //UI
    self.title = @"VodSDK";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _fieldViewsDic = [[NSMutableDictionary alloc]init];
    self.scrollView                     = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, Width, Height - 64 - 50)];
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:self.scrollView];
    CGFloat top = 10.f;
    int index = 0;
    
    UILabel *label = [self createTagLabel:@"点播参数设置" top:top];
    [self.scrollView addSubview:label];
    top = label.bottom + 5;
    
    UIView *whiteBGView  = [self createWhiteBGViewWithTop:top itemCount:8];
    top = whiteBGView.bottom + 10;
    [self.scrollView addSubview:whiteBGView];
    {
        GSTextFieldTitleView *fieldView       = [[GSTextFieldTitleView alloc] initWithFrame:CGRectMake(0, index * 40.f, Width, 40.f)];
        fieldView.title                     = @"域名";
        fieldView.placeHolder               = @"请输入域名";
//        fieldView.field.delegate            = self;
        fieldView.field.clearButtonMode = UITextFieldViewModeAlways;
        [whiteBGView addSubview:fieldView];
        [_fieldViewsDic setObject:fieldView forKey:MO_DOMAIN];
        index ++;
    }
    {
        GSTextFieldTitleView *fieldView       = [[GSTextFieldTitleView alloc] initWithFrame:CGRectMake(0, index * 40.f, Width, 40.f)];
        fieldView.title                     = @"房间号";
        fieldView.placeHolder               = @"请输入房间号";
//        fieldView.field.delegate            = self;
        fieldView.field.clearButtonMode = UITextFieldViewModeAlways;
        fieldView.field.keyboardType = UIKeyboardTypeNumberPad;
        [whiteBGView addSubview:fieldView];
        [_fieldViewsDic setObject:fieldView forKey:MO_ROOMID];
        index ++;
    }
    {
        GSTextFieldTitleView *fieldView       = [[GSTextFieldTitleView alloc] initWithFrame:CGRectMake(0, index * 40.f, Width, 40.f)];
        fieldView.title                     = @"昵称";
        fieldView.placeHolder               = @"请输入昵称";
//        fieldView.field.delegate            = self;
        fieldView.field.clearButtonMode = UITextFieldViewModeAlways;
        [whiteBGView addSubview:fieldView];
        [_fieldViewsDic setObject:fieldView forKey:MO_NICKNAME];
        index ++;
    }
    {
        GSTextFieldTitleView *fieldView       = [[GSTextFieldTitleView alloc] initWithFrame:CGRectMake(0, index * 40.f, Width, 40.f)];
        fieldView.title                     = @"房间密码";
        fieldView.placeHolder               = @"请输入房间密码(可选)";
//        fieldView.field.delegate            = self;
        fieldView.field.clearButtonMode = UITextFieldViewModeAlways;
//        fieldView.field.keyboardType = UIKeyboardTypeNumberPad;
        [whiteBGView addSubview:fieldView];
        [_fieldViewsDic setObject:fieldView forKey:MO_PWD];
        index ++;
    }
    {
        GSTextFieldTitleView *fieldView       = [[GSTextFieldTitleView alloc] initWithFrame:CGRectMake(0, index * 40.f, Width, 40.f)];
        fieldView.title                     = @"登录用户名";
        fieldView.placeHolder               = @"请输入登录用户名(可选)";
//        fieldView.field.delegate            = self;
        fieldView.field.clearButtonMode = UITextFieldViewModeAlways;
        [whiteBGView addSubview:fieldView];
        [_fieldViewsDic setObject:fieldView forKey:MO_LOGIN_NAME];
        index ++;
    }
    {
        GSTextFieldTitleView *fieldView       = [[GSTextFieldTitleView alloc] initWithFrame:CGRectMake(0, index * 40.f, Width, 40.f)];
        fieldView.title                     = @"登录密码";
        fieldView.placeHolder               = @"请输入登录密码(可选)";
//        fieldView.field.delegate            = self;
        fieldView.field.clearButtonMode = UITextFieldViewModeAlways;
        [whiteBGView addSubview:fieldView];
        [_fieldViewsDic setObject:fieldView forKey:MO_LOGIN_PWD];
        index ++;
    }
    {
        GSTextFieldTitleView *fieldView       = [[GSTextFieldTitleView alloc] initWithFrame:CGRectMake(0, index * 40.f, Width, 40.f)];
        fieldView.title                     = @"第三方验证码";
        fieldView.placeHolder               = @"请输入验证码(可选)";
//        fieldView.field.delegate            = self;
        fieldView.field.clearButtonMode = UITextFieldViewModeAlways;
        [whiteBGView addSubview:fieldView];
        [_fieldViewsDic setObject:fieldView forKey:MO_THIRD_KEY];
        index ++;
    }
    {
        GSTextFieldTitleView *fieldView       = [[GSTextFieldTitleView alloc] initWithFrame:CGRectMake(0, index * 40.f, Width, 40.f)];
        fieldView.title                     = @"自定义用户ID";
        fieldView.placeHolder               = @"请输入ID(可选,且应大于十亿)";
//        fieldView.field.delegate            = self;
        fieldView.field.clearButtonMode = UITextFieldViewModeAlways;
        fieldView.field.keyboardType = UIKeyboardTypeNumberPad;
        [whiteBGView addSubview:fieldView];
        [_fieldViewsDic setObject:fieldView forKey:MO_USERID];
        index ++;
    }
    
    //segement
    {
        UILabel *label = [self createTagLabel:@"站点类型" top:top];
        [self.scrollView addSubview:label];
        
        UILabel *label1 = [self createTagLabel:@"FLV" top:top left:Width/2 + 15];
        [self.scrollView addSubview:label1];
        top = label.bottom + 5;
        //Webcast/Trainig
        _serviceType = [[UISegmentedControl alloc] initWithItems:@[@"Webcast",@"Training"]];
        _serviceType.frame = CGRectMake(15, top, (Width - 60)/2, 28);
        _serviceType.tag = 0;
        //        _serviceType
        _serviceType.selectedSegmentIndex = 0;
//        [_serviceType addTarget:self action:@selector(segementChanged:) forControlEvents:UIControlEventValueChanged];
        [self.scrollView addSubview:_serviceType];
        //Theme
        _flvType = [[UISegmentedControl alloc] initWithItems:@[@"否",@"是"]];
        _flvType.frame = CGRectMake(Width/2 + 15, top, (Width - 60)/2, 28);
        _flvType.selectedSegmentIndex = 0;
        _flvType.tag = 1;
//        [_flvType addTarget:self action:@selector(segementChanged:) forControlEvents:UIControlEventValueChanged];
        [self.scrollView addSubview:_flvType];
        
        top = _flvType.bottom + 10;
        
        UILabel *label2 = [self createTagLabel:@"HTTP/HTTPS" top:top];
        [self.scrollView addSubview:label2];
        top = label2.bottom + 5;
        //HTTP/HTTPS
        _httpType = [[UISegmentedControl alloc] initWithItems:@[@"HTTP",@"HTTPS"]];
        _httpType.frame = CGRectMake(15, top, (Width - 60)/2, 28);
        _httpType.tag = 2;
        _httpType.selectedSegmentIndex = 0;
//        [_httpType addTarget:self action:@selector(segementChanged:) forControlEvents:UIControlEventValueChanged];
        [self.scrollView addSubview:_httpType];
        top = _httpType.bottom + 10;
       
    }
    //NSUserDefault
    [self loadCache];
    
    self.scrollView.contentSize = CGSizeMake(Width, top);
    
    {
        //按钮事件 - 发布
        UIButton *download   = [[UIButton alloc] initWithFrame:CGRectMake(15.f, Height - 50.f + 5, (Width-60)/2, 40.f)];
        [download setTitle:@"下载" forState:UIControlStateNormal];
        download.layer.cornerRadius         = 3.f;
        download.layer.borderColor          = FASTSDK_COLOR16(0x336699).CGColor;
        download.layer.borderWidth          = 0.5f;
        download.layer.masksToBounds        = YES;
        download.backgroundColor = FASTSDK_COLOR16(0x336699);
        [download addTarget:self action:@selector(goDownload) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:download];
        
        //历史下载
//        UIButton *history   = [[UIButton alloc] initWithFrame:CGRectMake(20.f + (Width-40)/3, Height - 50.f + 5, (Width-40)/3, 40.f)];
//        [history setTitle:@"历史记录" forState:UIControlStateNormal];
//        history.layer.cornerRadius         = 3.f;
//        history.layer.borderColor          = FASTSDK_COLOR16(0x336699).CGColor;
//        history.layer.borderWidth          = 0.5f;
//        history.layer.masksToBounds        = YES;
//        history.backgroundColor = FASTSDK_COLOR16(0x336699);
//        [history addTarget:self action:@selector(goHistory) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:history];
        
        //按钮事件 - 观看
        UIButton *watch   = [[UIButton alloc] initWithFrame:CGRectMake(Width/2 + 15, Height - 50.f + 5, (Width-60)/2, 40.f)];
        [watch setTitle:@"在线观看" forState:UIControlStateNormal];
        watch.layer.cornerRadius         = 3.f;
        watch.layer.borderColor          = FASTSDK_COLOR16(0x009BD8).CGColor;
        watch.layer.borderWidth          = 0.5f;
        watch.layer.masksToBounds        = YES;
        watch.backgroundColor = FASTSDK_COLOR16(0x009BD8);
        [watch addTarget:self action:@selector(watch:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:watch];
    }
    
}


- (void)goDownload {
    //存储相关参数到NSUserDefault
    [self saveCache];
    //param
    GSConnectInfo *params = [GSConnectInfo new];
#if 1
    params.domain = [self _fieldText:MO_DOMAIN];
    params.roomNumber = [self _fieldText:MO_ROOMID];
    params.loginName = [self _fieldText:MO_LOGIN_NAME];
    params.watchPassword = [self _fieldText:MO_PWD];
    params.loginPassword = [self _fieldText:MO_LOGIN_PWD];
    params.nickName = [self _fieldText:MO_NICKNAME];
#else
    params.domain = @"misonedu.gensee.com";
    params.roomNumber = @"82066738";
    params.watchPassword = @"6543210";
    params.nickName = @"aaa";
#endif
    params.serviceType = self.serviceType.selectedSegmentIndex == 0?0:1;
    params.oldVersion = NO;
    params.thirdToken = [self _fieldText:MO_THIRD_KEY];
    if ([self _fieldText:MO_USERID].length > 0) {
        params.customUserID = [[self _fieldText:MO_USERID] longLongValue];
    }
    GSVodDownloadController *download = [[GSVodDownloadController alloc] init];
    download.item = params;
    [self.navigationController pushViewController:download animated:YES];
}

- (void)goHistory {}



- (void)watch:(UIButton*)sender {
    sender.userInteractionEnabled = NO;
    
    //存储相关参数到NSUserDefault
    [self saveCache];

    //param
    GSConnectInfo *params = [GSConnectInfo new];
#if 1
    params.domain = [self _fieldText:MO_DOMAIN];
    params.roomNumber = [self _fieldText:MO_ROOMID];
    params.loginName = [self _fieldText:MO_LOGIN_NAME];
    params.watchPassword = [self _fieldText:MO_PWD];
    params.loginPassword = [self _fieldText:MO_LOGIN_PWD];
    params.nickName = [self _fieldText:MO_NICKNAME];
    params.serviceType = self.serviceType.selectedSegmentIndex == 0?0:1;
    params.oldVersion =NO;
    params.thirdToken = [self _fieldText:MO_THIRD_KEY];
    if ([self _fieldText:MO_USERID].length > 0) {
        params.customUserID = [[self _fieldText:MO_USERID] longLongValue];
    }
    
#else
    
    params.domain = @"haixue.gensee.com";
//    params.number = @"91203565";
    params.webcastID = @"bea508f1e1394b68a38bc99b9eb42d83";
    params.watchPassword = @"977699";
    params.nickName = @"support";
    params.serviceType = self.serviceType.selectedSegmentIndex == 0?@"webcast":@"training";;
    
//    params.domain = @"hfs-yunxiao.gensee.com";
//    params.serviceType = self.serviceType.selectedSegmentIndex == 0?@"webcast":@"training";;
//    params.number = @"04016514";
////    params.vodID = @"d1ccac2863f344ccaff58c3a4af9e698";
//    params.nickName = @"Gensee";
//    params.vodPassword = @"";
//    params.thirdToken = @"4yJopNTdl7n%252F%252BN8b6UMf7hdpaMdQNv8grvpKntIeK9qLqOFI3J9u%252FNc1c8HT37DqRrADJ783xe5F3EVJrATGmDEUVcUlkCyC5kgqbI6%252Bij4Glt9rJHx3%252FfXntrb2d4kdS5qoxCxMTdWrrKijJoCJ3jTMK%252FkcRCSf97085ofJwtPE6XPXJp4F%252FkH0yqfuPLbe";
//    params.domain = @"eresearch.gensee.com";
//    params.vodID = @"07b517f42a7a4befa4e6e6d36e039d8f";
//    params.vodPassword = @"";
//    params.nickName = @"support";
//    params.serviceType = self.serviceType.selectedSegmentIndex == 0?@"webcast":@"training";;
    params.oldVersion = NO;
    if ([self _fieldText:MO_USERID].length > 0) {
        params.customUserID = [[self _fieldText:MO_USERID] longLongValue];
    }

#endif
    [[GSVodManager sharedInstance] setIsHttps:_httpType.selectedSegmentIndex == 0?YES:NO];
    self.voddownloader.httpAPIEnabled = _httpType.selectedSegmentIndex == 0?YES:NO;
    [GSVodManager sharedInstance].isFlv = _flvType.selectedSegmentIndex == 1?YES:NO;
    _state.isOnline = YES;
    [[GSVodManager sharedInstance] request:params download:NO completion:^(downItem *item, GSVodWebaccessError type) {
        NSString *msg;
        switch (type) {
            case GSVodWebaccessSuccess:
            {
                if (_state.isOnline) {
                    GSVodPlayerController *player = [[GSVodPlayerController alloc] init];
                    player.item = item;
                    player.isOnline = YES;
                    [self.navigationController pushViewController:player animated:YES];
                }
                return;
            }
                break;
            case GSVodWebaccessFailed:{
                msg = @"未知错误:2";
            }
                break;
            case GSVodWebaccessNumberError:{
                msg = @"房间号错误 或 站点类型设置错误";
            }
                break;
            case GSVodWebaccessWrongPassword:{
                msg = @"观看密码错误";
            }
                break;
            case GSVodWebaccessLoginFailed:{
                msg = @"登录账号密码错误";
            }
                break;
            case GSVodWebaccessVodIdError:{
                msg = @"VodID错误";
            }
                break;
            case GSVodWebaccessNoAccountOrPwd:{
                msg = @"账号为空 或 密码为空";
            }
                break;
            case GSVodWebaccessThirdKeyError:{
                msg = @"第三方验证码错误";
            }
                break;
            default:
                break;
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }];

    //设置间隔
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.userInteractionEnabled = YES;
    });
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view resignFirstResponder];
}

//data
#pragma mark - data
- (void)saveCache {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:self.serviceType.selectedSegmentIndex] forKey:MO_SERVICE];
    [self _saveField:MO_DOMAIN];
    [self _saveField:MO_ROOMID];
    [self _saveField:MO_NICKNAME];
    [self _saveField:MO_PWD];
    [self _saveField:MO_LOGIN_NAME];
    [self _saveField:MO_LOGIN_PWD];
    [self _saveField:MO_THIRD_KEY];
    [self _saveField:MO_USERID];

}

- (void)_saveField:(NSString *)fieldMark {
    NSString *text = [self _fieldText:fieldMark];
    if (text.length > 0) {
        [[NSUserDefaults standardUserDefaults] setObject:text forKey:fieldMark];
    }else{
        if ([[NSUserDefaults standardUserDefaults] objectForKey:fieldMark]) {
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:fieldMark];
        }
    }
}

- (NSString *)_fieldText:(NSString *)fieldMark {
    GSTextFieldTitleView *fieldView = [_fieldViewsDic objectForKey:fieldMark];
    return fieldView.field.text;
}

- (void)loadCache {
    if (![[NSUserDefaults standardUserDefaults] objectForKey:MO_DOMAIN]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"qa100.gensee.com" forKey:MO_DOMAIN];
    }else{
        GSTextFieldTitleView *fieldview = [_fieldViewsDic objectForKey:MO_DOMAIN];
        fieldview.field.text = [[NSUserDefaults standardUserDefaults] objectForKey:MO_DOMAIN];
    }
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:MO_SERVICE]) {
        [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:MO_SERVICE];
    }else{
       self.serviceType.selectedSegmentIndex = [[[NSUserDefaults standardUserDefaults] objectForKey:MO_SERVICE] intValue];
    }
    if (![[NSUserDefaults standardUserDefaults] objectForKey:MO_ROOMID]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"14949860" forKey:MO_ROOMID];
    }else{
        GSTextFieldTitleView *fieldview = [_fieldViewsDic objectForKey:MO_ROOMID];
        fieldview.field.text = [[NSUserDefaults standardUserDefaults] objectForKey:MO_ROOMID];
    }
    if (![[NSUserDefaults standardUserDefaults] objectForKey:MO_NICKNAME]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"genseeTest" forKey:MO_NICKNAME];
    }else{
        GSTextFieldTitleView *fieldview = [_fieldViewsDic objectForKey:MO_NICKNAME];
        fieldview.field.text = [[NSUserDefaults standardUserDefaults] objectForKey:MO_NICKNAME];
    }
    if (![[NSUserDefaults standardUserDefaults] objectForKey:MO_PWD]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:MO_PWD];
    }else{
        GSTextFieldTitleView *fieldview = [_fieldViewsDic objectForKey:MO_PWD];
        fieldview.field.text = [[NSUserDefaults standardUserDefaults] objectForKey:MO_PWD];
    }
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:MO_LOGIN_NAME]) {
        //do nothing
    }else{
        GSTextFieldTitleView *fieldview = [_fieldViewsDic objectForKey:MO_LOGIN_NAME];
        fieldview.field.text = [[NSUserDefaults standardUserDefaults] objectForKey:MO_LOGIN_NAME];
    }
    if (![[NSUserDefaults standardUserDefaults] objectForKey:MO_LOGIN_PWD]) {
        //do nothing
    }else{
        GSTextFieldTitleView *fieldview = [_fieldViewsDic objectForKey:MO_LOGIN_PWD];
        fieldview.field.text = [[NSUserDefaults standardUserDefaults] objectForKey:MO_LOGIN_PWD];
    }
    if (![[NSUserDefaults standardUserDefaults] objectForKey:MO_THIRD_KEY]) {
        //do nothing
    }else{
        GSTextFieldTitleView *fieldview = [_fieldViewsDic objectForKey:MO_THIRD_KEY];
        fieldview.field.text = [[NSUserDefaults standardUserDefaults] objectForKey:MO_THIRD_KEY];
    }
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:MO_USERID]) {
        //do nothing
    }else{
        GSTextFieldTitleView *fieldview = [_fieldViewsDic objectForKey:MO_USERID];
        fieldview.field.text = [[NSUserDefaults standardUserDefaults] objectForKey:MO_USERID];
    }
    
}

- (void)dealloc {
    [_fieldViewsDic removeAllObjects];
    NSLog(@"GSFastConfigController dealloc");
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
