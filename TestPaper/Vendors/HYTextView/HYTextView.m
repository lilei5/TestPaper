//
//  HWTextView.m
//
//  TeacherGo
//
//  Created by Mr_ Jia on 15/4/2.
//  Copyright (c) 2015年 wangbin. All rights reserved.
//
//

#import "HYTextView.h"

@implementation HYTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 通知
        // 当UITextView的文字发生改变时，UITextView自己会发出一个UITextViewTextDidChangeNotification通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 * 监听文字改变
 */
- (void)textDidChange
{
    // 重绘（重新调用）
    [self setNeedsDisplay];
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = [placeholder copy];
    
    [self setNeedsDisplay];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderColor = placeholderColor;

    [self setNeedsDisplay];
}

- (void)setPlaceholderFont:(UIFont *)placeholderFont{
    _placeholderFont = placeholderFont;
     [self setNeedsDisplay];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    
    // setNeedsDisplay会在下一个消息循环时刻，调用drawRect:
    [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    
    [self setNeedsDisplay];
}
#define Font [UIFont systemFontOfSize:15]
- (void)drawRect:(CGRect)rect
{
//    [HWRandomColor set];
//    UIRectFill(CGRectMake(20, 20, 30, 30));
    // 如果有输入文字，就直接返回，不画占位文字
    if (self.hasText) return;
    
    // 文字属性
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = self.placeholderFont? self.placeholderFont : Font;
    attrs[NSForegroundColorAttributeName] = self.placeholderColor?self.placeholderColor:[UIColor grayColor];
    // 画文字
    CGFloat x = 5;
    CGFloat w = rect.size.width - 2 * x;
    CGFloat y = 8;
    CGFloat h = rect.size.height - 2 * y;
    CGRect placeholderRect = CGRectMake(x, y, w, h);
    [self.placeholder drawInRect:placeholderRect withAttributes:attrs];
}

@end
