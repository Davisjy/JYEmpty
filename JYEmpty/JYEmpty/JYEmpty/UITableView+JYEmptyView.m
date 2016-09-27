//
//  UITableView+JYEmptyView.m
//  ShowEmptyView
//
//  Created by Davis on 16/9/22.
//  Copyright © 2016年 Davis. All rights reserved.
//

#import "UITableView+JYEmptyView.h"
#import <objc/runtime.h>
#import "JYEmpty.h"
#import <Reachability.h>

static JYEmptyView *view;

@implementation UITableView (JYEmptyView)
/**
 *  交换方法
 *
 *  @param c    类
 *  @param orig system @selector
 *  @param new  new    @selector
 */
void swizzle(Class c, SEL orig, SEL new) {
    Method origMethod = class_getInstanceMethod(c, orig);
    Method newMethod = class_getInstanceMethod(c, new);
    if(class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))) {
        class_replaceMethod(c, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    } else {
        method_exchangeImplementations(origMethod, newMethod);
    }
}

+ (void)load {
    // 交换方法
    [self swizzleMethod];
}

+ (void)swizzleMethod {
    Class c = [UITableView class];
    swizzle(c, @selector(layoutSubviews), @selector(JY_layoutSubviews));
}

- (void)listenNetwork {
    static Reachability *reach = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
        [reach startNotifier];
    });
    
    UIView *noNetworkView = self.noNetworkView;
    noNetworkView.frame = [UIScreen mainScreen].bounds;
    reach.reachableBlock = ^(Reachability *reach) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"REACHABLE!");
            
            if (noNetworkView.superview) {
                [noNetworkView removeFromSuperview];
            }
        });
    };
    
    reach.unreachableBlock = ^(Reachability *reach){
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"UNREACHABLE!");

            if (!noNetworkView.superview) {
                [kWindow addSubview:noNetworkView];
            }
        });
    };
}

#pragma mark - 根据数据情况确定空白视图显示与否
- (BOOL)isShowEmptyView {
    NSUInteger numberOfRows = 0;
    for (NSInteger sectionIndex = 0; sectionIndex < self.numberOfSections; sectionIndex++) {
        numberOfRows += [self numberOfRowsInSection:sectionIndex];
    }
    return (numberOfRows > 0);
}

#pragma mark - 设置空白视图
- (void)setEmptyView {
    
    UIView *emptyView = self.emptyView;
    if (emptyView.superview) {
        [emptyView removeFromSuperview];
    }
    
    [kWindow addSubview:emptyView];
    emptyView.backgroundColor = [UIColor whiteColor];
    emptyView.frame = [UIScreen mainScreen].bounds;

    BOOL emptyViewShouldBeShow = ([self isShowEmptyView] == NO);
    
    emptyView.hidden = !emptyViewShouldBeShow;
    if (emptyView.hidden) {
        [emptyView removeFromSuperview];
        emptyView = nil;
    }
}

#pragma mark - swizzle method
- (void)JY_layoutSubviews {
    [self JY_layoutSubviews];

    [self setEmptyView];
}

#pragma mark - AssociatedObject
- (void)setEmptyView:(UIView *)emptyView {
    objc_setAssociatedObject(self, @selector(setEmptyView:), emptyView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)emptyView {
    return objc_getAssociatedObject(self, @selector(setEmptyView:));
}

- (void)setNoNetworkView:(UIView *)noNetworkView {
    objc_setAssociatedObject(self, @selector(setNoNetworkView:), noNetworkView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self listenNetwork];
}

- (UIView *)noNetworkView {
    return objc_getAssociatedObject(self, @selector(setNoNetworkView:));
}

@end
