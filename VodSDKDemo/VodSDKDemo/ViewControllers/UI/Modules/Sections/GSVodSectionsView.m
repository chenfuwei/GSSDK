
#import "GSVodSectionsView.h"

@interface GSVodSectionsView () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end
@implementation GSVodSectionsView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self loadContent];
    }
    return self;
}


- (void)reloadView {
    [self.tableView reloadData];
}
static NSString *modelCellFlag = @"SectionTableViewCell";

- (void)loadContent{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    [self _setExtraCellLineHidden:_tableView];
    
//    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:modelCellFlag];
    
    [self addSubview:_tableView];
    
}

- (NSMutableArray *)dataModelArray
{
    if (!_dataModelArray) {
        _dataModelArray = [NSMutableArray array];
    }
    return _dataModelArray;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:modelCellFlag];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:modelCellFlag];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *item = [self.dataModelArray objectAtIndex:indexPath.row];
    NSArray *pages = [item objectForKey:@"pages"];
    NSString *title = [pages[0] objectForKey:@"title"];
    int time = [[pages[0] objectForKey:@"timestamp"] intValue];
    cell.textLabel.text = title;
    cell.detailTextLabel.text = [self timeFormat:time];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *item = [self.dataModelArray objectAtIndex:indexPath.row];
    NSArray *pages = [item objectForKey:@"pages"];
    int time = [[pages[0] objectForKey:@"timestamp"] intValue];
    [[GSVodManager sharedInstance].player seekTo:time];
}

- (NSString*)timeFormat:(int)time {
    int t = time;
    int hours = t/1000/60/60;
    int minutes = (t/1000/60)%60;
    int seconds = (t/1000)%60;
    if (hours) {
        return [NSString stringWithFormat:@"%02d:%02d:%02d",hours,minutes,seconds];
    }else{
        return [NSString stringWithFormat:@"%02d:%02d",minutes,seconds];
    }
    
}

#pragma mark - Utilities
-(void)_setExtraCellLineHidden:(UITableView *)tableView {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}
@end
