//GSRobotBoardManager.m
//Created by Gaojin Hsu on 2018/8/23.
//Copyright © 2018年 gensee. All rights reserved.
#import "GSRobotBoardManager.h"
#import "RobotPenManager.h"
@interface GSRobotBoardManager()<RobotPenDelegate>
{
      /**是否已经连接设备*/
      BOOL _isConnect;
}
/**设备回调的block*/
@property(nonatomic,copy)void(^bufferDevice)(RobotPenDevice *device);
/**设备的状态*/
@property(nonatomic,copy)void(^OSDeviceStateBlock)(DeviceState state);
/**连接中的设备*/
@property(nonatomic,strong)RobotPenDevice *device;
@property(nonatomic,strong)NSMutableArray *deviceArray;
@end
@implementation GSRobotBoardManager
#pragma mark - -lazy
-(NSMutableArray *)deviceArray{
    if (!_deviceArray) {
        _deviceArray = [NSMutableArray array];
    }
    return _deviceArray;
}


#pragma mark - -lifecycle
static GSRobotBoardManager *singleManager = nil;
+ (instancetype)sharedRobotBoardManager
{
    static dispatch_once_t pred = 0;
    dispatch_once(&pred, ^{
        singleManager = [[super allocWithZone:NULL] init];
    });
    return singleManager;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedRobotBoardManager];
}
- (instancetype)copyWithZone:(NSZone *)zone
{
    return self;
}

- (instancetype)mutableCopyWithZone:(NSZone *)zone
{
    return self;
}
-(instancetype)init{
    if (self=[super init]) {
        //设置代理
        [[RobotPenManager sharePenManager] setPenDelegate:self];
        //设置设备的连接型号
        [[RobotPenManager sharePenManager] setDeviceType:T9B];
    }
    return self;
}


-(void)scanBlueDeviceWithBlock:(void (^)(RobotPenDevice *))bufferDevice{
    self.bufferDevice = bufferDevice;
    //搜索设备
    [[RobotPenManager sharePenManager] scanDeviceWithALL:NO];
    
}

-(void)connectDevice:(RobotPenDevice *)penDevice state:(void (^)(DeviceState))deviceStateBlock
{
    self.OSDeviceStateBlock = deviceStateBlock;
    [[RobotPenManager sharePenManager] connectDevice:penDevice];
}

- (void)setOrigina:(BOOL)isOriginal optimize:(BOOL)isOptimize transform:(BOOL)isTransform;
{
    [[RobotPenManager sharePenManager] setOrigina:isOriginal optimize:(BOOL)isOptimize transform:isTransform];
}


- (RobotPenDevice *)getConnectDevice;
{
   return [[RobotPenManager sharePenManager] getConnectDevice];
}
-(void)stopScanDevice;{
    [[RobotPenManager sharePenManager] stopScanDevice];
}


- (void)cleanAllPairingDevice;
{
    [[RobotPenManager sharePenManager] cleanAllPairingDevice];

}
-(void)disconnectDevice;
{
    [[RobotPenManager sharePenManager] disconnectDevice];
}

- (void)setStrokeWidth:(float)width;
{
    [[RobotPenManager sharePenManager] setStrokeWidth:width];
}

#pragma mark - --RobotPenDelegate
/*!
 @method
 @abstract 发现电磁板设备
 @param device 设备
 */
-(void)getBufferDevice:(RobotPenDevice *)device;{
    if (_bufferDevice) {
        _bufferDevice(device);
    }
}


/*!
 @method
 @abstract 监听电磁板设备状态
 @param State 状态
 */
- (void)getDeviceState:(DeviceState)State;
{
    switch (State) {
        case DEVICE_DISCONNECTED://未连接
            NSLog(@"disconnect");
            _isConnect = NO;
            //搜索设备
            [[RobotPenManager sharePenManager] scanDeviceWithALL:NO];
            break;
        case DEVICE_CONNECTE_SUCCESS://已连接
            NSLog(@"CONNECTED");
            //停止搜索
            [[RobotPenManager sharePenManager] stopScanDevice];
            break;
        case DEVICE_CONNECTING://正在连接
            NSLog(@"connecting");
            break;
           //获取设备信息完成，大部分设备信息会在这里获取完毕。建议设备信息在这里获取、赋值。
        case DEVICE_INFO_END:
        {
            _isConnect = YES;
            //获取当前连接设备信息
            self.device = [[RobotPenManager sharePenManager] getConnectDevice];
            [self.deviceArray removeAllObjects];
            [self.deviceArray addObject:self.device];
        }
            break;
        //可以进行检查更新操作，检查更新操作尽量在这里进行。
        case DEVICE_UPDATE:
        {
            //检查更新
            [[RobotPenManager sharePenManager] getIsNeedUpdate];
        }
            break;
            
        case DEVICE_UPDATE_CAN://设备可以更新
        {
              
        }
            break;
        default:
            break;
    }
    if (self.OSDeviceStateBlock) {
        self.OSDeviceStateBlock(State);
    }
}



/*!
 @method
 @abstract 获取原始点数据
 @param point 原始点
 */
- (void)getPointInfo:(RobotPenPoint *)point;{
    if (self.recevicePointInfo) {
        self.recevicePointInfo(point);
    }
}


/**
  获取优化点的数据
 */
- (void)getOptimizesPointInfo:(RobotPenUtilPoint *)point;
{
    if (self.receviceUtilPointInfo) {
        self.receviceUtilPointInfo(point);
    }
}
@end
