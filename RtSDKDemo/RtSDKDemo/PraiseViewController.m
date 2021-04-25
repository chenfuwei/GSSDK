//  PraiseViewController.m
//  RtSDKDemo
//  Created by Sheng on 2018/6/15.
//  Copyright © 2018年 gensee. All rights reserved.

#import "PraiseViewController.h"
#import "MBProgressHUD.h"
@implementation GSPraiseModel
- (instancetype)init{
    if (self = [super init]) {
        _modalInfo = [GSPraiseUserInfo new];
    }
    return self;
}

@end

@implementation GSPraiseViewCell
{
    CAShapeLayer *backLayer;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        self.textLabel.font = [UIFont systemFontOfSize:13];
        self.backgroundColor = [UIColor clearColor];

        
        _modal = [[UILabel alloc]initWithFrame:CGRectMake(0, 2, 60, 44)];
        _modal.font = [UIFont systemFontOfSize:13];
 
        UIView *accessoryView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 44)];

        [accessoryView addSubview:_modal];
        
        self.accessoryView = accessoryView;

        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self addObserver:self forKeyPath:@"modalInfo.m_dwRecv" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        
        backLayer = [CAShapeLayer layer];
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(5, 2, [UIScreen mainScreen].bounds.size.width - 40 - 10, 40) cornerRadius:5];
        backLayer.path = path.CGPath;
        backLayer.fillColor = [UIColor whiteColor].CGColor;
        
        [self.contentView.layer insertSublayer:backLayer atIndex:0];
    }
    return self;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"modalInfo.m_dwRecv"]) {
        if (!_modalInfo) {
            return;
        }
        NSNumber *obj = change[NSKeyValueChangeNewKey];
        if (obj) {
            _modal.text = [NSString stringWithFormat:@"🎖:%d",obj.intValue];
        }
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected) {
        backLayer.fillColor = [UIColor colorWithRed:30/255.f green:144/255.f blue:225/255.f alpha:1.f].CGColor;
    }else{
        backLayer.fillColor = [UIColor whiteColor].CGColor;
    }
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"modalInfo.m_dwRecv"];
}

@end

@interface PraiseViewController () <UITableViewDelegate,UITableViewDataSource,GSBroadcastRoomDelegate,GSBroadcastPraiseDelegate>
@property (weak, nonatomic) IBOutlet UILabel *recModalCount;
@property (weak, nonatomic) IBOutlet UILabel *modalTotal;
@property (weak, nonatomic) IBOutlet UILabel *recFavour;
@property (weak, nonatomic) IBOutlet UITableView *userTable;
@property (weak, nonatomic) IBOutlet UIButton *modalButton;

@property (nonatomic, strong) NSMutableArray *datas;

@property (nonatomic, strong) GSBroadcastManager *broadcastManager;
@property (nonatomic, strong) MBProgressHUD *progressHUD;
@property (nonatomic, assign) long long  userID;
@property (nonatomic, assign) NSInteger  selectIndex;
@property (nonatomic, strong) GSUserInfo *organizerInfo;

@property (weak, nonatomic) IBOutlet UIButton *favorBtn;

//排行榜界面
@property (nonatomic, strong) UITableView *rankTable;
@property (nonatomic, strong) UIView *rankBackView;
@property (nonatomic, strong) NSMutableArray *rankDatas;
@end

@implementation PraiseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _datas = [NSMutableArray array];
    _userTable.delegate=self;
    _userTable.dataSource=self;
    _userTable.accessibilityLabel=@"_userTable";
    _userTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    NSString *version = [UIDevice currentDevice].systemVersion;
    if (version.doubleValue >= 11.0) {  // >= 11
        _userTable.estimatedRowHeight = 0;
        _userTable.estimatedSectionHeaderHeight = 0;
        _userTable.estimatedSectionFooterHeight = 0;
    }
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [_userTable setTableFooterView:view];
    _selectIndex = -1;
    [self initBroadCastManager];
    [self initRank];
}


//初始化排行榜视图
- (void)initRank {
    _rankDatas = [NSMutableArray array];
    _rankTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 40, [UIScreen mainScreen].bounds.size.height - 200) style:UITableViewStylePlain];
    _rankTable.accessibilityLabel=@"_rankTable";
    _rankTable.delegate = self;
    _rankTable.dataSource = self;
    _rankTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    _rankTable.backgroundColor = [UIColor grayColor];
    NSString *version = [UIDevice currentDevice].systemVersion;
    
    if (version.doubleValue >= 11.0) {  // >= 11
        _rankTable.estimatedRowHeight = 0;
        _rankTable.estimatedSectionHeaderHeight = 0;
        _rankTable.estimatedSectionFooterHeight = 0;
    }
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [_rankTable setTableFooterView:view];
    
    _rankBackView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _rankBackView.backgroundColor = [UIColor blackColor];
    [_rankBackView addSubview:_rankTable];
    _rankTable.center = _rankBackView.center;
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickTap)];
    [_rankBackView addGestureRecognizer:tapGR];
}
- (void)clickTap {
    [_rankBackView removeFromSuperview];
}

- (void)initBroadCastManager
{
    self.broadcastManager = [GSBroadcastManager sharedBroadcastManager];
    self.broadcastManager.praiseDelegate = self;
    self.broadcastManager.broadcastRoomDelegate = self;
    if (![_broadcastManager connectBroadcastWithConnectInfo:self.connectInfo]) {
        
        [self.progressHUD show:NO];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"WrongConnectInfo", @"参数不正确") delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"知道了") otherButtonTitles:nil, nil];
        [alertView show];
        
    }

}

#pragma mark - --GSBroadcastRoomDelegate
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
            
        case  GSBroadcastConnectResultThirdTokenError:
            
        case GSBroadcastConnectResultLoginFailed:
            
        case GSBroadcastConnectResultNetworkError:
            
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
    if (joinResult == GSBroadcastJoinResultSuccess) {
        _userID = userID;
        self.broadcastManager.favour = 15;
        self.broadcastManager.medal = 10;
        [self.broadcastManager SetPraiseInfo:GSPraiseTypeMedal total:-1];
        [self.broadcastManager GetPraiseInfo:GSPraiseTypeMedal llUserID:userID];
        [self.broadcastManager GetPraiseInfo:GSPraiseTypeFavour llUserID:userID];
        BOOL ret=[[GSBroadcastManager sharedBroadcastManager] GetPraiseRecvList:GSPraiseTypeMedal dwMaxUser:50];
        NSLog(@"%d",ret);
    }
    // 服务器重启导致重连
    if (rebooted) {
        // 相应处理
        
    }
}

- (BOOL)broadcastManager:(GSBroadcastManager *)manager saveSettingsInfoKey:(NSString *)key numberValue:(int)value {
    if ([key isEqualToString:@"favour.enable"]) {
        if (!value) {
            _favorBtn.userInteractionEnabled = NO;
            _favorBtn.backgroundColor = [UIColor grayColor];
        }
    }
    
    if ([key isEqualToString:@"medal.enable"]) {
        if (!value) {
            _modalButton.userInteractionEnabled = NO;
            _modalButton.backgroundColor = [UIColor grayColor];
        }
    }
    return YES;
}

// 断线重连
- (void)broadcastManagerWillStartRoomReconnect:(GSBroadcastManager*)manager
{
    [self.progressHUD show:YES];
    self.progressHUD.labelText = NSLocalizedString(@"Reconnect", @"正在重连");
    
}

#pragma mark - --GSBroadcastPraiseDelegate
/**
 点赞/勋章回调
 */
- (void)OnPraiseInfo:(int) nResult strPraiseType:(GSPraiseType)strPraiseType userinfo:(GSPraiseUserInfo*) userinfo {
    if (userinfo.userID == _userID) {
        if (strPraiseType == GSPraiseTypeMedal) {
            self.modalTotal.text = [NSString stringWithFormat:@"勋章总数:%d",userinfo.m_dwRemain];
            self.recModalCount.text = [NSString stringWithFormat:@"收到勋章:%d",userinfo.m_dwRecv];
        }else {
            self.recFavour.text = [NSString stringWithFormat:@"收到点赞:%d",userinfo.m_dwRecv];
            [_favorBtn setTitle:[NSString stringWithFormat:@"点赞(%d)",userinfo.m_dwRemain] forState:UIControlStateNormal];
        }
    }

}

//点赞/勋章的总数信息
- (void)OnGetPraiseTotal:(int) nResult strPraiseType:(GSPraiseType)strPraiseType dwTotal:(unsigned int) dwTotal {
    if (strPraiseType == GSPraiseTypeMedal) {
        self.modalTotal.text = [NSString stringWithFormat:@"勋章总数:%d",dwTotal];
    }
}


//获取勋章点赞排行
- (void) OnGetPraiseRecvList:(int) nResult strPraiseType:(GSPraiseType)strPraiseType praises:(NSArray<GSPraiseInfo*>*) dwTotal {
    NSLog(@"%@",_datas);
    if (dwTotal.count > 0) {
        _rankDatas = [NSMutableArray arrayWithArray:dwTotal];
        [dwTotal enumerateObjectsUsingBlock:^(GSPraiseInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [_datas enumerateObjectsUsingBlock:^(GSPraiseModel *tmp, NSUInteger idx, BOOL * _Nonnull stop) {
                if (tmp.userInfo.userID == obj.userID) {
                    tmp.modalInfo.m_dwRecv=obj.m_dwTotal;
                    *stop = YES;
                }
            }];
        }];
    }
    [_rankTable reloadData];
    [_userTable reloadData];
}


/**
 点赞勋章 发送回调
 */
- (void) OnSendPraiseNotify:(GSPraiseType)strPraiseType userID:(long long)userID toUser:(long long)toUserID time:(unsigned int)time srcUserinfo:(GSPraiseUserInfo *)src dstUserinfo:(GSPraiseUserInfo *)dst {
    GSPraiseUserInfo *my;
    if (dst.userID == _userID) {
        my = dst;
    }else if (src.userID == _userID) {
        my = src;
    }
    if (strPraiseType == GSPraiseTypeMedal) {
        [_datas enumerateObjectsUsingBlock:^(GSPraiseModel *tmp, NSUInteger idx, BOOL * _Nonnull stop) {
            GSPraiseUserInfo *obj = tmp.modalInfo;
            if (tmp.userInfo.userID == dst.userID) {
                obj.m_dwRemain = dst.m_dwRemain;
                obj.m_dwSend = dst.m_dwSend;
                obj.m_dwRecv = dst.m_dwRecv;
                *stop = YES;
            }
        }];
        if (!my) {
            //不是自己的
            return;
        }
        self.modalTotal.text = [NSString stringWithFormat:@"勋章总数:%d",my.m_dwRemain];
        self.recModalCount.text = [NSString stringWithFormat:@"收到勋章:%d",my.m_dwRecv];
        
    }else {
        if (!my) {
            //不是自己的
            return;
        }
        self.recFavour.text = [NSString stringWithFormat:@"收到点赞:%d",my.m_dwRecv];
        [_favorBtn setTitle:[NSString stringWithFormat:@"点赞(%d)",my.m_dwRemain] forState:UIControlStateNormal];
    }
}


#pragma mark - user

/**
 其他用户加入房间代理
 */
- (void)broadcastManager:(GSBroadcastManager *)manager didReceiveOtherUser:(GSUserInfo *)userInfo
{
    if (userInfo.isOrganizer) {
        _organizerInfo = userInfo;
    }
    
    if (userInfo.userID == _userID ) {
        if (userInfo.isOrganizer) {
            _modalButton.userInteractionEnabled = YES;
            _modalTotal.hidden = NO;
        }else{
            _modalTotal.hidden = YES;
            _modalButton.userInteractionEnabled = NO;
            _modalButton.backgroundColor = [UIColor lightGrayColor];
        }
        
    }
    
    BOOL isFind = NO;
    for (GSPraiseModel *model in _datas) {
        if (model.userInfo.userID == userInfo.userID) {
            isFind = YES;
            break;
        }
    }
    
    if (isFind) {
        return;
    }else{
        GSPraiseModel *model = [GSPraiseModel new];
        model.userInfo = userInfo;
        [_datas addObject:model];
        [self.userTable reloadData];
    }
}

- (void)broadcastManager:(GSBroadcastManager *)manager didLoseOtherUser:(long long)userID {
    
    GSPraiseModel *delete;
    for (GSPraiseModel *tmp in _datas) {
        if (tmp.userInfo.userID == userID) {
            delete = tmp;
            break;
        }
    }
    if (delete) {
        [_datas removeObject:delete];
        [self.userTable reloadData];
    }
}

- (void)broadcastManager:(GSBroadcastManager *)manager didUpdateUserInfo:(GSUserInfo *)userInfo updateFlag:(GSUserInfoUpdate)flag{
    
    if (flag == GSUserInfoUpdateRole) {
        __weak typeof(self) wself = self;
        [_datas enumerateObjectsUsingBlock:^(GSPraiseModel *tmp, NSUInteger idx, BOOL * _Nonnull stop) {
            GSUserInfo *obj = tmp.userInfo;
            if (obj.userID == userInfo.userID) {
                obj.isOrganizer = userInfo.isOrganizer;
                if (obj.isOrganizer) {
                    wself.organizerInfo = obj;
                    wself.modalButton.userInteractionEnabled = YES;
                    wself.modalTotal.hidden = NO;
                }else{
                    wself.modalTotal.hidden = YES;
                    wself.modalButton.userInteractionEnabled = NO;
                    wself.modalButton.backgroundColor = [UIColor lightGrayColor];
                }
                *stop = YES;
            }
        }];
    }
    
}

- (void)dealloc
{
    [self.broadcastManager leaveAndShouldTerminateBroadcast:NO];
}


/**
 点赞
 */
- (IBAction)favour:(id)sender {
    
    if (_organizerInfo) {
        if (_organizerInfo.userID == _userID) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"你不能点赞自己" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
        }else{
            [self.broadcastManager SendPraise:GSPraiseTypeFavour userID:_organizerInfo.userID strToUserName:_organizerInfo.userName strComment:@"Favour"];
        }
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"未获取到组织者" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
}



/**
 勋章
 */
- (IBAction)modal:(id)sender {
    if (_datas) {
        if (_selectIndex != -1) {
            GSPraiseModel *model = [_datas objectAtIndex:_selectIndex];
            if (model.userInfo.userID == _userID) {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"不能奖励自己勋章🎖" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alertView show];
                return;
            }
            [self.broadcastManager SendPraise:GSPraiseTypeMedal userID:model.userInfo.userID strToUserName:model.userInfo.userName strComment:@"Modal"];
        }else{
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择一个用户奖励勋章" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
        }
        
    }
    
}


/**
 显示排行榜
 */
- (IBAction)showList:(id)sender {
    __weak typeof(self) wself = self;
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"选择类型(进入后点击即可退出)" preferredStyle:UIAlertControllerStyleActionSheet];
    if (_favorBtn.userInteractionEnabled) {
        UIAlertAction *favour = [UIAlertAction actionWithTitle:@"点赞" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [wself.rankDatas removeAllObjects];
            [wself.broadcastManager GetPraiseRecvList:GSPraiseTypeFavour dwMaxUser:10];
            [wself.view addSubview:wself.rankBackView];
        }];
        [alertVC addAction:favour];
    }
    if (_modalButton.userInteractionEnabled) {
        UIAlertAction *medal = [UIAlertAction actionWithTitle:@"勋章" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [wself.rankDatas removeAllObjects];
            [wself.broadcastManager GetPraiseRecvList:GSPraiseTypeMedal dwMaxUser:10];
            [wself.view addSubview:wself.rankBackView];
        }];
        [alertVC addAction:medal];
    }
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:cancel];
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _rankTable) {
        return _rankDatas.count;
    }else{
        return _datas.count;
    }
    
}

static NSString *cellID = @"GSPraiseViewCell";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _userTable) {//用户列表
        GSPraiseViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[GSPraiseViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            
        }
        GSPraiseModel *model = _datas[indexPath.row];
        if (model.userInfo.userID == _userID) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@(我)",model.userInfo.userName];
        }else{
            cell.textLabel.text = model.userInfo.userName;
        }
        cell.modalInfo = model.modalInfo;
        return cell;
    }else{
        GSPraiseViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[GSPraiseViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            
        }
        if (_rankDatas.count > 0) {
            GSPraiseInfo *model = _rankDatas[indexPath.row];
            if (model.userID == _userID) {
                cell.textLabel.text = [NSString stringWithFormat:@"%ld.%@(我)",indexPath.row + 1,model.m_strUserName];
            }else{
                cell.textLabel.text = [NSString stringWithFormat:@"%ld.%@",indexPath.row + 1,model.m_strUserName];;
            }
            cell.modal.text = [NSString stringWithFormat:@"🎖:%d",model.m_dwTotal];
        }
        
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_selectIndex && _selectIndex != indexPath.row) {
        NSIndexPath *mindex = [NSIndexPath indexPathForRow:_selectIndex inSection:0];
        [tableView deselectRowAtIndexPath:mindex animated:NO];
    }
    _selectIndex = indexPath.row;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (BOOL)shouldAutorotate {
    return NO;
}

@end
