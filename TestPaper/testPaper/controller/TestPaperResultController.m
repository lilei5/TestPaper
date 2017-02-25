////
////  TestPaperResultController.m
////  IntlEducation
////
////  Created by lilei on 16/12/23.
////  Copyright © 2016年 lqwawa. All rights reserved.
////
//
#import "TestPaperResultController.h"
#import "TestPaperViewController.h"
#import "CourseExamTopicModel.h"


#define kBottomH 50.0f

@interface TestPaperResultController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,strong) UITableView *tableView;


@end

@implementation TestPaperResultController


- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - kBottomH) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
    
}

#pragma mark - UI
- (void)setupUI{
    
    [self tableView];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 64 - kBottomH, SCREEN_WIDTH, kBottomH)];
    bottomView.backgroundColor = kHomeColor;
    [self.view addSubview:bottomView];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [bottomView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(bottomView);
        make.top.equalTo(bottomView).offset(1);
    }];
    btn.titleLabel.font = [UIFont systemFontOfSize:20];
    
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
  
    [btn setTitle:NSLocalizedString(@"查看答案解析", nil) forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor whiteColor];
    [btn addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];

}

- (void)btnClicked{
    TestPaperViewController *nextVc = [[TestPaperViewController alloc] init];
    nextVc.type = 1;
    nextVc.dataSource = self.dataSource;
    [self.navigationController pushViewController:nextVc animated:YES];

}



#pragma mark - tableView delegate&dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"id";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    CourseExamTopicModel *model = self.dataSource[indexPath.row];
    if (!cell) {
    
        cell =  [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
        cell.textLabel.textColor = [UIColor darkGrayColor];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%li、%@",indexPath.row+1,model.question];

    if (model.exerciseType == 4) {//主观题
        UILabel *acceLb = [[UILabel alloc] initWithFrame:CGRectZero];
        acceLb.textColor = [UIColor redColor];
        acceLb.text = @"未审批";
        [acceLb sizeToFit];
        acceLb.width = acceLb.width + 20;
        acceLb.textAlignment = NSTextAlignmentRight;
        
        cell.accessoryView = acceLb;
    }else{//客观题
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        if ([model.answer isEqualToString:model.userAnswer]) {
            
            imageView.image = ImageNamed(@"right");
        }else{
            imageView.image = ImageNamed(@"wrong");

        }
        cell.accessoryView = imageView;
        
    }
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TestPaperViewController *nextVc = [[TestPaperViewController alloc] init];
   
    nextVc.dataSource = self.dataSource;
    nextVc.defautIndex = indexPath.row;
    nextVc.type = 1;
    [self.navigationController pushViewController:nextVc animated:YES];

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0f;
}


@end
