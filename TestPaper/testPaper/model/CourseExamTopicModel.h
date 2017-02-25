//
//  CourseExamTopicModel.h
//  IntlEducation
//
//  Created by lilei on 16/12/21.
//  Copyright © 2016年 lqwawa. All rights reserved.
//


@interface CourseExamTopicModel : NSObject

@property (nonatomic, assign) int Id;//题目的Id
@property (nonatomic, assign) int itemNum;//选项数
@property (nonatomic,copy) NSString *itemA;
@property (nonatomic,copy) NSString *itemB;
@property (nonatomic,copy) NSString *itemC;
@property (nonatomic,copy) NSString *itemD;
@property (nonatomic,copy) NSString *itemE;
@property (nonatomic,copy) NSString *itemF;
@property (nonatomic,copy) NSString *itemG;
@property (nonatomic,copy) NSString *itemH;
@property (nonatomic,copy) NSString *itemI;
@property (nonatomic,copy) NSString *itemJ;
@property (nonatomic, assign) int score;//本题分数
@property (nonatomic,copy) NSString *answer;//正确答案
@property (nonatomic,copy) NSString *userAnswer;//用户答案

@property (nonatomic,copy) NSString *question;//问题
@property (nonatomic,copy) NSString *remark;//提示
@property (nonatomic, assign) int exerciseType;// 1单选 2 多选 3判断 4问答


@end


