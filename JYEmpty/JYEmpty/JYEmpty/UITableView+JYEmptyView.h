//
//  UITableView+JYEmptyView.h
//  ShowEmptyView
//
//  Created by Davis on 16/9/22.
//  Copyright © 2016年 Davis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (JYEmptyView)

/** 传入的空视图 */
@property (nonatomic, strong, nonnull) UIView *emptyView;

/** 传入的无网络视图 */
@property (nonatomic, strong, nonnull) UIView *noNetworkView;

@end
