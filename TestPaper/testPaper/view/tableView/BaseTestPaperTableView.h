//
//  BaseTestPaperTableView.h
//  IntlEducation
//
//  Created by lilei on 16/12/21.
//  Copyright © 2016年 lqwawa. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CourseExamTopicModel;

@interface BaseTestPaperTableView : UITableView<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) NSArray *answerList;

@property(nonatomic,strong) NSArray *questionList;

// 答案字典
@property(nonatomic,copy) NSDictionary *answer;

//  默认选中的答案
@property (nonatomic,copy) NSString *tempAnswer;

//是否可编辑
@property (nonatomic, assign) BOOL canEdit;

// 回答的题目是否正确
@property (nonatomic, assign) BOOL isRight;


@property (nonatomic,strong) CourseExamTopicModel *model;


/**
 

 */

/**
 通用设置  子类实现必须调用super

 @param model      数据模型
 @param hasFooter 有无尾视图
 @param index     第几题
 */
- (void)config:(CourseExamTopicModel *)model  hasFooter:(BOOL)hasFooter index:(NSInteger)index;

- (void)showFootView;

@end
