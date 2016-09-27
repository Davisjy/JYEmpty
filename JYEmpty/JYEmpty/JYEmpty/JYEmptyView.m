//
//  JYEmptyView.m
//  ShowEmptyView
//
//  Created by Davis on 16/9/22.
//  Copyright © 2016年 Davis. All rights reserved.
//

#import "JYEmptyView.h"
#import "JYEmpty.h"
#import <Reachability.h>

@interface JYEmptyView ()

/** 刷新按钮 */
@property (nonatomic, strong, nonnull) UIButton    *refreshBtn;
/** 图标 */
@property (nonatomic, strong, nonnull) UIImageView *iconImageView;
/** 上面的提示信息 */
@property (nonatomic, strong, nonnull) UILabel     *topTitleLabel;
/** 下面的提示信息 */
@property (nonatomic, strong, nonnull) UILabel     *detailsLabel;

@end

@implementation JYEmptyView

/** 计算文本 CGSize */
static inline CGSize LableExpectedSize(NSString *text, UIFont *font, CGSize maxSize){
    if (text.length > 0) {
        //计算大小
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        paragraphStyle.alignment = NSTextAlignmentCenter;
        NSDictionary * attributes = @{NSFontAttributeName: font,
                                      NSParagraphStyleAttributeName: paragraphStyle
                                      };
        return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    }
    return CGSizeZero;
}

+ (JYEmptyView *)showTitle:(NSString *)title
                   details:(NSString *)details
                  iconImag:(NSString *)imageName {
    //自定义相关配置
    JYEmptyView *emptyView = [[JYEmptyView  alloc]init];
    emptyView.iconImage = [UIImage imageNamed:imageName];
    emptyView.labelText = title;
    emptyView.detailsLabelText = details;
    return emptyView;
}

#pragma mark - 重新刷新按钮的点击事件
- (void)refreshBtnClicked {
    if (self.refreshBtnClickBlock) {
        self.refreshBtnClickBlock();
    }
}

#pragma mark - setter
- (void)setIconImage:(UIImage *)iconImage {
    _iconImage = iconImage;
    self.iconImageView.image = iconImage;
}

- (void)setLabelText:(NSString *)labelText {
    _labelText = labelText;
    self.topTitleLabel.text = self.labelText;
}

- (void)setDetailsLabelText:(NSString *)detailsLabelText {
    _detailsLabelText = detailsLabelText;
    self.detailsLabel.text = detailsLabelText;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // 调整位置
    
    self.topTitleLabel.size = LableExpectedSize(_labelText, kFont(Font_H1), CGSizeMake(self.topTitleLabel.bounds.size.width, UILabelMaxHeight));
    self.detailsLabel.size = LableExpectedSize(_detailsLabel.text, kFont(Font_H2),CGSizeMake(_detailsLabel.bounds.size.width, UILabelMaxHeight));
    self.iconImageView.size = CGSizeMake(self.iconImage.size.width, self.iconImage.size.height);
    
    CGFloat contentHeight = self.iconImageView.height + Margin_Top + self.topTitleLabel.height + Margin_Top + self.detailsLabel.height + Margin_Top + self.refreshBtn.height;
    
    CGFloat topBottomMargin = (self.height - contentHeight) / 2;
    
    self.iconImageView.centerX = self.width / 2;
    self.iconImageView.y = topBottomMargin;
    self.topTitleLabel.y = self.iconImageView.bottom + Margin_Top;
    self.topTitleLabel.centerX = self.iconImageView.centerX;
    
    self.detailsLabel.y = self.topTitleLabel.bottom + Margin_Top;
    self.detailsLabel.centerX = self.width / 2;
    
    self.refreshBtn.y = self.detailsLabel.bottom + Margin_Top;
    self.refreshBtn.centerX = self.width / 2;
}

#pragma mark - 懒加载
- (UIButton *)refreshBtn {
    if(!_refreshBtn) {
        _refreshBtn= [[UIButton alloc]init];
        [_refreshBtn setTitle:@"重新加载" forState:UIControlStateNormal];
        _refreshBtn.layer.cornerRadius = 3.0f;
        _refreshBtn.layer.masksToBounds = YES;
        _refreshBtn.layer.borderColor = [UIColor redColor].CGColor;
        _refreshBtn.layer.borderWidth = 0.5;
        [_refreshBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_refreshBtn sizeToFit];
        _refreshBtn.size = CGSizeMake(120, 35);
        _refreshBtn.titleLabel.font = kFont(Font_H2);
        [_refreshBtn addTarget:self action:@selector(refreshBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_refreshBtn];
    }
    return _refreshBtn;
}


- (UIImageView *)iconImageView {
    if(!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.contentMode = UIViewContentModeCenter;
        [self addSubview:_iconImageView];
    }
    return _iconImageView;
}

/** 主标题只显示一行 */
- (UILabel *)topTitleLabel {
    if (!_topTitleLabel) {
        _topTitleLabel = [[UILabel alloc] init];
        _topTitleLabel.numberOfLines = 1;
        _topTitleLabel.textAlignment = NSTextAlignmentCenter;
        _topTitleLabel.font = kFont(Font_H1);
        _topTitleLabel.textColor = kRGBColor(46, 46, 46);
        [self addSubview:_topTitleLabel];
    }
    return _topTitleLabel;
}

/** 详情 -- 多行 */
- (UILabel *)detailsLabel {
    if(!_detailsLabel) {
        _detailsLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _detailsLabel.textAlignment = NSTextAlignmentCenter;
        _detailsLabel.numberOfLines = 0;
        _detailsLabel.font = kFont(Font_H3);
        _detailsLabel.textColor = kRGBColor(100, 100, 100);
        [self addSubview:_detailsLabel];
    }
    return _detailsLabel;
}

@end
