//
//  GSVodQueueController.m
//  VodSDKDemo
//
//  Created by Sheng on 2018/8/24.
//  Copyright © 2018年 Gensee. All rights reserved.
//

#import "GSVodQueueController.h"
#import "GSVodQueueCell.h"
#import "GSVodPlayerController.h"

@interface GSVodQueueController () <UICollectionViewDelegate,UICollectionViewDataSource,GSVodQueueCellDelegate,GSVodManagerDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *data;

@end

@implementation GSVodQueueController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"历史记录";
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(Width, 100);
    flowLayout.minimumInteritemSpacing = 0;
    
    // Do any additional setup after loading the view.
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, Width, Height - 64) collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_collectionView];
    
    [_collectionView registerClass:[GSVodQueueCell class] forCellWithReuseIdentifier:reuserIdentifier];
    
    NSArray *items = [[VodManage shareManage] getListDownItem];
    
    self.data = [NSMutableArray arrayWithArray:items];
    
    [GSVodManager sharedInstance].delegate = self;
    [GSVodManager sharedInstance].isAutoDownload = YES;
}

static NSString *reuserIdentifier = @"queueCell";

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GSVodQueueCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuserIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    downItem *item = self.data[indexPath.row];
    cell.item = item;
    return cell;
}

- (void)vodQueueCell:(GSVodQueueCell *)cell didDelete:(NSString *)strDownloadId
{
    for(downItem *item in self.data)
    {
        if([item.strDownloadID isEqualToString:strDownloadId])
        {
            [self.data removeObject:item];
            [self.collectionView reloadData];
            break;
        }
    }
}

- (void)vodQueueCell:(GSVodQueueCell*)cell didClickButton:(int)index{
    if([self.data count] <= 0)
       {
        return;
    }
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    downItem *item = self.data[indexPath.row];
    if (index == 3) {
        GSVodPlayerController *player = [[GSVodPlayerController alloc] init];
        player.item = item;
        player.isOnline = YES;
        [self.navigationController pushViewController:player animated:YES];
    }else if (index == 2) {
        GSVodPlayerController *player = [[GSVodPlayerController alloc] init];
        player.item = item;
        player.isOnline = NO;
        [self.navigationController pushViewController:player animated:YES];
    }
}

//开始下载
- (void)vodManager:(GSVodManager *)manager downloadBegin:(downItem *)item {
    [self.collectionView reloadData];
}
//下载进度
- (void)vodManager:(GSVodManager *)manager downloadProgress:(downItem *)item percent:(float)percent {
    __block int i = -1;
    item.percent = percent/100;
    [self.data enumerateObjectsUsingBlock:^(downItem* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.strDownloadID isEqualToString:item.strDownloadID]) {
            i = (int)idx;
            *stop = YES;
        }
    }];
    if (i == -1) {
        return;
    }
    [self.data replaceObjectAtIndex:i withObject:item];
    [self.collectionView reloadData];
}
//下载暂停
- (void)vodManager:(GSVodManager *)manager downloadPause:(downItem *)item {
    __block int i = -1;
    
    [self.data enumerateObjectsUsingBlock:^(downItem* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.strDownloadID isEqualToString:item.strDownloadID]) {
            i = (int)idx;
            *stop = YES;
        }
    }];
    if (i == -1) {
        return;
    }
    [self.data replaceObjectAtIndex:i withObject:item];
    [self.collectionView reloadData];
}
//下载停止
- (void)vodManager:(GSVodManager *)manager downloadStop:(downItem *)item {
    __block int i = -1;
    [self.data enumerateObjectsUsingBlock:^(downItem* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.strDownloadID isEqualToString:item.strDownloadID]) {
            i = (int)idx;
            *stop = YES;
        }
    }];
    if (i == -1) {
        return;
    }
    [self.data replaceObjectAtIndex:i withObject:item];
    [self.collectionView reloadData];
}
//下载完成
- (void)vodManager:(GSVodManager *)manager downloadFinished:(downItem *)item {
    __block int i = -1;
    [self.data enumerateObjectsUsingBlock:^(downItem* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.strDownloadID isEqualToString:item.strDownloadID]) {
            i = (int)idx;
            *stop = YES;
        }
    }];
    if (i == -1) {
        return;
    }
    [self.data replaceObjectAtIndex:i withObject:item];
    [self.collectionView reloadData];
}
//下载失败
- (void)vodManager:(GSVodManager *)manager downloadError:(downItem *)item state:(GSVodDownloadError)state {
    __block int i = -1;
    [self.data enumerateObjectsUsingBlock:^(downItem* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.strDownloadID isEqualToString:item.strDownloadID]) {
            i = (int)idx;
            *stop = YES;
        }
    }];
    if (i == -1) {
        return;
    }
    [self.data replaceObjectAtIndex:i withObject:item];
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
