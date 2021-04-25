//
//  InvestigationItemViewController.m
//  iOSDemo
//
//  Created by Gaojin Hsu on 4/6/15.
//  Copyright (c) 2015 gensee. All rights reserved.
//

#import "InvestigationItemViewController.h"
#import <RtSDK/RtSDK.h>
#import "MBProgressHUD.h"
#import "InvestigationDetailViewController.h"


@interface InvestigationItemViewController ()<GSBroadcastRoomDelegate, GSBroadcastInvestigationDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) GSBroadcastManager *broadcastManager;

@property (strong, nonatomic) MBProgressHUD *progressHUD;

@property (strong, nonatomic) UITableView *themeTableView;

@property (strong, nonatomic) NSMutableArray *investigationsArray;

@property (strong, nonatomic) NSMutableDictionary *investigationDic;

@end

@implementation InvestigationItemViewController {
    long long _userID;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.navigationController.navigationBar.translucent = NO;
    
    self.investigationsArray = [NSMutableArray array];
    self.investigationDic = [NSMutableDictionary dictionary];
    
    self.progressHUD = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:self.progressHUD];
    self.progressHUD.labelText =  NSLocalizedString(@"BroadcastConnecting",  @"直播连接提示");
    [self.progressHUD show:YES];
    
    [self setUpTableView];
    
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

- (void)setUpTableView
{
    double version = [[UIDevice currentDevice].systemVersion doubleValue];//判定系统版本。
    if (version < 7.0) {
        // iOS 6 code
        self.themeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height  - 44)];
    }
    else if (version < 8.0)
    {
        // iOS 7 code
        self.themeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    }
    else
    {
        // iOS8 code
        self.themeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    }
    
    [self.view addSubview:self.themeTableView];
    self.themeTableView.delegate = self;
    self.themeTableView.dataSource = self;

}


- (void)initBroadCastManager
{
    self.broadcastManager = [GSBroadcastManager sharedBroadcastManager];
    self.broadcastManager.broadcastRoomDelegate = self;
    self.broadcastManager.investigationDelegate = self;
    
    if (![_broadcastManager connectBroadcastWithConnectInfo:self.connectInfo]) {
        
        [self.progressHUD show:NO];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"WrongConnectInfo", @"参数不正确") delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"知道了") otherButtonTitles:nil, nil];
        [alertView show];
        
    }
    
}

#pragma mark -
#pragma mark GSBroadcastManagerDelegate


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
    _userID = userID;
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
#pragma mark GSBroadcastInvestigationDelegate

// 问卷调查模块连接代理
- (void)broadcastManager:(GSBroadcastManager*)broadcastManager didReceiveInvestigationModuleInitResult:(BOOL)result
{
//    GSInvestigationOption *option1 = [[GSInvestigationOption alloc]init];
//    option1.content = @"鱼";
//    option1.isCorrectItem = NO;
//    option1.ID = [[NSUUID UUID]UUIDString];
//
//    GSInvestigationOption *option2 = [[GSInvestigationOption alloc]init];
//    option2.content = @"猫";
//    option2.isCorrectItem = YES;
//    option2.ID = [[NSUUID UUID]UUIDString];
//
//    GSInvestigationOption *option3 = [[GSInvestigationOption alloc]init];
//    option3.content = @"蝴蝶";
//    option3.isCorrectItem = NO;
//    option3.ID = [[NSUUID UUID]UUIDString];
//
//    NSArray *options = @[option1, option2, option3];
//
//    GSInvestigationQuestion *ques1 = [[GSInvestigationQuestion alloc]init];
//    ques1.ID = [[NSUUID UUID]UUIDString];
//    ques1.questionType = GSCardQuestionTypeSingleChoice;
//    ques1.content = @"下列哪些是哺乳动物";
//    ques1.options = options;
//
//    NSArray *questions = @[ques1];
//
//    GSInvestigation *inves = [[GSInvestigation alloc]init];
//    inves.ID = [[NSUUID UUID]UUIDString];
//    inves.theme = @"期中测试";
//    inves.questions = questions;
//    inves.ownerID = _userID;
//
//    if ([[GSBroadcastManager sharedBroadcastManager]addInvestigation:inves]) {
//    } else {
//        // error
//    }
}

// 添加问卷调查代理
- (void)broadcastManager:(GSBroadcastManager*)broadcastManager didAddNewInvestigation:(GSInvestigation*)investigation
{
    
    [[GSBroadcastManager sharedBroadcastManager]publishInvestigation:investigation.ID forceAnswer:YES];
}

// 删除一项问卷调查
- (void)broadcastManager:(GSBroadcastManager*)broadcastManager didRemoveInvestigation:(GSInvestigation*)investigation
{
    
}

// 发布一项问卷调查
- (void)broadcastManager:(GSBroadcastManager*)broadcastManager didPublishInvestigation:(GSInvestigation*)investigation
{
    if ([self.investigationsArray containsObject:investigation.ID]) {
        return;
    }
    
    [self.investigationsArray addObject:investigation.ID];
    [self.investigationDic setObject:investigation forKey:investigation.ID];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow: self.investigationsArray.count - 1 inSection:0];
    NSMutableArray *indePaths = [NSMutableArray array];
    [indePaths addObject:indexPath];
    
    [self.themeTableView insertRowsAtIndexPaths:indePaths withRowAnimation:UITableViewRowAnimationBottom];
}

// 发布一项问卷调查的结果
- (void)broadcastManager:(GSBroadcastManager*)broadcastManager didPublishInvestigationResult:(GSInvestigation*)investigation
{
    
}

// 提交一项问卷调查
- (void)broadcastManager:(GSBroadcastManager*)broadcastManager didSubmitInvestigation:(GSInvestigation*)investigation
{
    
}

// 问卷调查截止
- (void)broadcastManager:(GSBroadcastManager *)broadcastManager didTerminateInvestigation:(GSInvestigation *)investigation
{
    
}

// 发送问卷调查连接
- (void)broadcastManager:(GSBroadcastManager *)broadcastManager didPostInvestigationURL:(NSString *)investigationURL
{
    
}

#pragma mark -
#pragma mark UITabelView Delegate/DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.investigationsArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = ((GSInvestigation*)[self.investigationDic objectForKey:self.investigationsArray[indexPath.row]]).theme;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    InvestigationDetailViewController *detailController = (InvestigationDetailViewController*)[board instantiateViewControllerWithIdentifier:@"InvestDetail"];
    detailController.investigation = [self.investigationDic objectForKey: self.investigationsArray[indexPath.row]];
    detailController.broadcastManager = _broadcastManager;
    [self.navigationController pushViewController:detailController animated:YES];
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.themeTableView.frame.size.width, 40)];
    UILabel *label = [[UILabel alloc]initWithFrame:view.bounds];
    label.text = NSLocalizedString(@"InvestigationTheme", nil);
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}


#pragma mark -
#pragma mark System Default Code

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

- (void)dealloc
{
    // 退出直播，但不结束直播, 若参数为YES,直播将同时结束
//    [self.broadcastManager leaveAndShouldTerminateBroadcast:NO];
//    // 释放资源
//    [self.broadcastManager invalidate];
}

- (BOOL)shouldAutorotate {
    return NO;
}
@end
