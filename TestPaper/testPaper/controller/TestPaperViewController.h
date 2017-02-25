//
//  TestPaperViewController.h
//  IntlEducation
//
//  Created by lilei on 16/12/21.
//  Copyright © 2016年 lqwawa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestPaperViewController : UIViewController

@property (nonatomic, assign) NSInteger CourseExamId;

@property (nonatomic, assign) NSInteger defautIndex;

@property (nonatomic, assign) NSInteger type;//0:未做   1、做过了

@property (nonatomic,strong) NSMutableArray *dataSource;

@end
