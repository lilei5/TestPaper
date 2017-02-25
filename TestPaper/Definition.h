//
//  Definition.h
//  TestPaper
//
//  Created by lilei on 17/2/25.
//  Copyright © 2017年 lilei. All rights reserved.
//

#ifndef Definition_h
#define Definition_h
//获取屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define HEXCOLOR(hexColor)  [UIColor colorWithRed:((float)((hexColor & 0xFF0000) >> 16))/255.0 green:((float)((hexColor & 0xFF00) >> 8))/255.0 blue:((float)(hexColor & 0xFF))/255.0 alpha:1]
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)

#define kHomeColor HEXCOLOR(0xebebeb)


//  圆角
#define ViewBorderRadius(view,radius)\
[view.layer setCornerRadius:(radius)];\
[view.layer setMasksToBounds:YES];
//  圆角和边框
#define ViewBorderRadiusColor(view,radius,width,color)\
[view.layer setCornerRadius:(radius)];\
[view.layer setMasksToBounds:YES];\
[view.layer setBorderWidth:(width)];\
[view.layer setBorderColor:[color CGColor]];

//定义UIImage对象
#define ImageNamed(A) [UIImage imageNamed:A]

#define NONullString(key)       [key length] > 0 ? key : @""

#endif /* Definition_h */
