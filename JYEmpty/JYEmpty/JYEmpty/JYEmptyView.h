//
//  JYEmptyView.h
//  ShowEmptyView
//
//  Created by Davis on 16/9/22.
//  Copyright © 2016年 Davis. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RefreshBtnClick)();

@interface JYEmptyView : UIView

/** 上方的提示文本 */
@property (nonatomic, copy, nullable) NSString *labelText;

/** 下方的提示文本 */
@property (nonatomic, copy, nullable) NSString *detailsLabelText;

/** 提示的图片 */
@property (nonatomic, strong, nullable) UIImage *iconImage;

/** 点击回调 */
@property (nonatomic, copy, nonnull) RefreshBtnClick refreshBtnClickBlock;

+ (JYEmptyView * _Nonnull)showTitle:(NSString * _Nonnull)title
                   details:(NSString * _Nonnull)details
                   iconImag:(NSString * _Nonnull)imageName;

@end
