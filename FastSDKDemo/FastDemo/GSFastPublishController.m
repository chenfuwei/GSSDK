//
//  GSFastPublishController.m
//  FastDemo
//
//  Created by Sheng on 2018/7/31.
//  Copyright © 2018年 263. All rights reserved.
//

#import "GSFastPublishController.h"
#import "UIView+SetRect.h"
#import "GSTextFieldTitleView.h"
#import <FASTSDK/FASTSDK.h>
#import <GSCommonKit/GSCommonKit.h>
#import <RtSDK/RtSDK.h>
#import "IQKeyboardManager.h"
#define FASTSDK_COLOR16(value) [UIColor colorWithRed:((float)((value & 0xFF0000) >> 16))/255.0 green:((float)((value & 0xFF00) >> 8))/255.0 blue:((float)(value & 0xFF))/255.0 alpha:1.0]

#define MO_DOMAIN @"FAST_CONFIG_DOMAIN"
#define MO_SERVICE @"FAST_CONFIG_SERVICE_TYPE"
#define MO_ROOMID @"FAST_CONFIG_ROOMID"
#define MO_NICKNAME @"FAST_CONFIG_NICKNAME"
#define MO_PWD @"FAST_CONFIG_PWD_P"
#define MO_LOGIN_NAME @"FAST_CONFIG_LOGIN_NAME"
#define MO_LOGIN_PWD @"FAST_CONFIG_LOGIN_PWD"
#define MO_THIRD_KEY @"FAST_CONFIG_THIRD_KEY"
#define MO_REWARD @"FAST_CONFIG_REWARD"
@interface GSFastPublishController ()

//UI
@property (nonatomic, strong) UIScrollView  *scrollView;
@property (nonatomic, strong) NSMutableDictionary  *fieldViewsDic;
//config
@property (strong, nonatomic) UISegmentedControl *serviceType;
@property (strong, nonatomic) UISegmentedControl *portraitType;
@property (strong, nonatomic) UISegmentedControl *encodeType;
@property (strong, nonatomic) UISegmentedControl *languageType;
@property (strong, nonatomic) UISegmentedControl *hdType;
@property (strong, nonatomic) UITextField *rewardField;
@end

@implementation GSFastPublishController
{
//    struct {
//        int isHttps : 1; //是否使用HTTPS
//    } _state;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    //UI
    self.title = @"FAST 发布端配置";
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _fieldViewsDic = [[NSMutableDictionary alloc]init];
    self.scrollView                     = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, Width, Height - 64 - 50)];
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:self.scrollView];
    CGFloat top = 10.f;
    int index = 0;
    
    UILabel *label = [self createTagLabel:@"直播参数设置" top:top];
    [self.scrollView addSubview:label];
    top = label.bottom + 5;
    
    UIView *whiteBGView  = [self createWhiteBGViewWithTop:top itemCount:7];
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
        fieldView.field.keyboardType = UIKeyboardTypeNumberPad;
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
    
    //segement
    {
        UILabel *label = [self createTagLabel:@"站点类型" top:top];
        [self.scrollView addSubview:label];
        
        UILabel *label1 = [self createTagLabel:@"横竖屏" top:top left:Width/2 + 15];
        [self.scrollView addSubview:label1];
        top = label1.bottom + 5;
        _serviceType = [[UISegmentedControl alloc] initWithItems:@[@"Webcast",@"Training"]];
        _serviceType.frame = CGRectMake(15, top, (Width - 60)/2, 28);
        //        _serviceType
        _serviceType.selectedSegmentIndex = 0;
//        [_serviceType addTarget:self action:@selector(segementChanged:) forControlEvents:UIControlEventValueChanged];
        [self.scrollView addSubview:_serviceType];
        
        _portraitType = [[UISegmentedControl alloc] initWithItems:@[@"竖屏",@"横屏"]];
        _portraitType.frame = CGRectMake(Width/2 + 15, top, (Width - 60)/2, 28);
        _portraitType.selectedSegmentIndex = 0;
//        [_portraitType addTarget:self action:@selector(segementChanged:) forControlEvents:UIControlEventValueChanged];
        [self.scrollView addSubview:_portraitType];
        
        
        top = _serviceType.bottom + 10;
        
        UILabel *label2 = [self createTagLabel:@"软硬编" top:top left:15];
        [self.scrollView addSubview:label2];
        
        UILabel *label3 = [self createTagLabel:@"标高清" top:top left:Width/2 + 15];
        [self.scrollView addSubview:label3];
        top = label3.bottom + 5;
        _encodeType = [[UISegmentedControl alloc] initWithItems:@[@"软编",@"硬编"]];
        _encodeType.frame = CGRectMake(15, top, (Width - 60)/2, 28);
        _encodeType.selectedSegmentIndex = 0;
        //        [_portraitType addTarget:self action:@selector(segementChanged:) forControlEvents:UIControlEventValueChanged];
        [self.scrollView addSubview:_encodeType];
        
        _hdType = [[UISegmentedControl alloc] initWithItems:@[@"标清",@"高清"]];
        _hdType.frame = CGRectMake(Width/2 + 15, top, (Width - 60)/2, 28);
        _hdType.selectedSegmentIndex = 0;
        //        [_portraitType addTarget:self action:@selector(segementChanged:) forControlEvents:UIControlEventValueChanged];
        [self.scrollView addSubview:_hdType];
        
        top = _hdType.bottom + 10;
        
        
        UILabel *label4 = [self createTagLabel:@"APP内语言切换" top:top left:15];
        [self.scrollView addSubview:label4];
        top = label4.bottom + 5;
        
        _languageType = [[UISegmentedControl alloc] initWithItems:@[@"简体中文",@"英文",@"繁体"]];
        _languageType.frame = CGRectMake(15, top, (Width - 60)/2, 28);
        _languageType.selectedSegmentIndex = 0;
        [self.scrollView addSubview:_languageType];
         top = _languageType.bottom + 10;
    }
    
    {
        //打赏数组设置
        UILabel *label = [self createTagLabel:@"打赏数组设置(6组数字并以\"/\"分割,范围0.01-2000)" top:top];
        [self.scrollView addSubview:label];
        top = label.bottom + 5;
        
        _rewardField = [[UITextField alloc] initWithFrame:CGRectMake(15, top, Width - 30, 30)];
        _rewardField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _rewardField.borderStyle = UITextBorderStyleLine;
        _rewardField.keyboardType = UIKeyboardTypeASCIICapable;
        [self.scrollView addSubview:_rewardField];
        
        top = _rewardField.bottom + 5;
    }
    
    //NSUserDefault
    [self loadCache];
    
    self.scrollView.contentSize = CGSizeMake(Width, top);
    
    {
        //按钮事件 - 发布
        UIButton *publish   = [[UIButton alloc] initWithFrame:CGRectMake(15.f, Height - 50.f + 5, Width/2 - 30.f, 40.f)];
        [publish setTitle:@"发布" forState:UIControlStateNormal];
        publish.layer.cornerRadius         = 3.f;
        publish.layer.borderColor          = FASTSDK_COLOR16(0x009BD8).CGColor;
        publish.layer.borderWidth          = 0.5f;
        publish.layer.masksToBounds        = YES;
        publish.backgroundColor = FASTSDK_COLOR16(0x009BD8);
        [publish addTarget:self action:@selector(publish) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:publish];
        //按钮事件 - 观看
        UIButton *watch   = [[UIButton alloc] initWithFrame:CGRectMake(Width/2 + 15.f, Height - 50.f + 5, Width/2 - 30.f, 40.f)];
        [watch setTitle:@"观看" forState:UIControlStateNormal];
        watch.layer.cornerRadius         = 3.f;
        watch.layer.borderColor          = FASTSDK_COLOR16(0x336699).CGColor;
        watch.layer.borderWidth          = 0.5f;
        watch.layer.masksToBounds        = YES;
        watch.backgroundColor = FASTSDK_COLOR16(0x336699);
        [watch addTarget:self action:@selector(goWatch) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:watch];
    }
}

- (void)goWatch {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)publish {
    [GSFastSDK sharedInstance].didUserCustomLanguage = ^{
        //请返回zh-Hans.lproj，zh-Hant.lproj等资源工程的前缀
        NSInteger languageSegment = self->_languageType.selectedSegmentIndex;
        if(languageSegment == 0)
        {
            return @"zh-Hans";
        }else if(languageSegment == 1)
        {
            return @"en";
        }else if(languageSegment == 2)
        {
            return @"zh-Hant";
        }
        return  @"zh-Hans";
    };
#if 1
    GSConnectInfo *connectInfo = [GSConnectInfo new];
    connectInfo.domain = [self _fieldText:MO_DOMAIN];
    connectInfo.serviceType = self.serviceType.selectedSegmentIndex == 0?GSBroadcastServiceTypeWebcast:GSBroadcastServiceTypeTraining;
    //XXX:如果需要配置登录密码和登录名，自行在代码中配置
    connectInfo.loginName = [self _fieldText:MO_LOGIN_NAME];
    connectInfo.loginPassword = [self _fieldText:MO_LOGIN_PWD];
    connectInfo.roomNumber = [self _fieldText:MO_ROOMID];
    connectInfo.nickName = [self _fieldText:MO_NICKNAME];
    connectInfo.watchPassword = [self _fieldText:MO_PWD];
    connectInfo.thirdToken = [self _fieldText:MO_THIRD_KEY];
    connectInfo.joinPermission = GSBroadcastPermissionOnlyOrgnizer;
    
    [self saveCache];
    
    GSFastSDKConfig *config = [GSFastSDKConfig new];
    config.isHardwareEncode = self.encodeType.selectedSegmentIndex == 1?YES:NO;
    config.isHD = self.hdType.selectedSegmentIndex == 1?YES:NO;
    config.isLandscape = self.portraitType.selectedSegmentIndex == 1?YES:NO;
    
    config.rewardArray = @[@"0.01",@"1.00",@"5.00",@"0.01",@"1.00",@"5.00"];
    if (_rewardField.text.length > 0) {
        NSArray *array = [_rewardField.text componentsSeparatedByString:@"/"];
        if (array.count == 6) {
            config.rewardArray = array;
        }
    }
//--------如果你想添加自定义按钮，参考下面代码👇----------
//    GSCustomButtonRef *ref = [[GSCustomButtonRef alloc]init];
//    ref.normalImage = [UIImage imageNamed:@"打赏"];
//    ref.useGenseeStyle = YES;
//    ref.title = @"测试按钮";
//    ref.moreImage = [UIImage imageNamed:@"nav_status_wifi@2x.png"];
//    [GSFastSDKConfig sharedInstance].customButtonRefs = @[ref,ref,ref];
//    [GSFastSDKConfig sharedInstance].customButtonAction = ^(id sender, int index, UIControlEvents event) {
//        NSLog(@"custom action : %d",index);
//    };
//-------------------------------------------------
    
    [[GSFastSDK sharedInstance] publishLive:connectInfo config:config ];  //默认标清
#else
    GSConnectInfo *connectInfo = [GSConnectInfo new];
    connectInfo.domain =  @"qa100.gensee.com";
    connectInfo.serviceType = 1;
    connectInfo.roomNumber = @"73202876";
    connectInfo.nickName = @"徐001";
//    connectInfo.customUserID = 39986451221;
    connectInfo.watchPassword = @"111111";
    
    GSFastSDKConfig *config = [GSFastSDKConfig sharedInstance];
    config.isHardwareEncode = NO;
    config.isHD = YES;
    config.isLandscape = NO;
    config.isOldVersion = YES;
    
    [[GSFastSDK sharedInstance] publishLive:connectInfo config:config];
#endif
   
}

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
    if (_rewardField.text.length > 0) {
        [[NSUserDefaults standardUserDefaults] setObject:_rewardField.text forKey:MO_REWARD];
    }
}

- (void)_saveField:(NSString *)fieldMark {
    NSString *text = [self _fieldText:fieldMark];
    if (text.length > 0) {
        [[NSUserDefaults standardUserDefaults] setObject:text forKey:fieldMark];
    }
}

- (NSString *)_fieldText:(NSString *)fieldMark {
    GSTextFieldTitleView *fieldView = [_fieldViewsDic objectForKey:fieldMark];
    return fieldView.field.text;
}

- (void)loadCache {
    if (![[NSUserDefaults standardUserDefaults] objectForKey:MO_DOMAIN]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:MO_DOMAIN];
    }else{
        GSTextFieldTitleView *fieldview = [_fieldViewsDic objectForKey:MO_DOMAIN];
        fieldview.field.text = [[NSUserDefaults standardUserDefaults] objectForKey:MO_DOMAIN];
    }
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:MO_SERVICE]) {
        [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:MO_SERVICE];
    }else{
        //        self.serviceType.selectedSegmentIndex = [[[NSUserDefaults standardUserDefaults] objectForKey:MO_SERVICE] intValue];
    }
    if (![[NSUserDefaults standardUserDefaults] objectForKey:MO_ROOMID]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:MO_ROOMID];
    }else{
        GSTextFieldTitleView *fieldview = [_fieldViewsDic objectForKey:MO_ROOMID];
        fieldview.field.text = [[NSUserDefaults standardUserDefaults] objectForKey:MO_ROOMID];
    }
    if (![[NSUserDefaults standardUserDefaults] objectForKey:MO_NICKNAME]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:MO_NICKNAME];
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
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:MO_REWARD]) {
        
        //do nothing
    }else{
        _rewardField.text = [[NSUserDefaults standardUserDefaults] objectForKey:MO_REWARD];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_fieldViewsDic removeAllObjects];
    NSLog(@"GSFastPublishController dealloc");
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


