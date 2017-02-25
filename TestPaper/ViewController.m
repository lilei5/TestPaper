//
//  ViewController.m
//  TestPaper
//
//  Created by lilei on 17/2/23.
//  Copyright © 2017年 lilei. All rights reserved.
//

#import "ViewController.h"
#import "TestPaperViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:btn];
    [btn setTitle:@"开始做题" forState:UIControlStateNormal];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    [btn addTarget:self action:@selector(beginTest:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)beginTest:(UIButton *)btn {
    
    TestPaperViewController *testPaperVc = [[TestPaperViewController alloc] init];
    
    [self.navigationController pushViewController:testPaperVc animated:YES];
 
      
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
