//  RobotDocViewController.m
//  RtSDKDemo
//  Created by Gaojin Hsu on 2018/11/15.
//  Copyright © 2018年 gensee. All rights reserved.
#import "RobotDocViewController.h"
#import "TaggingMarkView.h"
#import "UIAlertController+Blocks.h"
#import <GSCommonKit/UIView+GSRectExtension.h>
#import "GSRobotBoardManager.h"
#import "RobotPenUtilPoint.h"
#import <GSDocKit/GSDocAnnoProtocol.h>
#import "UIViewController+OLExtend.h"
#import "NSObject+OLKVO.h"
#import "RobotPenManager.h"
#define TaggingMarkViewPortraitFrame  CGRectMake(0, MAX(SCREENWIDTH,SCREENHEIGHT)-(TagDocBottomH+44), MIN(SCREENWIDTH,SCREENHEIGHT), (TagDocBottomH + 44))
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define TagDocBottomH (49+IPhoneXBottomOffsetH)
#define  IPhoneXBottomOffsetH (isIPhoneX?34:0)
#define isIPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define OLWEAKSELF  __weak typeof(self) weakself = self;
#define PenSizeSmall   1    //笔-粗细1
#define PenSizeMid   3    //笔-粗细3
#define PenSizeBig   6    //笔-粗细6
static NSMutableDictionary *_mdic;
@interface RobotDocViewController ()<GSBroadcastRoomDelegate, GSBroadcastDocumentDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate,GSDocViewDelegate,TaggingMarkViewDelegate>{
    BOOL _doubleEnable;
    CGRect _orRect;//原始场景区域
    CGFloat _rot;//板子的比例系数
    CGSize _secenseSize;//优化后的场景区域
    CGFloat _offsetx;//优化后的场景偏移量，主要是居中的作用
    UILabel *_lable;
    CGPoint lastP;
}
@property(nonatomic,retain)TaggingMarkView* taggingMarkView;
@property (strong, nonatomic)GSBroadcastManager *broadcastManager;
@property(nonatomic,strong)UIImageView *tempImageView;
@property (strong, nonatomic)GSDocView *docView;
@property (strong, nonatomic)MBProgressHUD *progressHUD;
/**是否标注模式*/
@property(assign,nonatomic)BOOL isAnnotationMode;
@property(assign,nonatomic)CGFloat originalY;
@end
@implementation RobotDocViewController
#pragma mark -
-(UIImageView *)tempImageView{
    if (!_tempImageView) {
        _tempImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 200, 375, 200)];
        [self.view addSubview:_tempImageView];
    }
    return _tempImageView;
}

-(TaggingMarkView*)taggingMarkView{
    if (!_taggingMarkView) {
        _taggingMarkView=[[TaggingMarkView alloc] initWithFrame:TaggingMarkViewPortraitFrame];
        _taggingMarkView.delegate=self;
        [self.view addSubview:_taggingMarkView];
        
        OLWEAKSELF
        [_taggingMarkView setTopButton:^(GSTagStyle style) {
            
            switch (style) {
                case GSTagClose:{
                }
                    break;
                case GSTagPen:{
                }
                    break;
                    
                case GSTagPenThin:{//细线
                   weakself.docView.lineSize=PenSizeSmall;
                }
                    break;
                    
                case GSTagPenMiddle:{//中线
                    weakself.docView.lineSize=PenSizeMid;
                }
                    break;
                    
                case GSTagPenThick:{//粗线
                    weakself.docView.lineSize=PenSizeBig;
                }
                    break;
                case GSTagEraser:{
                    if ((weakself.docView.docAnnoType=GSDocumentAnnoTypeCleaner)) {
                        weakself.docView.docAnnoType=GSDocumentAnnoTypeFreePenEx;
                    }else{
                        weakself.docView.docAnnoType=GSDocumentAnnoTypeCleaner;
                    }
                }
                    break;
                case GSTagTrash:{
                    [weakself.docView cleanAllAnnos];
                    
                }
                    break;
                case GSTagUndo:{
                    [weakself.docView undo];
                }
                    break;
                case GSTagRedo:{
                    [weakself.docView redo];
                }
                    break;
                    
                default:
                    break;
            }
            
        }];
        
        
        [_taggingMarkView setValueChange:^(UIColor *color) {
           weakself.docView.lineColor=color;
        }];
        
    }
    return _taggingMarkView;
}

#pragma mark --
- (void)startTagDoc:(BOOL)isBegin //开始标注
{
    NSLog(@"startTagDoc");
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"手写板";
    self.view.backgroundColor=[UIColor whiteColor];
    // 注意下列代码的顺序
    [self setup];
    self.progressHUD = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:self.progressHUD];
    self.progressHUD.labelText =  NSLocalizedString(@"BroadcastConnecting",  @"直播连接提示");
    [self.progressHUD show:YES];
    
    [self initBroadCastManager];
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithTitle:@"back" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = left;
   
    _mdic=[NSMutableDictionary dictionary];
}

- (void)back:(id)sender
{
    self.docView.hidden=YES;
    self.docView=nil;
    [self.progressHUD show:YES];
    self.progressHUD.labelText = @"Leaving...";
    [self.broadcastManager leaveAndShouldTerminateBroadcast:NO];
    [[GSRobotBoardManager sharedRobotBoardManager] disconnectDevice];
    [self ol_popMiddleVC];
}

- (void)initBroadCastManager
{
    self.broadcastManager = [GSBroadcastManager sharedBroadcastManager];
    // 注意下列代码的顺序
    self.broadcastManager.documentView = self.docView;
    self.broadcastManager.broadcastRoomDelegate = self;
    self.broadcastManager.documentDelegate = self;
    if (![_broadcastManager connectBroadcastWithConnectInfo:self.connectInfo]) {
        [self.progressHUD show:NO];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"WrongConnectInfo", @"参数不正确") delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"知道了") otherButtonTitles:nil, nil];
        [alertView show];
    }
    
    
}

- (void)setup
{
    double version = [[UIDevice currentDevice].systemVersion doubleValue];//判定系统版本。
    CGFloat y;
    
    if (version < 7.0) {
        y = 0;
    }
    else
    {
        if (version >= 8.0)
        {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        y = [[UIApplication sharedApplication]statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;
    }
    
    self.docView = [[GSDocView alloc]initWithFrame:CGRectMake(0, 120 ,self.view.frame.size.width, self.view.frame.size.height/2)];
    self.docView.backgroundColor = [UIColor clearColor];
    self.docView.isAnnomationMode=YES;
    self.docView.isRoleTeacher=YES;
    self.docView.docAnnoType=GSDocumentAnnoTypeFreePenEx;
    self.docView.lineSize = 1.f;
    [self.view addSubview:self.docView];
    self.docView.showMode=GSDocViewShowModeScaleAspectFit;
    self.docView.delegate  =self;
    _isAnnotationMode=NO;
    
    UIButton *btn=[UIButton new];
    [btn setTitle:@"切换输入" forState:UIControlStateNormal];
    btn.titleLabel.font=[UIFont systemFontOfSize:18];
    [btn sizeToFit];
    btn.center=self.docView.center;
    btn.gs_y=self.docView.gs_y+self.docView.gs_height+20;
    [self.view addSubview:btn];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn addTarget:self action:@selector(selected) forControlEvents:UIControlEventTouchUpInside];
    [self taggingMarkView];
    
    UILabel *lable=[UILabel new];
    lable.frame=CGRectMake(0, btn.gs_y+btn.gs_height+20, Width, 50);
    lable.backgroundColor=[UIColor redColor];
    lable.textColor=[UIColor blackColor];
    lable.textAlignment=NSTextAlignmentCenter;
    _lable=lable;
    [self.view addSubview:lable];
}


-(void)selected{
    [UIAlertController showActionSheetInViewController:self withTitle:@"选择模式" message:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"手写",@"触屏",@"手写+触屏"] popoverPresentationControllerBlock:nil tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        if (buttonIndex==2) {//手写
            _doubleEnable=NO;
            self.docView.isAnnomationMode=NO;
//            //接受到点回调
            [[GSRobotBoardManager sharedRobotBoardManager] setRecevicePointInfo:^(RobotPenPoint *point) {
                [self robotPenDraw:point];
            }];
//            [[GSRobotBoardManager sharedRobotBoardManager] setReceviceUtilPointInfo:^(RobotPenUtilPoint *utilPoint) {
//                    [self robotPenDrawUtilPoint:utilPoint];
//            }];
        }else if (buttonIndex==3){//触屏
            _doubleEnable=NO;
            self.docView.isAnnomationMode=YES;
            self.docView.docAnnoType=GSDocumentAnnoTypePointEx;
        }else if(buttonIndex==4){//触屏+手写
            self.docView.docAnnoType=GSDocumentAnnoTypeFreePenEx;
            self.docView.isAnnomationMode=YES;
            _doubleEnable=YES;
            //接受到点回调
            [[GSRobotBoardManager sharedRobotBoardManager] setRecevicePointInfo:^(RobotPenPoint *point) {
                [self robotPenDraw:point];
            }];
//            [[GSRobotBoardManager sharedRobotBoardManager] setReceviceUtilPointInfo:^(RobotPenUtilPoint *utilPoint) {
//                [self robotPenDrawUtilPoint:utilPoint];
//            }];
        }
    }];
}
-(void)robotPenDrawUtilPoint:(RobotPenUtilPoint *)point{
    //将场景显示区域移动到中心位置
    CGPoint pagePoint=CGPointMake(point.optimizeX, point.optimizeY);
    CGPoint tempPoint=pagePoint;
    tempPoint.x+=_offsetx;
    pagePoint=tempPoint;
    _lable.text=[NSString stringWithFormat:@"x---%lf   y----%lf",pagePoint.x,pagePoint.y];
    switch (point.touchState) {
        case RobotPenPointFloat:
            /** 悬浮状态**/
            self.docView.docAnnoType=GSDocumentAnnoTypePointExNoSend;
            [self.docView annoTouchBegin:pagePoint];
            break;
            /** 离开感应范围 **/
        case RobotPenPointLeave:
            self.docView.docAnnoType=GSDocumentAnnoTypePointExNoSend;
            [self.docView annoTouchCancelled:pagePoint];
            if (_doubleEnable) {
                self.docView.docAnnoType=GSDocumentAnnoTypeFreePenEx;
            }
            break;
            /** touchBegin状态 **/
        case RobotPenPointTouchBegin:
            if (self.docView.docAnnoType == GSDocumentAnnoTypePointExNoSend) {
                [self.docView annoTouchEnded:pagePoint];
            }
            
            self.docView.docAnnoType=GSDocumentAnnoTypeFreePenEx;
            [self.docView annoTouchBegin:pagePoint];
            break;
            /** touchMove状态**/
        case RobotPenPointTouchMove:
            if (self.docView.docAnnoType == GSDocumentAnnoTypePointExNoSend) {
                [self.docView annoTouchEnded:pagePoint];
            }
            self.docView.docAnnoType=GSDocumentAnnoTypeFreePenEx;
            [self.docView annoTouchMoved:pagePoint];
            break;
            /** touchEnd状态 **/
        case RobotPenPointTouchEnd:
            if (self.docView.docAnnoType == GSDocumentAnnoTypePointExNoSend) {
                [self.docView annoTouchEnded:pagePoint];
            }
            self.docView.docAnnoType=GSDocumentAnnoTypeFreePenEx;
            [self.docView annoTouchEnded:pagePoint];
            break;
        default:
            break;
    }
}
-(void)robotPenDraw:(RobotPenPoint *)point
{
    CGPoint pagePoint=[point getScenePointWithSceneWidth:_secenseSize.width SceneHeight:_secenseSize.height IsHorizontal:NO];
    lastP=pagePoint;
    //将场景显示区域移动到中心位置
    CGPoint tempPoint=pagePoint;
    tempPoint.x+=_offsetx;
    pagePoint=tempPoint;
    NSLog(@"%lf---x,%lf-y",pagePoint.x,pagePoint.y);
    _lable.text=[NSString stringWithFormat:@"x---%lf   y----%lf",pagePoint.x,pagePoint.y];
        switch (point.touchState) {
            case RobotPenPointFloat:
                /** 悬浮状态**/
                self.docView.docAnnoType=GSDocumentAnnoTypePointExNoSend;
                [self.docView annoTouchBegin:pagePoint];
                break;
                /** 离开感应范围 **/
            case RobotPenPointLeave:
                self.docView.docAnnoType=GSDocumentAnnoTypePointExNoSend;
                [self.docView annoTouchCancelled:pagePoint];
                if (_doubleEnable) {
                    self.docView.docAnnoType=GSDocumentAnnoTypeFreePenEx;
                }
                break;
                /** touchBegin状态 **/
            case RobotPenPointTouchBegin:
                if (self.docView.docAnnoType == GSDocumentAnnoTypePointExNoSend) {
                    [self.docView annoTouchEnded:pagePoint];
                }
                
                self.docView.docAnnoType=GSDocumentAnnoTypeFreePenEx;
                [self.docView annoTouchBegin:pagePoint];
                break;
                /** touchMove状态**/
            case RobotPenPointTouchMove:
                self.docView.docAnnoType=GSDocumentAnnoTypeFreePenEx;
                [self.docView annoTouchMoved:pagePoint];
                break;
                /** touchEnd状态 **/
            case RobotPenPointTouchEnd:
                self.docView.docAnnoType=GSDocumentAnnoTypeFreePenEx;
                [self.docView annoTouchEnded:pagePoint];
                break;
            default:
                break;
        }
}

#pragma mark -
#pragma mark GSBroadcastRoomDelegate

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
    
    if (joinResult == GSBroadcastJoinResultSuccess)
    {
        BOOL a = [_broadcastManager setBroadcastInfo:@"user.rostrum" value:userID];
        NSLog(@"%d", a);
    }else
    {
        NSLog(@"Error");
    }
    
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
#pragma mark - Docview Delegate


#pragma mark GSBroadcastDocDelegate
// 文档模块连接代理
- (void)broadcastManager:(GSBroadcastManager*)manager didReceiveDocModuleInitResult:(BOOL)result
{
}

// 文档切换代理
- (void)broadcastManager:(GSBroadcastManager *)manager didSlideToPage:(unsigned int)pageID ofDoc:(unsigned int)docID step:(int)step
{
    
  
    
}

- (void)broadcastManager:(GSBroadcastManager*)manager didFinishLoadingPage:(GSDocPage*)page ofDoc:(unsigned int)docID;
{
    if (CGRectEqualToRect(_orRect,CGRectZero)) {
        //doc  (origin = (x = 0, y = 120), size = (width = 375, height = 333.5))
        //获取标注的总场景区域
        _orRect=self.docView.annoRect;
        //anno  (origin = (x = 0, y = 26.125), size = (width = 375, height = 281.25))
        
        //设置电磁板的原点的方向
        //左上角为坐标原点
        [[RobotPenManager sharePenManager] setTransformsPointWithType:RobotPenCoordinateLowerLeft];
        //获取电磁板的宽高比
        _rot=[[RobotPenManager sharePenManager] getDeviceScaleWithDeviceType:T9B andIsHorizontal:NO];
        
        //根据电磁板的宽高比确定显示场景
        _secenseSize=CGSizeMake(_orRect.size.height *_rot, _orRect.size.height);
        //计算偏移量
        _offsetx=(_orRect.size.width-_secenseSize.width)*0.5;
#if 0
        //优化点配置
        [[RobotPenManager sharePenManager] setSceneSizeWithWidth:_secenseSize.width andHeight:_secenseSize.height andIsHorizontal:NO];
        //开启上报优化笔记
        [[RobotPenManager sharePenManager] setOrigina:NO optimize:YES transform:NO];
        //设置笔记的宽度
        [[RobotPenManager sharePenManager] setStrokeWidth:1.2];
#endif

    }
}

- (IBAction)publishDoc:(id)sender {
    
    UIImagePickerController* imageController = [[UIImagePickerController alloc] init];
    imageController.delegate = self;
    imageController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imageController.allowsEditing = NO;
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Camera is unavailable on your device" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alertView show];
        
        return;
    }
    imageController.sourceType = sourceType;
    [self presentModalViewController:imageController animated:YES];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    
    UIImage* imageItem;
    
    if ([mediaType isEqualToString:@"public.image"]){
        
        imageItem= [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    if(imageItem == nil)
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:@"选择图片失败,请重新选择" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    
    
    
    unsigned int m_docId= [self.broadcastManager publishDocOpen:@"example"];
    unsigned int pageHandle=0;
    
    CGFloat imageH= imageItem.size.height;
    CGFloat imageW= imageItem.size.width;
    
    int bitCounts=32;
    NSString* titleText=@"example";
    NSString* fullText=@"example";
    
    NSString* aniCfg=@"";
    NSString* pageComment=@"";
    
    
    NSData *imageData = UIImageJPEGRepresentation([self scaleAndRotateImage: imageItem],0.93);
    
    
    
    BOOL isSuccess=   [self.broadcastManager publishDocTranslataData:m_docId pageHandle:pageHandle pageWidth:imageW pageHeight:imageH bitCounts:bitCounts titleText:titleText fullText:fullText aniCfg:aniCfg pageComment:pageComment data:imageData];
    
    
    [self.broadcastManager publishDocTranslateEnd:m_docId bSuccess:isSuccess];
    
    
    [self.broadcastManager publishDocGotoPage:m_docId pageId:0 sync2other:YES];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (UIImage *)scaleAndRotateImage:(UIImage *)image {
    
    int kMaxResolution = 640; // Or whatever
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = roundf(bounds.size.width / ratio);
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = roundf(bounds.size.height * ratio);
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return imageCopy;
}
#pragma mark -
#pragma mark System Default Code
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    NSLog(@"*********dealloc************");
}
@end
