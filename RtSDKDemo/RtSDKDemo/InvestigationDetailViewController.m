//
//  InvestigationDetailViewController.m
//  iOSDemo
//
//  Created by Gaojin Hsu on 5/19/15.
//  Copyright (c) 2015 gensee. All rights reserved.
//

#import "InvestigationDetailViewController.h"

@interface InvestigationDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)UITableView *choiceTableView;

@property (nonatomic, strong)UIButton *submitButton;

@property (nonatomic, strong)NSMutableArray *myAnswers;

@end

@implementation InvestigationDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.investigation.theme;
    
    self.myAnswers = [NSMutableArray array];
    
    [self setUpTableView];
    
    [self setUpButton];
    
    
    
}

- (void)setUpButton
{
    self.submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.submitButton];
    [self.submitButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.submitButton setTitle: NSLocalizedString(@"Submit", nil) forState:UIControlStateNormal];
    
    self.submitButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSArray *consV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_submitButton(40)]-5-|" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_submitButton)];
    [self.view addConstraints:consV];
    
    NSArray *consH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_submitButton(80)]" options:0 metrics:0 views:NSDictionaryOfVariableBindings(_submitButton)];
    [self.view addConstraints:consH];
    
    NSLayoutConstraint *cons = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.submitButton attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    [self.view addConstraint:cons];
    
    [self.submitButton addTarget:self action:@selector(submitInvestigation:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setUpTableView
{
    double version = [[UIDevice currentDevice].systemVersion doubleValue];//判定系统版本。
    if (version < 7.0) {
        // iOS 6 code
        self.choiceTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height  - 44 - 50)];
    }
    else if (version < 8.0)
    {
        // iOS 7 code
        self.choiceTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64 - 50)];
    }
    else
    {
        // iOS8 code
        self.choiceTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 50 - 64)];
    }
    
    [self.view addSubview:self.choiceTableView];
    self.choiceTableView.delegate = self;
    self.choiceTableView.dataSource = self;
    
}

#pragma mark -
#pragma mark Actions

- (void)submitInvestigation:(id)sender
{
    for (int i = 0; i < self.investigation.questions.count; i ++)
    {
        GSInvestigationQuestion *que = self.investigation.questions[i];
        for (int j = 0; j < que.options.count; j++) {
            GSInvestigationOption *option = que.options[j];
            if (option.isSelected) {
                GSInvestigationMyAnswer *myAnswer = [GSInvestigationMyAnswer new];
                myAnswer.questionID = que.ID;
                myAnswer.optionID = option.ID;
                [self.myAnswers addObject:myAnswer];
            }
        }
    }
    
    
    if ([self.broadcastManager submitInvestigation:self.investigation.ID answers:self.myAnswers]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"SubmitSuccess", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
        [alertView show];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"SubmitFailed", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
        [alertView show];

    }
}

#pragma mark -
#pragma mark UITableView Delegate/DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.investigation.questions.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    GSInvestigationQuestion *que = (GSInvestigationQuestion*)self.investigation.questions[section];

    if (que.questionType == GSInvestigationQuestionTypeEssay) {
        
        return 0;
    }
    else
    {
        return que.options.count;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    GSInvestigationQuestion *que = (GSInvestigationQuestion*)self.investigation.questions[indexPath.section];
    
    if (que.questionType != GSInvestigationQuestionTypeEssay) {
        
        GSInvestigationOption *option = que.options[indexPath.row];
        
        cell.textLabel.text = option.content;
        
        if (option.isSelected) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GSInvestigationQuestion *que = (GSInvestigationQuestion*)self.investigation.questions[indexPath.section];
    
    if (que.questionType == GSInvestigationQuestionTypeMultiChoice) {
        
        GSInvestigationOption *option = que.options[indexPath.row];

        if (option.isSelected) {
            
            option.isSelected = NO;
            
            [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;

        }
        else
        {
            
            option.isSelected = YES;
            
            [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;

        }
    }
    else if (que.questionType == GSInvestigationQuestionTypeSingleChoice) {
        
        GSInvestigationOption *option = que.options[indexPath.row];
        
        if (option.isSelected) {
            
            option.isSelected = NO;
            
            [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
            
        }
        else
        {
            
            // 单选题，只能同时选择一个答案
            for (int i = 0; i < que.options.count; i++) {
                
                GSInvestigationOption *tempOption = que.options[i];

                if (i == indexPath.row) {
                    
                    tempOption.isSelected = YES;
                    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
                    NSLog(@"cell %d  checked.", i);

                }
                else
                {
                    tempOption.isSelected = NO;
                    
                    NSIndexPath *otherIndexPath = [NSIndexPath indexPathForRow:i inSection:indexPath.section];
                    
                    [tableView cellForRowAtIndexPath:otherIndexPath].accessoryType = UITableViewCellAccessoryNone;
                    
                    NSLog(@"cell %d  unChecked.", i);

                }
            }
            
        }
    }

}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.choiceTableView.frame.size.width, 40)];
    UILabel *label = [[UILabel alloc]initWithFrame:view.bounds];
    [view addSubview:label];
    GSInvestigationQuestion *que = (GSInvestigationQuestion*)self.investigation.questions[section];
    NSString *tip;
    if (que.questionType == GSInvestigationQuestionTypeMultiChoice) {
        tip = NSLocalizedString(@"Multi", @"多选");
    }
    else if (que.questionType == GSInvestigationQuestionTypeSingleChoice)
    {
        tip = NSLocalizedString(@"Single", @"单选");
    }
    
    label.text = [NSString stringWithFormat:@"(%@) %@", tip, que.content];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}


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

@end
