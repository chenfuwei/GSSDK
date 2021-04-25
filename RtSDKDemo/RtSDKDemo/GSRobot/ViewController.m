//  ViewController.m
//  RobotPenManagerDemo
//  Created by JMS on 2017/2/18.
//  Copyright © 2017年 JMS. All rights reserved.

#import "ViewController.h"
#import "RobotPenDevice.h"
#import "RobotPenPoint.h"
#import "GSRobotBoardManager.h"
#import "RobotDocViewController.h"
#import "OLCustomView.h"
#define SCREEN_WIDTH self.view.bounds.size.width
#define SCREEN_HEIGHT self.view.bounds.size.height
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    //是否已经连接设备
    BOOL isConnect;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;//设备列表
@property (weak, nonatomic) IBOutlet UIButton *blueToothButton;//搜索设备按钮
@property(nonatomic,strong) RobotPenDevice *device;//连接中的设备
@property(nonatomic,strong) NSMutableArray *deviceArray;//设备列表数组
@end
@implementation ViewController
-(NSMutableArray *)deviceArray{
    if (!_deviceArray) {
        _deviceArray = [NSMutableArray array];
    }
    return _deviceArray;
}
#pragma mark- ========== 初始化 ===========
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}


/**
 设置UI相关
 */
- (void)setUI
{
    // 是否连接
    self.navigationItem.title=@"配对手写板";
    self.device = nil;
    isConnect = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView=[UIView new];
    [_blueToothButton setTitle:@"查找设备" forState:UIControlStateNormal];
    [_blueToothButton setTitle:@"断开连接" forState:UIControlStateSelected];
    [_blueToothButton addTarget:self action:@selector(blueToothButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark- ========== 按钮事件 ===========
-(void)blueToothButtonPressed:(UIButton *)sender{   // 搜索设备事件
    NSLog(@"%s",__func__);
    if (isConnect == NO) {
        [self.deviceArray removeAllObjects];
        //搜索设备
        [[GSRobotBoardManager sharedRobotBoardManager] scanBlueDeviceWithBlock:^(RobotPenDevice *device) {
            [self.deviceArray addObject:device];
            [self.tableView reloadData];
        }];
        
    } else{
        [self.deviceArray removeAllObjects];
        [_tableView reloadData];
        //断开连接
        [[GSRobotBoardManager sharedRobotBoardManager] disconnectDevice];
        _blueToothButton.selected=NO;
        isConnect=NO;
        self.device=nil;
    }
}



#pragma mark- ========== table delegate相关 ===========
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rowNumber = 0;
    if (self.deviceArray && [self.deviceArray count] > 0) {
        rowNumber = [self.deviceArray count];
    }
    return rowNumber;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.text = [[self.deviceArray objectAtIndex:indexPath.row] getName];  //获取设备名称
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%s",__func__);
    if (!self.device) {
        RobotPenDevice *selectItem = [self.deviceArray objectAtIndex:[indexPath row]]; // 设备Model
        //连接设备
        [OLCustomView showHUDWithText:@"正在连接中" toView:self.view];
        [[GSRobotBoardManager sharedRobotBoardManager] connectDevice:selectItem state:^(DeviceState state) {
            if (state==DEVICE_CONNECTE_SUCCESS) {//设备连接成功
                [OLCustomView showText:@"连接成功" toView:self.view withBlock:^{
                    isConnect=YES;
                    _blueToothButton.selected=YES;
                    self.device=selectItem;
                    RobotDocViewController *doc=[RobotDocViewController new];
                    doc.connectInfo=self.connectInfo;
                    [self.navigationController pushViewController:doc animated:YES];
                }];
            }
        }];
    }else{
        RobotDocViewController *doc=[RobotDocViewController new];
        doc.connectInfo=self.connectInfo;
        [self.navigationController pushViewController:doc animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
