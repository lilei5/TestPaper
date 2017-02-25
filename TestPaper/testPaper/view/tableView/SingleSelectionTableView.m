//
//  SingleSelectionTableView.m
//  IntlEducation
//
//  Created by lilei on 16/12/21.
//  Copyright © 2016年 lqwawa. All rights reserved.
//

#import "SingleSelectionTableView.h"
#import "SingleSelectCell.h"
#import "CourseExamTopicModel.h"

@interface SingleSelectionTableView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableDictionary *rowHeightDic;

@property (nonatomic,strong) CourseExamTopicModel *model;
//@property (nonatomic,strong) CourseExamTopicModel *userAnswer;

@property(nonatomic,assign) NSInteger selected;


@end


@implementation SingleSelectionTableView


- (NSMutableDictionary *)rowHeightDic{
    if (!_rowHeightDic) {
        _rowHeightDic = [NSMutableDictionary dictionary];
    }
    return _rowHeightDic;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.selected = -1;
        [self registerNib:[UINib nibWithNibName:@"SingleSelectCell" bundle:nil] forCellReuseIdentifier:@"SingleSelectCell"];
    }
    return self;
}


- (void)config:(CourseExamTopicModel *)model  hasFooter:(BOOL)hasFooter index:(NSInteger)index{
    [super config:model hasFooter:hasFooter index:index];//调用父类方法  设置通用设置
    self.model = model;

    
    self.delegate = self;
    self.dataSource = self;
 
//    [self reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.model.exerciseType == 3) return 2;
    
    return self.model.itemNum;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SingleSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SingleSelectCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentLb.text = [NSString stringWithFormat:@"%@.%@",self.answerList[indexPath.row],self.questionList[indexPath.row]];
    
    if (indexPath.row == self.selected) {
        if (!self.canEdit) {
            if (!self.isRight) {
                cell.contentLb.textColor = [UIColor redColor];
            }else{
                cell.contentLb.textColor = [UIColor darkGrayColor];
            }
            
        }
        cell.btn.selected = YES;
        
    }else{
        cell.btn.selected = NO;
    }
    
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.canEdit) {
        return;
    }
    
    self.selected = indexPath.row;
    
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
    _selected = [self.answerList indexOfObject:tempAnswer];
    [self reloadData];
}


-(NSDictionary *)answer{
   
    if (self.selected != -1) return  @{@"exerId":@(self.model.Id),@"answer":self.answerList[_selected]};
    return @{@"exerId":@(self.model.Id),@"answer":@""};
    
}


@end
