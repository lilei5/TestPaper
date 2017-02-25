//
//  HWTextView.h
//  TeacherGo
//
//  Created by Mr_ Jia on 15/4/2.
//  Copyright (c) 2015年 wangbin. All rights reserved.
//
//  增强：带有占位文字

#import <UIKit/UIKit.h>

@interface HYTextView : UITextView
/** 占位文字 */
@property (nonatomic, copy) NSString *placeholder;
/** 占位文字的颜色 */
@property (nonatomic, strong) UIColor *placeholderColor;

@property (nonatomic, strong) UIFont *placeholderFont;

@end
