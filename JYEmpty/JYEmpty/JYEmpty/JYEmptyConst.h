//
//  JYEmptyConst.h
//  ShowEmptyView
//
//  Created by Davis on 16/9/22.
//  Copyright © 2016年 Davis. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kRGBColor(r,g,b)    ([UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1])
#define kFont(font) ([UIFont boldSystemFontOfSize:font])
#define kWindow   [UIApplication sharedApplication].keyWindow
// 常量
// 字体大小
// 16
UIKIT_EXTERN const CGFloat Font_H1;
// 15
UIKIT_EXTERN const CGFloat Font_H2;
// 12
UIKIT_EXTERN const CGFloat Font_H3;

// 空白视图间距
UIKIT_EXTERN const CGFloat Margin_Top;

// Label最大高度
UIKIT_EXTERN const CGFloat UILabelMaxHeight;