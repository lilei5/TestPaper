//
//  MultiSelectionTableView.m
//  IntlEducation
//
//  Created by lilei on 16/12/22.
//  Copyright © 2016年 lqwawa. All rights reserved.
//

#import "MultiSelectionTableView.h"
#import "SingleSelectCell.h"
#import "CourseExamTopicModel.h"

@interface MultiSelectionTableView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableDictionary *rowHeightDic;

//@property (nonatomic,strong) CourseExamTopicModel *model;
//@property (nonatomic,strong) CourseExamTopicModel *userAnswer;

@property(nonatomic,strong) NSMutableArray *selectedArray;


@end


@implementation MultiSelectionTableView

- (NSMutableDictionary *)rowHeightDic{
    if (!_rowHeightDic) {
        _rowHeightDic = [NSMutableDictionary dictionary];
    }
    return _rowHeightDic;
}

- (NSMutableArray *)selectedArray{
    if (!_selectedArray) {
        _selectedArray = [NSMutableArray array];

    }
    return _selectedArray;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self registerNib:[UINib nibWithNibName:@"SingleSelectCell" bundle:nil] forCellReuseIdentifier:@"SingleSelectCell"];
    }
    return self;
}


- (void)config:(CourseExamTopicModel *)model  hasFooter:(BOOL)hasFooter index:(int)index{
    [super config:model hasFooter:hasFooter index:index];//调用父类方法  设置通用设置
//    CourseExamTopicModel *model = data.cexer;
//    self.model = model;
    self.delegate = self;
    self.dataSource = self;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.model.itemNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SingleSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SingleSelectCell" forIndexPath:indexPath];
    cell.contentLb.text = [NSString stringWithFormat:@"%@.%@",self.answerList[indexPath.row],self.questionList[indexPath.row]];
    
    [cell.btn setImage:ImageNamed(@"checkbox") forState:UIControlStateNormal];
    [cell.btn setImage:ImageNamed(@"checkbox_on") forState:UIControlStateSelected];

    if ([self.selectedArray containsObject:@(indexPath.row)]) {
        cell.btn.selected = YES;
    }else{
        cell.btn.selected = NO;

    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (!self.canEdit) return;
    
    if ([self.selectedArray containsObject:@(indexPath.row)]) {
        [self.selectedArray removeObject:@(indexPath.row)];
    }else{
        [self.selectedArray addObject:@(indexPath.row)];
    }
    
    [self reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSNumber *number = [self.rowHeightDic objectForKey:@(indexPath.row).description];
    
    if (number) {
        return number.floatValue;
    }else{
        CGFloat height = [self _getHeightWithStr:self.questionList[indexPath.row]];
        [self.rowHeightDic setValue:[NSNumber numberWithFloat:height] forKey:@(indexPath.row).description];
        return height;
    }
}

- (CGFloat)_getHeightWithStr:(NSString *)str{
    return  [self calculateStringHeight:str width:SCREEN_WIDTH - 10 -18 -5 -10 fontSize:17] + 15;
}

//  计算文字高度
- (CGFloat)calculateStringHeight:(NSString *)str width:(CGFloat)width fontSize:(CGFloat)size{
    
    return  [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]} context:nil].size.height;
    
}


- (void)setTempAnswer:(NSString *)tempAnswer{

    if (tempAnswer.length == 0)
        return;
    for(int i =0; i < [tempAnswer length]; i++)
    {
        NSString *str = [tempAnswer substringWithRange:NSMakeRange(i, 1)];
        NSInteger index =  [self.answerList indexOfObject:str];
        if (![self.selectedArray containsObject:@(index)]) {
            [self.selectedArray addObject:@(index)];
        }
    }
    
    [self reloadData];
}

-(NSDictionary *)answer{
    
    NSString *answer = @"";
    [self.selectedArray sortUsingSelector:@selector(compare:)];
    for (NSNumber *number in self.selectedArray) {
       answer =  [answer stringByAppendingString:self.answerList[number.intValue]];
    }
    if (answer.length>0) return  @{@"exerId":@(self.model.Id),@"answer":answer};
    return @{@"exerId":@(self.model.Id),@"answer":@""};
    
}

@end
