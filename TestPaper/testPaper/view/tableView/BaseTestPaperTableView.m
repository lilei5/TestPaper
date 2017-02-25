//
//  BaseTestPaperTableView.m
//  IntlEducation
//
//  Created by lilei on 16/12/21.
//  Copyright © 2016年 lqwawa. All rights reserved.
//

#import "BaseTestPaperTableView.h"
#import "CourseExamTopicModel.h"


@interface BaseTestPaperTableView ()




@end


@implementation BaseTestPaperTableView


- (NSArray *)answerList{
    if (!_answerList) {
        _answerList = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",];
    }
    return _answerList;

}

- (NSArray *)questionList{
    if (!_questionList) {
        _questionList =  @[NONullString(_model.itemA),NONullString(_model.itemB),NONullString(_model.itemC),NONullString(_model.itemD),NONullString(_model.itemE),NONullString(_model.itemF),NONullString(_model.itemG),NONullString(_model.itemH),NONullString(_model.itemI),NONullString(_model.itemJ)];
    }
    return _questionList;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self registerCell];
//        self.delegate = self;
//        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}



- (void)config:(CourseExamTopicModel *)model  hasFooter:(BOOL)hasFooter index:(NSInteger)index{

    self.model = model;
    self.canEdit = !hasFooter;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    UILabel *numLb = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 0, 0)];
    numLb.text = [@(index+1).description stringByAppendingString:@"."];
    [numLb sizeToFit];
    [headerView addSubview:numLb];
    
    UILabel *typeLb = [[UILabel alloc] initWithFrame:CGRectMake(numLb.right+5, 0, 50, 25)];
    typeLb.centerY = numLb.centerY;
    typeLb.textAlignment = NSTextAlignmentCenter;
    typeLb.textColor = [UIColor whiteColor];
    typeLb.backgroundColor = RGB(85, 207, 226);
    NSArray *types = @[@"单选",@"多选",@"判断",@"简答"];
    typeLb.text = types[model.exerciseType-1];
    [headerView addSubview:typeLb];
    
    UILabel *scoreLb = [[UILabel alloc] initWithFrame:CGRectMake(typeLb.right+5, 0, 0, 0)];
    scoreLb.text = [NSString stringWithFormat:@"(%d分)",model.score];
    [scoreLb sizeToFit];
    scoreLb.centerY = typeLb.centerY;
    [headerView addSubview:scoreLb];
    
    
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(10, typeLb.bottom + 10, SCREEN_WIDTH - 20, 0)];
    titleLb.numberOfLines = 0;
    titleLb.text = model.question;
    [titleLb sizeToFit];
    [headerView addSubview:titleLb];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(8, titleLb.bottom + 10, SCREEN_WIDTH - 16, 1)];
    line.backgroundColor = kHomeColor;
    [headerView addSubview:line];
    
    headerView.height = line.bottom + 10;
    self.tableHeaderView = headerView;
    
    
    if (hasFooter) {
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(8, 20, footView.width -16, 1)];
        lineView.backgroundColor = kHomeColor;
        [footView addSubview:lineView];
        
        UILabel *messageLb = [[UILabel alloc] initWithFrame:CGRectMake(10, lineView.bottom+10, footView.width-20, 0)];
        messageLb.numberOfLines = 0;
        BOOL hasFoot = YES;
        if (self.model.exerciseType == 4) {//问答题
     
            
            messageLb.text = @"待审批";
            messageLb.textColor = [UIColor redColor];
            
            [messageLb sizeToFit];

        }else{
           
            if (model.userAnswer.length > 0) {
                if ([model.userAnswer isEqualToString:self.model.answer]) {//答案正确
                    self.isRight = YES;
                    messageLb.text = [NSString stringWithFormat:@"正确答案：%@  你选对了",self.model.answer];
                    [messageLb sizeToFit];
                    messageLb.textColor =  RGB(152, 207, 90);
                }else{
                    self.isRight = NO;
                    messageLb.text = [NSString stringWithFormat:@"正确答案：%@  你错选为%@",self.model.answer,model.userAnswer];
                    [messageLb sizeToFit];
                    messageLb.textColor = [UIColor redColor];
                }
                
            }else{
                self.isRight = NO;
                messageLb.text = [NSString stringWithFormat:@"正确答案：%@  你未作答",self.model.answer];
                [messageLb sizeToFit];
                messageLb.textColor = [UIColor redColor];
            }
            
          
        }
        [footView addSubview:messageLb];
        
        
        UILabel *scoreLb = [[UILabel alloc] initWithFrame:CGRectMake(10, messageLb.bottom + 10, footView.width-20, 0)];
        scoreLb.textColor = [UIColor darkGrayColor];
        UITextView *remarkLb = nil;
        if (!hasFoot) {
            scoreLb.text = @"";
            [scoreLb sizeToFit];
        }else{
            if (self.isRight) {
                 scoreLb.text = [NSString stringWithFormat:@"得分：%i分",self.model.score];
            }else{
                 scoreLb.text = @"得分：0分";
            }
           
            [scoreLb sizeToFit];
            
            //  答案解析
            remarkLb = [[UITextView alloc] initWithFrame:CGRectMake(10, scoreLb.bottom+10, footView.width-20, 100)];
            NSString *text = [NSString stringWithFormat:@"题目解析：%@",NONullString(self.model.remark)];
            remarkLb.text = text;
            remarkLb.textColor = [UIColor darkGrayColor];
            remarkLb.font = [UIFont systemFontOfSize:17];
            remarkLb.editable = NO;
            CGFloat remarkH = [remarkLb sizeThatFits:CGSizeMake(footView.width-20, MAXFLOAT)].height;
            ViewBorderRadiusColor(remarkLb, 5, 1, kHomeColor);
            remarkLb.height = MAX(remarkH, 100);
            [footView addSubview:remarkLb];
            


        }
        
        [footView addSubview:scoreLb];
        
        footView.height =  MAX(scoreLb.bottom, remarkLb.bottom)  + 10;
        
        self.tableFooterView = footView;
        

    }
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}


@end
