//
//  UIView+Awesome.h
//  UICategory
//
//  Created by Davis on 16/8/26.
//  Copyright © 2016年 Davis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Awesome)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat bottom;

/** 当前view从xib中加载 */
+ (instancetype)viewFromNIB;

/**
 *
 *  设置不同角的圆角(得Masonry确定尺寸之后才能用)
 *
 *  @param sideType 圆角类型
 *  @param cornerRadius 圆角半径
 */
- (void)cornerRoundingCorners:(UIRectCorner)RoundingCorners withCornerRadius:(CGFloat)cornerRadius;

/** 动态添加手势 */
- (void)setTapActionWithBlock:(void (^)(void))block;

@end

@interface UILabel(Extension)
/** UILabel基本初始化方法 */
+ (instancetype)labelWithFont:(CGFloat )font textColor:(UIColor *)textColor textAlignment:(NSTextAlignment)textAlignment numberOfLines:(NSInteger)numberOfLines;

@end

@interface UIButton(Extension)

/** 根据图片的大小初始化按钮 */
+ (instancetype)buttonSizeWithName:(NSString *)name;
/** 根据 名称 颜色 大小 设置按钮 */
+ (instancetype)buttonWhiteTitleWith:(NSString *)title color:(UIColor *)color andFontSize:(CGFloat)fontSize;

@end

@interface UITextField(Extension)

/** UITextField基本初始化方法 */
+ (instancetype)textFieldWithFont:(CGFloat)font placeholder:(NSString *)placeholder andKeyboardType:(UIKeyboardType)type;

@end

@interface UIImageView (Extension)

- (instancetype)initWithCornerRadiusAdvance:(CGFloat)cornerRadius rectCornerType:(UIRectCorner)rectCornerType;

- (void)cornerRadiusAdvance:(CGFloat)cornerRadius rectCornerType:(UIRectCorner)rectCornerType;

- (instancetype)initWithRoundingRectImageView;

- (void)cornerRadiusRoundingRect;

//- (void)attachBorderWidth:(CGFloat)width color:(UIColor *)color;

@end

typedef void(^PhotoBlock)(UIImage *photo);

@interface UIViewController(Extension)

/** 获取UIWindow当前展示的控制器 */
+ (UIViewController *)currentViewController;

/**
 *  照片选择->图库/相机
 *
 *  @param edit  照片是否需要裁剪,默认NO
 *  @param block 照片回调
 */
- (void)showCanEdit:(BOOL)edit photo:(PhotoBlock)block;

@end



