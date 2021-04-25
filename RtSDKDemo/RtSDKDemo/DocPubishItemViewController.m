//  DocPubishItemViewController.m
//  iOSDemo
//  Created by Gaojin Hsu on 6/27/16.
//  Copyright © 2016 gensee. All rights reserved.
#import "DocPubishItemViewController.h"
#import "MBProgressHUD.h"
#import <GSCommonKit/GSTagsContentView.h>
#define   BlackColor [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1]
#define   WhiteColor [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1]
#define   RedColor   [UIColor colorWithRed:255/255.0 green:0/255.0 blue:0/255.0 alpha:1]
#define   GreenColor [UIColor colorWithRed:0/255.0 green:255/255.0 blue:0/255.0 alpha:1]
#define   BlueColor  [UIColor colorWithRed:0/255.0 green:0/255.0 blue:255/255.0 alpha:1]

@interface DocPubishItemViewController()<GSBroadcastRoomDelegate, GSBroadcastDocumentDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate,GestureDocPanelViewDelegate>
@property (strong, nonatomic)GSBroadcastManager *broadcastManager;
@property(nonatomic,strong)UIImageView *tempImageView;
@property (strong, nonatomic)GSDocView *docView;
@property (strong, nonatomic)MBProgressHUD *progressHUD;
@property (strong, nonatomic) GSTagsContentView *tagView;
@property (strong, nonatomic) GSTagsContentView *lineTypeView;
/**是否标注模式*/
@property(assign,nonatomic)BOOL isAnnotationMode;
@property(assign,nonatomic)CGFloat originalY;
@end
@implementation DocPubishItemViewController
{
    struct {
        int isWhite : 1
    } _state;
}
#pragma mark -
-(UIImageView *)tempImageView{
    if (!_tempImageView) {
        _tempImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 200, 375, 200)];
        [self.view addSubview:_tempImageView];
    }
    return _tempImageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 注意下列代码的顺序
    [self setup];
    self.progressHUD = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:self.progressHUD];
    self.progressHUD.labelText = NSLocalizedString(@"BroadcastConnecting",  @"直播连接提示");
    [self.progressHUD show:YES];
    
    [self initBroadCastManager];
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithTitle:@"back" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = left;
    
}

- (void)back:(id)sender
{
    self.docView.hidden=YES;
    self.docView=nil;
    
    [self.progressHUD show:YES];
    self.progressHUD.labelText = @"Leaving...";
    [self.broadcastManager leaveAndShouldTerminateBroadcast:NO];
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
    
    self.docView = [[GSDocView alloc]initWithFrame:CGRectMake(0, y, self.view.frame.size.width, self.view.frame.size.height/2)];
    _originalY=y+self.view.frame.size.height/2;
    self.docView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.docView];
    self.docView.gSDocShowType=GSDocEqualHighType;
    self.docView.delegate  =self;
    _isAnnotationMode=NO;
    [self setupGestureDocPanelView];
    
    
    
}


-(void)setupGestureDocPanelView
{
    GSTagsContentView *tagView = [[GSTagsContentView alloc]initWithFrame:CGRectMake(15, _originalY + 15, [UIScreen mainScreen].bounds.size.width - 15, 44) tags:@[@"无标注",@"橡皮擦",@"圆标注",@"矩形标注",@"直线标注",@"加强版直线标注",@"加强版点标注",@"加强版自由笔标注"] handler:^(NSInteger index, NSString *text,BOOL isSelect) {
        NSLog(@"did click tag :%ld,%@",index,text);
        if (_lineTypeView) {
            [_lineTypeView removeFromSuperview];
        }
        switch (index) {
            case 0:
                [self setUpAnnotationMode:NO];
                [self.docView setDocAnnoType:GSDocumentAnnoTypeNull];
                break;
            case 1:
                [self setUpAnnotationMode:YES];
                [self.docView setDocAnnoType:GSDocumentAnnoTypeCleaner];
                return;
                break;
            case 2:
                [self setUpAnnotationMode:YES];
                [self.docView setDocAnnoType:GSDocumentAnnoTypeCircle];
                break;
            case 3:
                [self setUpAnnotationMode:YES];
                [self.docView setDocAnnoType:GSDocumentAnnoTypeRect];
                break;
            case 4:
                [self setUpAnnotationMode:YES];
                [self.docView setDocAnnoType:GSDocumentAnnoTypeLine];
                break;
            case 5:
                [self setUpAnnotationMode:YES];
                [self.docView setDocAnnoType:GSDocumentAnnoTypeLineEx];
                [self setlineTypeView];
                break;
            case 6:
                [self setUpAnnotationMode:YES];
                [self.docView setDocAnnoType:GSDocumentAnnoTypePointEx];
                break;
            case 7:
                [self setUpAnnotationMode:YES];
                [self.docView setDocAnnoType:GSDocumentAnnoTypeFreePenEx];
                break;
            default:
                break;
        }
    }];
    tagView.supportMultiSelect = NO;
    tagView.allowSelect = YES;
    tagView.selectIndex = 0;
    [self.view addSubview:tagView];
    _tagView = tagView;
    _originalY = _tagView.bottom + 5;
}

- (void)setlineTypeView {
    if (!_lineTypeView) {
        _lineTypeView = [[GSTagsContentView alloc]initWithFrame:CGRectMake(15, _originalY + 15, [UIScreen mainScreen].bounds.size.width - 15, 44) tags:@[@"普通",@"虚线",@"箭头"] handler:^(NSInteger index, NSString *text,BOOL isSelect) {
            NSLog(@"did click tag :%ld,%@",index,text);
            switch (index) {
                case 0:
                    self.docView.lineExType = 0;
                    break;
                case 1:
                    self.docView.lineExType = 1;
                    return;
                    break;
                case 2:
                    self.docView.lineExType = 2;
                    break;
                default:
                    break;
            }
        }];
        _lineTypeView.supportMultiSelect = NO;
        _lineTypeView.allowSelect = YES;
        _lineTypeView.selectIndex = 0;
    }
    
    [self.view addSubview:_lineTypeView];
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

#pragma mark GestureDocPanelViewDelegate


-(void)setUpAnnotationMode:(BOOL)isAnnotation
{
    
    _isAnnotationMode = isAnnotation;
    self.docView.showMode = GSDocViewShowModeScaleAspectFit;
    self.docView.isAnnomationMode = isAnnotation;
    _gestureDocPanelView.isOpenAnnotation = isAnnotation;
    
    if (_isAnnotationMode) {
    }else{
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


#pragma mark GSBroadcastDocDelegate
// 文档模块连接代理
- (void)broadcastManager:(GSBroadcastManager*)manager didReceiveDocModuleInitResult:(BOOL)result
{}

// 文档打开代理
- (void)broadcastManager:(GSBroadcastManager *)manager didOpenDocument:(GSDocument *)doc
{
    if (_state.isWhite) {
        [self.broadcastManager publishDocGotoPage:doc.docID pageId:0 sync2other:YES];
    }
}

// 文档关闭代理
- (void)broadcastManager:(GSBroadcastManager *)manager didCloseDocument:(unsigned int)docID
{}

// 文档切换代理
- (void)broadcastManager:(GSBroadcastManager *)manager didSlideToPage:(unsigned int)pageID ofDoc:(unsigned int)docID step:(int)step
{}
- (IBAction)publishWhiteDoc:(id)sender {
    _state.isWhite = 1;
    [self.broadcastManager publishDocNewWhiteboard:@"docTest" createOnce:NO];
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
