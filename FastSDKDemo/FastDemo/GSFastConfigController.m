//  GSFastConfigController.m
//  FastDemo
//  Created by Sheng on 2018/7/31.
//  Copyright © 2018年 263. All rights reserved.

#import "GSFastConfigController.h"
#import "GSTextFieldTitleView.h"
#import <FASTSDK/FASTSDK.h>
#import <GSCommonKit/GSCommonKit.h>
#import <PlayerSDK/PlayerSDK.h>
#import "GSFastPublishController.h"
#import "IQKeyboardManager.h"
#import "GSFastVodController.h"
#import <Masonry/Masonry.h>
#define FASTSDK_COLOR16(value) [UIColor colorWithRed:((float)((value & 0xFF0000) >> 16))/255.0 green:((float)((value & 0xFF00) >> 8))/255.0 blue:((float)(value & 0xFF))/255.0 alpha:1.0]

#define MO_DOMAIN @"FAST_CONFIG_DOMAIN"
#define MO_SERVICE @"FAST_CONFIG_SERVICE_TYPE"
#define MO_ROOMID @"FAST_CONFIG_ROOMID"
#define MO_NICKNAME @"FAST_CONFIG_NICKNAME"
#define MO_PWD @"FAST_CONFIG_PWD"
#define MO_LOGIN_NAME @"FAST_CONFIG_LOGIN_NAME"
#define MO_LOGIN_PWD @"FAST_CONFIG_LOGIN_PWD"
#define MO_THIRD_KEY @"FAST_CONFIG_THIRD_KEY"
#define MO_REWARD @"FAST_CONFIG_REWARD"
#define MO_USERID @"FAST_CONFIG_USERID"
#define MO_GROUPID @"FAST_CONFIG_GROUPID"
#define MO_MARQUEE_CONTENT @"FAST_CONFIG_MZARQUEE_CONTENT"
#define MO_MARQUEE_SIZE @"FAST_CONFIG_MZARQUEE_SIZE"

@interface GSFastConfigController ()<GSFastPlayerSDKDelegate>
//UI
@property (nonatomic, strong) UIScrollView  *scrollView;
@property (nonatomic, strong) NSMutableDictionary  *fieldViewsDic;
//config
@property (nonatomic, strong) GSFastSDKConfig *config;
@property (strong, nonatomic) UISegmentedControl *serviceType;
@property (strong, nonatomic) UISegmentedControl *themeType;
@property (strong, nonatomic) UISegmentedControl *httpType;
@property (strong, nonatomic) UISegmentedControl *watchType;
@property (strong, nonatomic) UISegmentedControl *languageType;
@property (strong, nonatomic) UISegmentedControl *decodeType;
@property (strong, nonatomic) UISegmentedControl *marqueeSpeed;
@property (strong, nonatomic) UISegmentedControl *marqueeColor;
@property (strong, nonatomic) UITextField *rewardField;
@property (strong, nonatomic)UIViewController *viewController;
@end

@implementation GSFastConfigController
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
    //config
//    _state.isHttps = 1; //默认为1
    self.config = [GSFastSDKConfig sharedInstance];
    self.config.popupStyle = GSFastPopupMenuNetworkOptimization | GSFastPopupMenuFaultReport |GSFastPopupMenuOpenOrCloseVideo;
    self.config.surfaceStyle = GSFastLiveSurfaceButtonAllStyles;
    self.config.topStyle = GSFastTopBarAllStyles;
    self.config.moduleStyle = GSFastModuleAllStyles;
    self.config.themeStyle = GSFastThemeWhite;
    
    //UI
    self.title = @"FAST 观看端配置";
    self.automaticallyAdjustsScrollViewInsets = NO;
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
    
    UIView *whiteBGView  = [self createWhiteBGViewWithTop:top itemCount:9];
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
    {
        GSTextFieldTitleView *fieldView       = [[GSTextFieldTitleView alloc] initWithFrame:CGRectMake(0, index * 40.f, Width, 40.f)];
        fieldView.title                     = @"课堂分组ID";
        fieldView.placeHolder               = @"请输入课堂分组ID)";
        //        fieldView.field.delegate            = self;
        fieldView.field.clearButtonMode = UITextFieldViewModeAlways;
        [whiteBGView addSubview:fieldView];
        [_fieldViewsDic setObject:fieldView forKey:MO_GROUPID];
        index ++;
    }
    //segement
    {
        UILabel *label = [self createTagLabel:@"站点类型" top:top];
        [self.scrollView addSubview:label];
        
        UILabel *label1 = [self createTagLabel:@"皮肤" top:top left:Width/2 + 15];
        [self.scrollView addSubview:label1];
        top = label.bottom + 5;
        //Webcast/Trainig
        _serviceType = [[UISegmentedControl alloc] initWithItems:@[@"Webcast",@"Training"]];
        _serviceType.frame = CGRectMake(15, top, (Width - 60)/2, 28);
        _serviceType.tag = 0;
//        _serviceType
        _serviceType.selectedSegmentIndex = 0;
        [_serviceType addTarget:self action:@selector(segementChanged:) forControlEvents:UIControlEventValueChanged];
        [self.scrollView addSubview:_serviceType];
        //Theme
        _themeType = [[UISegmentedControl alloc] initWithItems:@[@"白色主题",@"黑色主题"]];
        _themeType.frame = CGRectMake(Width/2 + 15, top, (Width - 60)/2, 28);
        _themeType.selectedSegmentIndex = 0;
        _themeType.tag = 1;
        [_themeType addTarget:self action:@selector(segementChanged:) forControlEvents:UIControlEventValueChanged];
        [self.scrollView addSubview:_themeType];
        
        top = _themeType.bottom + 10;
        
        UILabel *label2 = [self createTagLabel:@"HTTP/HTTPS" top:top];
        [self.scrollView addSubview:label2];
        
        UILabel *label3 = [self createTagLabel:@"新老版本界面" top:top left:Width/2 + 15];
        [self.scrollView addSubview:label3];
        top = label2.bottom + 5;
        //HTTP/HTTPS
        _httpType = [[UISegmentedControl alloc] initWithItems:@[@"HTTP",@"HTTPS"]];
        _httpType.frame = CGRectMake(15, top, (Width - 60)/2, 28);
        _httpType.tag = 2;
        _httpType.selectedSegmentIndex = 0;
        [_httpType addTarget:self action:@selector(segementChanged:) forControlEvents:UIControlEventValueChanged];
        [self.scrollView addSubview:_httpType];
        
        //oldversion
        _watchType = [[UISegmentedControl alloc] initWithItems:@[@"分屏模式",@"竖屏模式"]];
        _watchType.frame = CGRectMake(Width/2 + 15, top, (Width - 60)/2, 28);
        _watchType.selectedSegmentIndex = 0;
        _watchType.tag = 3;
        [_watchType addTarget:self action:@selector(segementChanged:) forControlEvents:UIControlEventValueChanged];
        [self.scrollView addSubview:_watchType];
        top = _watchType.bottom + 10;
        
        UILabel *label4 = [self createTagLabel:@"硬解/软解" top:top];
        [self.scrollView addSubview:label4];
        UILabel *label5 = [self createTagLabel:@"APP内语言切换" top:top left:Width/2 + 15];
        [self.scrollView addSubview:label5];
        top = label4.bottom + 5;
        
        //解码模式
        _decodeType = [[UISegmentedControl alloc] initWithItems:@[@"软解",@"硬解"]];
        _decodeType.frame = CGRectMake(15, top, (Width - 60)/2, 28);
        _decodeType.tag = 4;
        _decodeType.selectedSegmentIndex = 0;
        [_decodeType addTarget:self action:@selector(segementChanged:) forControlEvents:UIControlEventValueChanged];
        [self.scrollView addSubview:_decodeType];


        //oldversion
        _languageType = [[UISegmentedControl alloc] initWithItems:@[@"简体中文",@"英文",@"繁体"]];
        _languageType.frame = CGRectMake(Width/2 + 15, top, (Width - 60)/2, 28);
        _languageType.selectedSegmentIndex = 0;
        _languageType.tag = 5;
        [_languageType addTarget:self action:@selector(segementChanged:) forControlEvents:UIControlEventValueChanged];
        [self.scrollView addSubview:_languageType];
        top = _languageType.bottom + 10;
    }
    //tagviews
    {
        UILabel *label = [self createTagLabel:@"模块配置" top:top];
        [self.scrollView addSubview:label];

        top = label.bottom + 5;
        GSTagsContentView *tagContent = [[GSTagsContentView alloc] initWithFrame:CGRectMake(15, top , self.view.bounds.size.width - 30, 40) tags:@[@"文档",@"聊天",@"问答",@"举手",@"弹幕",@"画中画",@"优选网络",@"视频开关",@"简介"] handler:^(NSInteger index, NSString *text,BOOL isSelect) {
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

                default:
                    break;
            }
        }];
        tagContent.defaultSelected = YES;
        tagContent.allowSelect = YES;
        tagContent.supportMultiSelect = YES;
        [self.scrollView addSubview:tagContent];
        top = tagContent.bottom + 10;
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
    
        {
            UILabel *labelMarquee = [self createTagLabel:@"跑马灯参数设置" top:top];
            [self.scrollView addSubview:labelMarquee];
            top = labelMarquee.bottom + 10;
            
            UILabel *label = [self createTagLabel:@"跑马灯速度" top:top];
            [self.scrollView addSubview:label];
            
            UILabel *label1 = [self createTagLabel:@"跑马灯颜色" top:top left:Width/2 + 15];
            [self.scrollView addSubview:label1];
            top = label.bottom + 5;

            _marqueeSpeed = [[UISegmentedControl alloc] initWithItems:@[@"1x",@"2x",@"3x",@"4x",@"5x"]];
            _marqueeSpeed.frame = CGRectMake(15, top, (Width - 60)/2, 28);
            _marqueeSpeed.tag = 1000;
    //        _serviceType
            _marqueeSpeed.selectedSegmentIndex = 0;
            [_marqueeSpeed addTarget:self action:@selector(segementChanged:) forControlEvents:UIControlEventValueChanged];
            [self.scrollView addSubview:_marqueeSpeed];
            //Theme
            _marqueeColor = [[UISegmentedControl alloc] initWithItems:@[@"红色",@"绿色"]];
            _marqueeColor.frame = CGRectMake(Width/2 + 15, top, (Width - 60)/2, 28);
            _marqueeColor.selectedSegmentIndex = 0;
            _marqueeColor.tag = 1001;
            [_marqueeColor addTarget:self action:@selector(segementChanged:) forControlEvents:UIControlEventValueChanged];
            [self.scrollView addSubview:_marqueeColor];
            
            top = _marqueeColor.bottom + 10;
            
            UIView *whiteBGView  = [self createWhiteBGViewWithTop:top itemCount:2];
            [self.scrollView addSubview:whiteBGView];
            int index = 0;
            top = whiteBGView.bottom + 10;
            {
                GSTextFieldTitleView *fieldView       = [[GSTextFieldTitleView alloc] initWithFrame:CGRectMake(0, index*40.0f, Width, 40.f)];
                fieldView.title                     = @"跑马灯内容";
                fieldView.placeHolder               = @"请输入跑马灯内容";
                fieldView.field.clearButtonMode = UITextFieldViewModeAlways;
                [whiteBGView addSubview:fieldView];
                [_fieldViewsDic setObject:fieldView forKey:MO_MARQUEE_CONTENT];
                index ++;
            }
            {
                GSTextFieldTitleView *fieldView       = [[GSTextFieldTitleView alloc] initWithFrame:CGRectMake(0, index*40.0f, Width, 40.f)];
                fieldView.title                     = @"跑马灯字体大小";
                fieldView.placeHolder               = @"请输入跑马灯字体大小";
                fieldView.field.clearButtonMode = UITextFieldViewModeAlways;
                fieldView.field.keyboardType = UIKeyboardTypeNumberPad;
                [whiteBGView addSubview:fieldView];
                [_fieldViewsDic setObject:fieldView forKey:MO_MARQUEE_SIZE];
                index ++;
            }
        }

    //NSUserDefault
    [self loadCache];
    
    self.scrollView.contentSize = CGSizeMake(Width, top);
    CGFloat width=(Width-40)/3;
    {
        //按钮事件 - 发布
        UIButton *publish   = [[UIButton alloc] initWithFrame:CGRectMake(10.f, Height - 50.f + 5,width , 40.f)];
        [publish setTitle:@"发布" forState:UIControlStateNormal];
        publish.layer.cornerRadius         = 3.f;
        publish.layer.borderColor          = FASTSDK_COLOR16(0x336699).CGColor;
        publish.layer.borderWidth          = 0.5f;
        publish.layer.masksToBounds        = YES;
        publish.backgroundColor = FASTSDK_COLOR16(0x336699);
        [publish addTarget:self action:@selector(goPublish) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:publish];
        
        
        //按钮事件 - 观看
        UIButton *watch   = [[UIButton alloc] initWithFrame:CGRectMake(publish.right+10, Height - 50.f + 5, width, 40.f)];
        [watch setTitle:@"观看" forState:UIControlStateNormal];
        watch.layer.cornerRadius         = 3.f;
        watch.layer.borderColor          = FASTSDK_COLOR16(0x009BD8).CGColor;
        watch.layer.borderWidth          = 0.5f;
        watch.layer.masksToBounds        = YES;
        watch.backgroundColor = FASTSDK_COLOR16(0x009BD8);
        [watch addTarget:self action:@selector(watch:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:watch];
        
        //按钮事件 -点播
        UIButton *vod= [[UIButton alloc] initWithFrame:CGRectMake(watch.right+10, Height - 50.f + 5, width, 40.f)];
        [vod setTitle:@"点播" forState:UIControlStateNormal];
        vod.layer.cornerRadius         = 3.f;
        vod.layer.borderColor          = FASTSDK_COLOR16(0x009BD8).CGColor;
        vod.layer.borderWidth          = 0.5f;
        vod.layer.masksToBounds        = YES;
        vod.backgroundColor = FASTSDK_COLOR16(0x009BD8);
        [vod addTarget:self action:@selector(vod:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:vod];
    }
    
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusChanged:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)segementChanged:(UISegmentedControl*)sender {
    if (sender.tag == 1) { //theme
        if (sender.selectedSegmentIndex == 0) {
            self.config.themeStyle = GSFastThemeWhite;
        }else{
            self.config.themeStyle = GSFastThemeBlack;
        }
    }else if (sender.tag == 2) {
        if (sender.selectedSegmentIndex == 0) {
            self.config.isHttps = 0;
        }else{
            self.config.isHttps = 1;
        }
    }
}



/**
 发布
 */
- (void)goPublish {
    [self.navigationController pushViewController:[[GSFastPublishController alloc] init] animated:YES];
}


/**
 点播
 */
- (void)vod:(UIButton*)sender{
    GSFastVodController *vod=[[GSFastVodController alloc] init];
    vod.title=@"FAST点播配置";
    [self.navigationController pushViewController:vod animated:YES];
}


/**
  观看
 */
- (void)watch:(UIButton*)sender {
    sender.userInteractionEnabled = NO;
//    NSMutableArray *arra = [[NSMutableArray alloc] init];
//    [arra insertObject:@"44" atIndex:100];
    GSConnectInfo *connectInfo = [GSConnectInfo new];
#if 1
    connectInfo.domain = [self _fieldText:MO_DOMAIN];
    connectInfo.serviceType = self.serviceType.selectedSegmentIndex == 0?GSBroadcastServiceTypeWebcast:GSBroadcastServiceTypeTraining;
    connectInfo.loginName = [self _fieldText:MO_LOGIN_NAME];
    connectInfo.loginPassword = [self _fieldText:MO_LOGIN_PWD];
    connectInfo.roomNumber = [self _fieldText:MO_ROOMID];
    connectInfo.nickName = [self _fieldText:MO_NICKNAME];
    connectInfo.watchPassword = [self _fieldText:MO_PWD];
    connectInfo.thirdToken = [self _fieldText:MO_THIRD_KEY];
#else
    //    params.domain = @"213.gensee.com";
    //    params.serviceType = self.serviceType.selectedSegmentIndex == 0?@"webcast":@"training";;
    //    //    info.number = @"10142713";
    //    params.vodID = @"X4oGLhvvoS";
    //    params.nickName = @"Gensee";
    //    params.vodPassword = @"444444";
    //    bocstudy1.gensee.com/webcast/site/vod/play-5fc0e7df883b40b69b651e62a7f549df
    connectInfo.domain = @"bocstudy1.gensee.com";
//    connectInfo.roomNumber = @"44356556";
    connectInfo.webcastID = @"21b3f330c8b34c17b21519876b551e45";
    connectInfo.watchPassword = @"";
    connectInfo.nickName = @"support";
    connectInfo.serviceType = self.serviceType.selectedSegmentIndex == 0?GSBroadcastServiceTypeWebcast:GSBroadcastServiceTypeTraining;
    connectInfo.oldVersion = NO;
//    connectInfo.thirdToken = @"1575364097bd7c54f27be33d895f8d41";
#endif
    if ([self _fieldText:MO_USERID].length > 0) {
        connectInfo.customUserID = [[self _fieldText:MO_USERID] longLongValue];
    }
    
    if([self _fieldText:MO_GROUPID].length > 0)
    {
        connectInfo.groupCode = [self _fieldText:MO_GROUPID];
    }
    //存储相关参数到NSUserDefault
    [self saveCache];
    //采用硬编码
    [GSPPlayerManager sharedManager].hardwareAccelerateEncode = YES;
    [GSPPlayerManager sharedManager].hardwareAccelerateDecode = _decodeType.selectedSegmentIndex != 0;
    
    //TODO:设置打赏数组 如有需要
    if (_rewardField.text.length > 0) {
        NSArray *array = [_rewardField.text componentsSeparatedByString:@"/"];
        if (array.count == 6) {
            self.config.rewardArray = array;
        }
    }
    //老版观看端为竖屏 新版为分屏
    self.config.isOldVersion =_watchType.selectedSegmentIndex == 1?YES:NO;

    
        GSCustomButtonRef *ref = [[GSCustomButtonRef alloc]init];
        ref.normalImage = [UIImage imageNamed:@"打赏"];
        ref.useGenseeStyle = YES;
        ref.title = @"测试按钮";
        ref.moreImage = [UIImage imageNamed:@"nav_status_wifi@2x.png"];
    ref.sortIndex = 2;
    
    GSCustomButtonRef *ref1 = [[GSCustomButtonRef alloc]init];
    ref1.normalImage = [UIImage imageNamed:@"打赏"];
    ref1.useGenseeStyle = YES;
    ref1.title = @"测试按钮1";
    ref1.moreImage = [UIImage imageNamed:@"nav_status_wifi@2x.png"];
    ref1.sortIndex = 1;
    
    GSCustomButtonRef *ref2 = [[GSCustomButtonRef alloc]init];
    ref2.normalImage = [UIImage imageNamed:@"打赏"];
    ref2.useGenseeStyle = YES;
    ref2.title = @"测试按钮2";
    ref2.moreImage = [UIImage imageNamed:@"nav_status_wifi@2x.png"];
    ref2.sortIndex = 0;
    
        [GSFastSDKConfig sharedInstance].customButtonRefs = @[ref,ref1,ref2];
        [GSFastSDKConfig sharedInstance].customButtonAction = ^(id sender, int index, UIControlEvents event) {
            NSLog(@"custom action : %d",index);
        };
    
    GSFastSDK *sdk = [GSFastSDK sharedInstance];
    sdk.didleave = ^(int value) {
        self.viewController = nil;
    };
    sdk.fastPlayerSDKDelegate = self;//设置直播播放代理，用户可根据此代理中的方法做些个性化需求
    sdk.didUserCustomLanguage = ^{
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
    
    //跑马灯参数配置
    [self configMarquee];

    // [1] 进入方式 - 调用进入
//    [[GSFastSDK sharedInstance] enterLive:connectInfo config:self.config animate:YES completion:^{
//        NSLog(@"[test] enter");
//    }];
//    // [2] 进入方式 - 获取ViewController,用于对viewController额外的操作
    UIViewController *fastVC = [[GSFastSDK sharedInstance] watchViewControllerBy:connectInfo configuration:self.config];
    self.viewController = fastVC;

    [self presentViewController:fastVC animated:YES completion:^{
        NSLog(@"[test] enter");
    }];
    //设置退出直播后的操作
//    [[GSFastSDK sharedInstance] setLeaveCompletion:^{
//        NSLog(@"[test] leavce success");
//    }];
    
    //设置间隔
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.userInteractionEnabled = YES;
    });
}

- (void)statusChanged:(NSNotification *)noti {
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
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
    [self _saveField:MO_GROUPID];
    [self _saveField:MO_MARQUEE_CONTENT];
    [self _saveField:MO_MARQUEE_SIZE];
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
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:MO_USERID]) {
        //do nothing
    }else{
        GSTextFieldTitleView *fieldview = [_fieldViewsDic objectForKey:MO_USERID];
        fieldview.field.text = [[NSUserDefaults standardUserDefaults] objectForKey:MO_USERID];
    }
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:MO_GROUPID]) {
        //do nothing
    }else{
        GSTextFieldTitleView *fieldview = [_fieldViewsDic objectForKey:MO_GROUPID];
        fieldview.field.text = [[NSUserDefaults standardUserDefaults] objectForKey:MO_GROUPID];
    }
    
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:MO_REWARD]) {
        //do nothing
    }else{
        _rewardField.text = [[NSUserDefaults standardUserDefaults] objectForKey:MO_REWARD];
    }
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:MO_MARQUEE_CONTENT]) {
        //do nothing
    }else{
        GSTextFieldTitleView *fieldview = [_fieldViewsDic objectForKey:MO_MARQUEE_CONTENT];
        fieldview.field.text = [[NSUserDefaults standardUserDefaults] objectForKey:MO_MARQUEE_CONTENT];
    }
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:MO_MARQUEE_SIZE]) {
        //do nothing
    }else{
        GSTextFieldTitleView *fieldview = [_fieldViewsDic objectForKey:MO_MARQUEE_SIZE];
        fieldview.field.text = [[NSUserDefaults standardUserDefaults] objectForKey:MO_MARQUEE_SIZE];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_fieldViewsDic removeAllObjects];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"GSFastConfigController dealloc");
}

//第三方回调
- (void)playerManager:(GSPPlayerManager *)playerManager onThirdVoteUrl:(NSString *)urlStr
{
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"第三方投票" message:urlStr preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *sureBtn = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull   action) {
        NSLog(@"确定");
    }];

    [alertVc addAction :sureBtn];
    //展示
    [self.viewController presentViewController:alertVc animated:YES completion:nil];
}

-(void)configMarquee
{
    GSMarquee *marquee = [[GSMarquee alloc] init];
    marquee.content = [self _fieldText:MO_MARQUEE_CONTENT];
    marquee.fontSize = [[self _fieldText:MO_MARQUEE_SIZE] floatValue];
    marquee.speed = GSMarqueeSpeed_1;
    marquee.fontColor = [UIColor redColor];
    NSInteger speedSelect = _marqueeSpeed.selectedSegmentIndex;
    if(speedSelect == 0)
    {
        marquee.speed = GSMarqueeSpeed_1;
    }else if(speedSelect == 1)
    {
        marquee.speed = GSMarqueeSpeed_2;
    }else if(speedSelect == 2)
    {
        marquee.speed = GSMarqueeSpeed_3;
    }else if(speedSelect == 3)
    {
        marquee.speed = GSMarqueeSpeed_4;
    }else if(speedSelect == 4)
    {
        marquee.speed = GSMarqueeSpeed_5;
    }
    NSInteger colorSelect = _marqueeColor.selectedSegmentIndex;
    if(colorSelect == 0)
    {
        marquee.fontColor = [UIColor redColor];
    }else if(colorSelect == 1)
    {
        marquee.fontColor = [UIColor greenColor];
    }
    self.config.marquee = marquee;
}


@end


