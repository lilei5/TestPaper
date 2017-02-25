//
//  EssayquestionTableView.m
//  IntlEducation
//
//  Created by lilei on 16/12/22.
//  Copyright © 2016年 lqwawa. All rights reserved.
//

#import "EssayquestionTableView.h"
#import "HYTextView.h"
#import "CourseExamTopicModel.h"

@interface EssayquestionTableView ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>


//@property (nonatomic,strong) CourseExamTopicModel *model;
//@property (nonatomic,strong) CourseExamTopicModel *userAnswer;
@property (nonatomic,strong) HYTextView *textView;
@property (nonatomic,copy) NSString *uAnswer;


@end


@implementation EssayquestionTableView

-(void)config:(CourseExamTopicModel *)model hasFooter:(BOOL)hasFooter index:(NSInteger)index{
    [super config:model hasFooter:hasFooter index:index];//调用父类方法  设置通用设置
    self.model = model;
//    self.userAnswer = data.uexer;
    self.delegate = self;
    self.dataSource = self;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"id";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        HYTextView *textView = [[HYTextView alloc] initWithFrame:CGRectZero];
        self.textView = textView;
        if (self.uAnswer.length>0) {
            self.textView.text = self.uAnswer;
        }
        textView.delegate = self;
        [cell.contentView addSubview:textView];
        [textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(15);
            make.top.equalTo(10);
            make.right.equalTo(-15);
            make.bottom.equalTo(-15);
        }];
        ViewBorderRadiusColor(textView, 0, 1, kHomeColor);
        textView.placeholder = @"请输入答案";
        textView.font = [UIFont systemFontOfSize:17];
        textView.placeholderFont = [UIFont systemFontOfSize:17];
        textView.backgroundColor = RGB(242, 242, 242);
        if (!self.canEdit) {
            textView.editable = NO;
        }
    }
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 200.0f;
}


- (void)setTempAnswer:(NSString *)tempAnswer{
    if (tempAnswer.length == 0)
        return;
    
    self.uAnswer = tempAnswer;
    
    [self reloadData];
}

-(NSDictionary *)answer{
    if (self.textView.text.length>0) return  @{@"exerId":@(self.model.Id),@"answer":self.textView.text};
    return @{@"exerId":@(self.model.Id),@"answer":@""};
    
}




@end
