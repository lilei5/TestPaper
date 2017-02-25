//
//  TestPaperViewController.m
//  IntlEducation
//
//  Created by lilei on 16/12/21.
//  Copyright © 2016年 lqwawa. All rights reserved.
//

#import "TestPaperViewController.h"

#import "SingleSelectionTableView.h"
#import "MultiSelectionTableView.h"
#import "EssayquestionTableView.h"
#import "TestPaperResultController.h"
#import "CourseExamTopicModel.h"
#import "UIAlertView+Blocks.h"

#define kBottomH  60.0f

@interface TestPaperViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) UIButton *leftBtn;
@property (nonatomic,strong) UIButton *rightBtn;

@property (nonatomic, assign) NSInteger currentIndex;


@end

@implementation TestPaperViewController

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentIndex = self.defautIndex;
    
    [self setupData];

    [self setupCollectionView];
    [self setupLeftBtn];
    
    [self setupBottomView];
    
   
}

#pragma mark - InitData

- (void)setupData{
    
    if (self.type == 0) {
        NSDictionary *dataDic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"testData" ofType:@"plist" ]];
        for (NSDictionary *topicDic in dataDic[@"data"]) {
            CourseExamTopicModel *model = [[CourseExamTopicModel alloc] init];
            [model setValuesForKeysWithDictionary:topicDic];
            [self.dataSource addObject:model];
        }

    }
   
}

#pragma mark - UI

- (void)setupCollectionView{
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-64 - kBottomH);
    //确定水平滑动方向
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];

    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64 - kBottomH) collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.scrollEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    [self.view addSubview:self.collectionView];
    
    // 首次调用
     self.collectionView.contentOffset = CGPointMake(self.currentIndex*SCREEN_WIDTH, 0);
    self.title = [NSString stringWithFormat:@"%ld/%ld",self.currentIndex+1,self.dataSource.count];
}

- (void)setupBottomView{

    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 64 - kBottomH, SCREEN_WIDTH, kBottomH)];
    bottomView.backgroundColor = kHomeColor;
    [self.view addSubview:bottomView];
    
   
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [bottomView addSubview:self.rightBtn];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(bottomView);
        make.top.equalTo(bottomView).offset(1);
    }];
    self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    
    if (self.dataSource.count == 1) {//只有一题的情况
        [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.rightBtn setTitle:@"提交" forState:UIControlStateNormal];
        self.rightBtn.backgroundColor =  RGB(85, 207, 226);
          [self.rightBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [self.rightBtn setTitleColor:RGB(100, 100, 100) forState:UIControlStateNormal];
        [self.rightBtn setTitle:@"下一题" forState:UIControlStateNormal];
        self.rightBtn.backgroundColor = [UIColor whiteColor];
        [self.rightBtn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    
    self.leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [bottomView addSubview:self.leftBtn];
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(bottomView);
        make.top.equalTo(bottomView).offset(1);
        make.right.equalTo(self.rightBtn.mas_left).offset(-1);
    }];
    [self.leftBtn setTitleColor:RGB(100, 100, 100) forState:UIControlStateNormal];
    self.leftBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.leftBtn setTitle:@"上一题" forState:UIControlStateNormal];
    self.leftBtn.backgroundColor = [UIColor whiteColor];
    
    [self.leftBtn addTarget:self action:@selector(previous) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)setupLeftBtn{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 22, 44);
    [button addTarget:self action:@selector(popSelf) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"nav_backarrow_ico"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"nav_backarrow_pre_ico"] forState:UIControlStateHighlighted];
    UIBarButtonItem *leftBar =[[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftBar;

}

#pragma mark - Action
//提交答案
- (void)submit{
    
    [self _updateAnswers];
    __weak typeof(self) weakSelf = self;
    BOOL isDoAll = YES;//题目是否走做完
    for (CourseExamTopicModel *model in self.dataSource) {
        if (model.userAnswer.length == 0) {
            isDoAll = NO;
            break;
        }
    }
    
    if (!isDoAll) {
        [UIAlertView showWithTitle:nil message:@"有未做的题目是否确认提交?" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {//确定
                [weakSelf submitAnswer];
            }
        }];
    }else{
        [UIAlertView showWithTitle:nil message:@"提交后本次测验答案将不可修改，确定要提交?" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {//确定
                
                [weakSelf submitAnswer];
            }
        }];
    
    }
    
}


- (void)submitAnswer{
    TestPaperResultController *resultVc = [[TestPaperResultController alloc] init];
    resultVc.dataSource = self.dataSource;
    [self.navigationController pushViewController:resultVc animated:YES];
}

// 下一题
- (void)next{
    self.collectionView.contentOffset = CGPointMake((self.currentIndex + 1)*SCREEN_WIDTH, 0);
}
// 上一题
- (void)previous{
    self.collectionView.contentOffset = CGPointMake((self.currentIndex - 1)*SCREEN_WIDTH, 0);

}

- (void)popSelf{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - collectionView delegate&dataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    cell.backgroundColor = [UIColor cyanColor];
    CourseExamTopicModel *model = self.dataSource[indexPath.row];
    BaseTestPaperTableView *tableView = nil;
    if (model.exerciseType == 1) {//单选
        tableView = [[SingleSelectionTableView alloc] initWithFrame:CGRectZero];
        
    }else if (model.exerciseType == 2){
        tableView = [[MultiSelectionTableView alloc] initWithFrame:CGRectZero];
        
    }else if (model.exerciseType == 3){
    
       tableView = [[SingleSelectionTableView alloc] initWithFrame:CGRectZero];
        
    }else{
        
        tableView = [[EssayquestionTableView alloc] initWithFrame:CGRectZero];
        
    }
    tableView.frame = CGRectMake(0, 0,  self.collectionView.frame.size.width, self.collectionView.frame.size.height);
    [cell.contentView addSubview:tableView];
    
    if (self.type == 1) {//做过了  看题目
        [tableView config:model hasFooter:YES index:indexPath.item];
        tableView.tempAnswer = model.userAnswer;
        
    }else{
        [tableView config:model hasFooter:NO index:indexPath.item];
        tableView.tempAnswer = model.userAnswer;
    }
    
    
    return cell;

}


#pragma mark - scrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger index =  (scrollView.contentOffset.x+scrollView.frame.size.width*0.5)/scrollView.frame.size.width;
    //  index == self.defautIndex   为了点击某一题进入  更新底部按钮状态
    if (index != self.currentIndex || index == self.defautIndex) {//页面改变了
        // 这里设置成-1  为了index == self.defautIndex 失效
        self.defautIndex = -1;
        
        //  更新保存的答案
        [self _updateAnswers];
        
        self.currentIndex = index;

        self.title = [NSString stringWithFormat:@"%ld/%ld",self.currentIndex+1,self.dataSource.count];
        
        
        if (self.currentIndex == self.dataSource.count-1) {//最后一题
            
            if (self.type == 1) {//已提交则显示上一题
                [self.rightBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(SCREEN_WIDTH);
                }];
                
            }else{// 未提交显示提交
                [self _changeRightBtnStatusLeftMargin:SCREEN_WIDTH*0.4 title:NSLocalizedString(@"提交", nil) titleColor:[UIColor whiteColor] backColor:RGB(85, 207, 226) action:@selector(submit)];
            }
            
        }else if(self.currentIndex == 0){//第一题
            
             [self _changeRightBtnStatusLeftMargin:0 title:NSLocalizedString(@"下一题", nil) titleColor:RGB(100, 100, 100) backColor:[UIColor whiteColor] action:@selector(next)];
            
        }else{//中间题
            
            [self _changeRightBtnStatusLeftMargin:(SCREEN_WIDTH*0.5) title:NSLocalizedString(@"下一题", nil) titleColor:RGB(100, 100, 100) backColor:[UIColor whiteColor] action:@selector(next)];

        }
    }
    

}

#pragma mark - privite
- (void)_changeRightBtnStatusLeftMargin:(CGFloat)leftMargin title:(NSString *)title  titleColor:(UIColor *)titleColor backColor:(UIColor *)backColor action:(SEL)action{
    
    
    [self.rightBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.rightBtn.superview).offset(leftMargin);
    }];
    [self.rightBtn setTitleColor:titleColor forState:UIControlStateNormal];
    [self.rightBtn setTitle:title forState:UIControlStateNormal];
    self.rightBtn.backgroundColor = backColor;
    // 移除btn所有事件
    [[self.rightBtn allTargets] enumerateObjectsUsingBlock: ^(id object, BOOL *stop) {
        [self.rightBtn removeTarget:object action:NULL forControlEvents:UIControlEventAllEvents];
    }];
    [self.rightBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];

}
#pragma mark 更新暂存的答案
- (void)_updateAnswers{

    for (UICollectionViewCell *cell in [self.collectionView visibleCells]) {
        
        BaseTestPaperTableView *tableView = cell.contentView.subviews[0];
        
        [self.dataSource enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(CourseExamTopicModel *model, NSUInteger idx, BOOL * _Nonnull stop) {

            if (model.Id == [tableView.answer[@"exerId"] intValue]) {
                model.userAnswer = tableView.answer[@"answer"];
            }
            
        }];
        
    }

}


@end
