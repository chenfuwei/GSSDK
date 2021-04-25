//
//  GSVodPlayerController.m
//  VodSDKDemo
//
//  Created by Sheng on 2018/8/3.
//  Copyright © 2018年 Gensee. All rights reserved.
//

#import "GSVodPlayerController.h"
#import "UIView+GSSetRect.h"
#import "GSVodPlayerBar.h"
#import "GSMenu.h"
#import <GSCommonKit/GSCommonKit.h>
#define FASTSDK_COLOR16(value) [UIColor colorWithRed:((float)((value & 0xFF0000) >> 16))/255.0 green:((float)((value & 0xFF00) >> 8))/255.0 blue:((float)(value & 0xFF))/255.0 alpha:1.0]
@interface GSVodPlayerController () <GSVodPlayerBarDelegate,GSDocViewDelegate,VodPlayDelegate>
@property (nonatomic, strong) GSVodPlayerBar *playerBar;
@property (nonatomic, strong) VodGLView *vodView;
@property (nonatomic, strong) GSDocView *docView;
@property (nonatomic, strong) VodPlayer *vodPlayer;

@end

@implementation GSVodPlayerController {
    BOOL isPlayEnd;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"播放界面";
    self.view.backgroundColor = [UIColor blackColor];
    // Do any additional setup after loading the view.
    _vodView = [[VodGLView alloc] initWithFrame:CGRectMake(0, 64, Width, ceil(Width*9/16) + 8)];
    _vodView.backgroundColor = [UIColor blackColor];
    
    _vodView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_vodView];
    _playerBar = [[GSVodPlayerBar alloc] initWithFrame:CGRectMake(0, _vodView.bottom, Width, 38)];
    _playerBar.delegate = self;
    [self.view addSubview:_playerBar];
    _docView = [[GSDocView alloc] initWithFrame:CGRectMake(0, _playerBar.bottom, Width, Height - CGRectGetMaxY(_playerBar.frame))];
    _docView.delegate = self;
    _docView.showMode = GSDocViewShowModeScaleAspectFit;
    [_docView setBackgroundColor:51 green:51 blue:51];//文档加载以后，侧边显示的颜色
    [self.view addSubview:_docView];
    
    GSTagsContentView *tagView = [[GSTagsContentView alloc] initWithFrame:CGRectMake(10, Height - 40, Width - 20, 30) tags:@[@"日志上传"] handler:^(NSInteger index, NSString *text, BOOL isSelect) {
        if (index == 0) {
            __block MBProgressHUD *hud = nil;
            
            [GSDiagnosisInfo shareInstance].upLoadResult = ^(GSDiagnosisType type, NSString *errorDescription) {
                [hud hide:YES];
                if (type == GSDiagnosisUploadSuccess) {
                    [MBProgressHUD showHint:@"上传成功"];
                }else if (type == GSDiagnosisUploadNetError) {
                    [MBProgressHUD showHint:@"文件上传发生错误"];
                }else if (type == GSDiagnosisPackError) {
                    [MBProgressHUD showHint:@"文件打包出错"];
                }else if (type==GSDiagnosisSubmitXMLInfoError){
                    [MBProgressHUD showHint:@"提交回执数据出错"];
                }
                hud = nil;
            };
            
            [[GSDiagnosisInfo shareInstance] ReportDiagonseEx];
            hud = [MBProgressHUD showMessage:@"发送日志中"];
        }
    }];
    tagView.allowSelect = NO;
    [self.view addSubview:tagView];
    
    _vodPlayer = [[VodPlayer alloc] init];
    _vodPlayer.docSwfView = _docView;
    _vodPlayer.mVideoView = _vodView;
    _vodPlayer.delegate = self;
    _vodPlayer.hardwareAccelerate = YES;
    _vodPlayer.playItem = _item;
    
    isPlayEnd = YES;
    if (isPlayEnd) {
        _vodPlayer.playItem = _item;
        if (_isOnline) {
            [_vodPlayer OnlinePlay:YES audioOnly:NO];
        }else {
            [_vodPlayer OfflinePlay:YES];
        }
//        [[GSVodManager sharedInstance] play:_item online:_isOnline];
        _playerBar.isPlay = YES;
        isPlayEnd = NO;
    }
    
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"1X" style:UIBarButtonItemStylePlain target:self action:@selector(speedAction)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    
    [_vodPlayer getQaListWithPageIndex:1];
}

- (NSArray *)refs {
    return [NSArray arrayWithObjects:@"1X", @"1.25X", @"1.5X", @"1.75X", @"2X", @"2.5X", @"3X", @"3.5X", @"4X", nil];
}

- (void)speedAction {
    [GSMenu setTitleFont:[UIFont systemFontOfSize:12.f]];
    NSMutableArray *items = [NSMutableArray array];
    NSArray *refs = [self refs];
    for (int i = 0; i < refs.count; i++) {
        GSMenuItem *report;
        report = [GSMenuItem menuItem:refs[i]
                                image:nil  //pure_fault
                               target:self
                               action:@selector(selectSpeed:)];
        report.tag = i;
        report.foreColor = [UIColor colorWithRed:102/255.f green:102/255.f blue:102/255.f alpha:1];
        
        [items addObject:report];
    }
    [GSMenu showMenuInView:self.view
                  fromRect:CGRectMake(Width - 40, 0, 40, 64)
                 menuItems:items];
}

- (void)selectSpeed:(GSMenuItem *)item {
    [_vodPlayer SpeedPlay:item.tag];
    [self.navigationItem.rightBarButtonItem setTitle:self.refs[item.tag]];
}

- (void)backAction {
    if (self.vodPlayer) {
        [self.vodPlayer stop];
        self.vodPlayer.docSwfView = nil;
        self.vodPlayer = nil;
        self.item = nil;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    NSLog(@"[VodPlayer] dealloc");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -VodPlayDelegate
//初始化VodPlayer代理
- (void)onInit:(int)result haveVideo:(BOOL)haveVideo duration:(int)duration docInfos:(NSDictionary *)docInfos
{
    
    _playerBar.totalTime = duration;
    NSLog(@"[VodPlayer] onInit : %d",duration);
    if (isPlayEnd) {
        isPlayEnd = NO;
        if (_playerBar.currentTime != 0) {
            [_vodPlayer seekTo:_playerBar.currentTime];
        }
    }
    //    [self.vodplayer getChatListWithPageIndex:1];
}


/*
 *获取聊天列表
 *@chatList   列表数据 (sender: 发送者  text : 聊天内容   time： 聊天时间)
 *
 */
- (void)vodRecChatList:(NSArray*)chatList more:(BOOL)more currentPageIndex:(int)pageIndex
{
    
}

/*
 *获取问题列表
 *@qaList   列表数据 （answer：回答内容 ; answerowner：回答者 ; id：问题id ;qaanswertimestamp:问题回答时间 ;question : 问题内容  ，questionowner:提问者 questiontimestamp：提问时间）
 *
 */
- (void)vodRecQaList:(NSArray*)qaList more:(BOOL)more currentPageIndex:(int)pageIndex
{
    
}


//进度条定位播放，如快进、快退、拖动进度条等操作回调方法
- (void)onSeek:(int)position
{
    
}

//进度回调方法
- (void)onPosition:(int)position
{
    //    NSLog(@"[VodPlayer] onPosition : %d",position);
    _playerBar.currentTime = position;
}


/**
 * 文档信息通知
 * @param position 当前播放进度，如果app需要显示相关文档标题，需要用positton去匹配onInit 返回的docInfos
 */
- (void)onPage:(int) position width:(unsigned int)width height:(unsigned int)height;
{
    NSLog(@"[VodPlayer][Doc] onPosition : %d",position);
}


- (void)onAnnotaion:(int)position
{
    NSLog(@"[VodPlayer][Doc] onAnnotaion : %d",position);
}




- (void)onVideoStart
{
    NSLog(@"[VodPlayer] onVideoStart");
}

//播放完成停止通知，
- (void)onStop{
    NSLog(@"[VodPlayer] onStop");
    _playerBar.currentTime = 0;
    _playerBar.isPlay = NO;
    isPlayEnd = YES;
}

#pragma mark - GSVodPlayerBarDelegate

- (void)vodPlayerBar:(GSVodPlayerBar *)bar didSetPlay:(BOOL)isPlay {
    NSLog(@"[VodPlayer] didSetPlay : %d",isPlay);
    if (isPlayEnd) {
        if (isPlay) {
            _vodPlayer.playItem = _item;
            if (_isOnline) {
                [_vodPlayer OnlinePlay:YES audioOnly:NO];
            }else {
                [_vodPlayer OfflinePlay:YES];
            }
            _playerBar.isPlay = YES;
        }
    }else{
        if (isPlay) {
            [_vodPlayer resume];
        }else{
            [_vodPlayer pause];
        }
    }
    
}
- (void)vodPlayerBar:(GSVodPlayerBar *)bar didSlideToValue:(int)value {
    NSLog(@"[VodPlayer] didSlideToValue : %d",value);
    if (isPlayEnd) {
        _vodPlayer.playItem = _item;
        if (_isOnline) {
            [_vodPlayer OnlinePlay:YES audioOnly:NO];
        }else {
            [_vodPlayer OfflinePlay:YES];
        }
        _playerBar.isPlay = YES;
    }else{
        [_vodPlayer seekTo:value];
        if (value != bar.totalTime) { //不是结尾
            _playerBar.isPlay = YES;
        }
    }
}

- (void)vodPlayerBar:(GSVodPlayerBar *)bar beginSlide:(int)value {
    NSLog(@"[VodPlayer] beginSlide : %d",value);
    [_vodPlayer pause];
    _playerBar.isPlay = NO;
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
