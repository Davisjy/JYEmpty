//
//  UIView+Awesome.m
//  UICategory
//
//  Created by Davis on 16/8/26.
//  Copyright © 2016年 Davis. All rights reserved.
//

#import "UIView+Awesome.h"
#import <objc/runtime.h>
#import <AssetsLibrary/ALAssetsLibrary.h>

@implementation UIView (Awesome)
- (void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x {
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setCenterX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY {
    return self.center.y;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - self.frame.size.height;
    self.frame = frame;
}


+ (instancetype)viewFromNIB {
    // 加载xib中的视图，其中xib文件名和本类类名必须一致
    // 这个xib文件的File's Owner必须为空
    // 这个xib文件必须只拥有一个视图，并且该视图的class为本类
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    return views[0];
}

- (void)cornerRoundingCorners:(UIRectCorner)RoundingCorners withCornerRadius:(CGFloat)cornerRadius{
    
    CGSize cornerSize = CGSizeMake(cornerRadius, cornerRadius);
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                     byRoundingCorners:RoundingCorners
                                           cornerRadii:cornerSize];
    // Create the shape layer and set its path
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    
    // Set the newly created shape layer as the mask for the image view's layer
    self.layer.mask = maskLayer;
    
    [self.layer setMasksToBounds:YES];
}

- (void)setTapActionWithBlock:(void (^)(void))block {
    
    self.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *gesture = objc_getAssociatedObject(self, @selector(setTapActionWithBlock:));
    
    if (!gesture) {
        gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleActionForTapGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, @selector(setTapActionWithBlock:), gesture, OBJC_ASSOCIATION_RETAIN);
    }
    
    objc_setAssociatedObject(self, @selector(setTapActionWithBlock:), block, OBJC_ASSOCIATION_COPY);
}

- (void)handleActionForTapGesture:(UITapGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateRecognized)  {
        void(^action)(void) = objc_getAssociatedObject(self, @selector(setTapActionWithBlock:));
        if (action)  {
            action();
        }
    }
}


@end

@implementation UILabel(Extension)

+ (instancetype)labelWithFont:(CGFloat)font textColor:(UIColor *)textColor textAlignment:(NSTextAlignment)textAlignment numberOfLines:(NSInteger)numberOfLines {
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:font];
    label.textColor = textColor;
    label.textAlignment = textAlignment;
    label.numberOfLines = numberOfLines;
    return label;
}

@end

@implementation UIButton (Extension)

+ (instancetype)buttonSizeWithName:(NSString *)name {
    UIImage *image = [UIImage imageNamed:name];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, image.size.width * 0.65, image.size.height * 0.65);
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    [btn setBackgroundImage:image forState:UIControlStateHighlighted];
    return btn;
}
+ (instancetype)buttonWhiteTitleWith:(NSString *)title color:(UIColor *)color andFontSize:(CGFloat)fontSize {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, [title sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]}].width,fontSize);
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    return btn;
}

@end

@implementation UITextField (Extension)

+ (instancetype)textFieldWithFont:(CGFloat)font placeholder:(NSString *)placeholder andKeyboardType:(UIKeyboardType)type {
    UITextField *textfield = [[UITextField alloc] init];
    textfield.placeholder = placeholder;
    textfield.font = [UIFont systemFontOfSize:font];
    textfield.keyboardType = type;
    return textfield;
}

@end

const char kProcessedImage;

@interface UIImageView ()

@property (assign, nonatomic) CGFloat zyRadius;
@property (assign, nonatomic) UIRectCorner roundingCorners;
@property (assign, nonatomic) BOOL zyHadAddObserver;
@property (assign, nonatomic) BOOL zyIsRounding;

@end


@implementation UIImageView (Extension)
/**
 * @brief init the Rounding UIImageView, no off-screen-rendered
 */
- (instancetype)initWithRoundingRectImageView {
    self = [super init];
    if (self) {
        [self cornerRadiusRoundingRect];
    }
    return self;
}

/**
 * @brief init the UIImageView with cornerRadius, no off-screen-rendered
 */
- (instancetype)initWithCornerRadiusAdvance:(CGFloat)cornerRadius rectCornerType:(UIRectCorner)rectCornerType {
    self = [super init];
    if (self) {
        [self cornerRadiusAdvance:cornerRadius rectCornerType:rectCornerType];
    }
    return self;
}

#pragma mark - Kernel
/**
 * @brief clip the cornerRadius with image, UIImageView must be setFrame before, no off-screen-rendered
 */
- (void)cornerRadiusWithImage:(UIImage *)image cornerRadius:(CGFloat)cornerRadius rectCornerType:(UIRectCorner)rectCornerType {
    CGSize size = self.bounds.size;
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize cornerRadii = CGSizeMake(cornerRadius, cornerRadius);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    if (nil == currentContext) {
        return;
    }
    UIBezierPath *cornerPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:rectCornerType cornerRadii:cornerRadii];
    [cornerPath addClip];
    [self.layer renderInContext:currentContext];
    UIImage *processedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    objc_setAssociatedObject(processedImage, &kProcessedImage, @(1), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.image = processedImage;
}

/**
 * @brief clip the cornerRadius with image, draw the backgroundColor you want, UIImageView must be setFrame before, no off-screen-rendered, no Color Blended layers
 */
- (void)cornerRadiusWithImage:(UIImage *)image cornerRadius:(CGFloat)cornerRadius rectCornerType:(UIRectCorner)rectCornerType backgroundColor:(UIColor *)backgroundColor {
    CGSize size = self.bounds.size;
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize cornerRadii = CGSizeMake(cornerRadius, cornerRadius);
    
    UIGraphicsBeginImageContextWithOptions(size, YES, scale);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    if (nil == currentContext) {
        return;
    }
    UIBezierPath *cornerPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:rectCornerType cornerRadii:cornerRadii];
    UIBezierPath *backgroundRect = [UIBezierPath bezierPathWithRect:self.bounds];
    [backgroundColor setFill];
    [backgroundRect fill];
    [cornerPath addClip];
    [self.layer renderInContext:currentContext];
    UIImage *processedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    objc_setAssociatedObject(processedImage, &kProcessedImage, @(1), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.image = processedImage;
}

/**
 * @brief set cornerRadius for UIImageView, no off-screen-rendered
 */
- (void)cornerRadiusAdvance:(CGFloat)cornerRadius rectCornerType:(UIRectCorner)rectCornerType {
    self.zyRadius = cornerRadius;
    self.roundingCorners = rectCornerType;
    self.zyIsRounding = NO;
    
    if (!self.zyHadAddObserver) {
        [[self class] swizzleDealloc];
        [self addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:nil];
        self.zyHadAddObserver = YES;
    }
}

/**
 * @brief become Rounding UIImageView, no off-screen-rendered
 */
- (void)cornerRadiusRoundingRect {
    self.zyIsRounding = YES;
    
    if (!self.zyHadAddObserver) {
        [[self class] swizzleDealloc];
        [self addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:nil];
        self.zyHadAddObserver = YES;
    }
}

- (void)zy_dealloc {
    if (self.zyHadAddObserver) {
        [self removeObserver:self forKeyPath:@"image"];
    }
    [self zy_dealloc];
}

- (void)validateFrame {
    if (self.frame.size.width == 0) {
        [self.class swizzleLayoutSubviews];
    }
}

+ (void)swizzleMethod:(SEL)oneSel anotherMethod:(SEL)anotherSel {
    Method oneMethod = class_getInstanceMethod(self, oneSel);
    Method anotherMethod = class_getInstanceMethod(self, anotherSel);
    method_exchangeImplementations(oneMethod, anotherMethod);
}

+ (void)swizzleDealloc {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleMethod:NSSelectorFromString(@"dealloc") anotherMethod:@selector(zy_dealloc)];
    });
}

+ (void)swizzleLayoutSubviews {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleMethod:@selector(layoutSubviews) anotherMethod:@selector(zy_LayoutSubviews)];
    });
}

- (void)zy_LayoutSubviews {
    [self zy_LayoutSubviews];
    if (self.zyIsRounding) {
        [self cornerRadiusWithImage:self.image cornerRadius:self.frame.size.width/2 rectCornerType:UIRectCornerAllCorners];
    } else if (0 != self.zyRadius && 0 != self.roundingCorners && nil != self.image) {
        [self cornerRadiusWithImage:self.image cornerRadius:self.zyRadius rectCornerType:self.roundingCorners];
    }
}

#pragma mark - KVO for .image
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"image"]) {
        UIImage *newImage = change[NSKeyValueChangeNewKey];
        if ([newImage isMemberOfClass:[NSNull class]]) {
            return;
        } else if ([objc_getAssociatedObject(newImage, &kProcessedImage) intValue] == 1) {
            return;
        }
        [self validateFrame];
        if (self.zyIsRounding) {
            [self cornerRadiusWithImage:newImage cornerRadius:self.frame.size.width/2 rectCornerType:UIRectCornerAllCorners];
        } else if (0 != self.zyRadius && 0 != self.roundingCorners && nil != self.image) {
            [self cornerRadiusWithImage:newImage cornerRadius:self.zyRadius rectCornerType:self.roundingCorners];
        }
    }
}

- (BOOL)zyHadAddObserver {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setZyHadAddObserver:(BOOL)zyHadAddObserver {
    objc_setAssociatedObject(self, @selector(zyHadAddObserver), @(zyHadAddObserver), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)zyIsRounding {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setZyIsRounding:(BOOL)zyIsRounding {
    objc_setAssociatedObject(self, @selector(zyIsRounding), @(zyIsRounding), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIRectCorner)roundingCorners {
    return [objc_getAssociatedObject(self, _cmd) unsignedLongValue];
}

- (void)setRoundingCorners:(UIRectCorner)roundingCorners {
    objc_setAssociatedObject(self, @selector(roundingCorners), @(roundingCorners), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)zyRadius {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setZyRadius:(CGFloat)zyRadius {
    objc_setAssociatedObject(self, @selector(zyRadius), @(zyRadius), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//ZYCornerRadius is available under the MIT license.
//Please visit https://github.com/liuzhiyi1992/ZYCornerRadius for details.

@end


static  BOOL canEdit = NO;
static  char blockKey;

@interface UIViewController()<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIAlertViewDelegate>

@property (nonatomic, copy) PhotoBlock photoBlock;

@end

@implementation UIViewController (Extension)

+ (UIViewController *)findBestViewController:(UIViewController *)vc {
    if (vc.presentedViewController) {
        // Return presented view controller
        return [UIViewController findBestViewController:vc.presentedViewController];
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        // Return right hand side
        UISplitViewController* svc = (UISplitViewController*)vc;
        if (svc.viewControllers.count > 0)
            return [UIViewController findBestViewController:svc.viewControllers.lastObject];
        else
            return vc;
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        
        // Return top view
        UINavigationController* svc = (UINavigationController*)vc;
        if (svc.viewControllers.count > 0)
            return [UIViewController findBestViewController:svc.topViewController];
        else
            return vc;
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        
        // Return visible view
        UITabBarController* svc = (UITabBarController*)vc;
        if (svc.viewControllers.count > 0)
            return [UIViewController findBestViewController:svc.selectedViewController];
        else
            return vc;
    } else {
        // Unknown view controller type, return last child view controller
        return vc;
    }
}

+ (UIViewController*)currentViewController {
    // Find best view controller
    UIViewController* viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [UIViewController findBestViewController:viewController];
}


#pragma mark - set
- (void)setPhotoBlock:(PhotoBlock)photoBlock
{
    objc_setAssociatedObject(self, &blockKey, photoBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
#pragma mark - get
- (PhotoBlock )photoBlock
{
    return objc_getAssociatedObject(self, &blockKey);
}

- (void)showCanEdit:(BOOL)edit photo:(PhotoBlock)block
{
    if(edit) canEdit = edit;
    
    self.photoBlock = [block copy];
    UIActionSheet *sheet  = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"相册中获取", nil];
    sheet.tag = 2599;
    [sheet showInView:self.view];
    
}
#pragma mark - action sheet delegte
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 2599)
    {
        //权限
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        if (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied) {
            CGFloat kSystemMainVersion = [UIDevice currentDevice].systemVersion.floatValue;
            NSString *title = nil;
            NSString *photoType = buttonIndex==0?@"相机":@"相册";
            NSString *msg = [NSString stringWithFormat:@"还没有开启%@权限,请在系统设置中开启",photoType];
            NSString *cancelTitle = @"暂不";
            NSString *otherButtonTitles = @"去设置";
            
            if (kSystemMainVersion < 8.0) {
                title = [NSString stringWithFormat:@"%@权限未开启",photoType];
                msg = [NSString stringWithFormat:@"请在系统设置中开启%@服务\n(设置>隐私>%@>开启)",photoType,photoType];
                cancelTitle = @"知道了";
                otherButtonTitles = nil;
            }
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:otherButtonTitles, nil];
            alertView.tag = 2598;
            [alertView show];
            return;
        }
        //跳转到相机/相册页面
        UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = canEdit;
        switch (buttonIndex)
        {
            case 0:
                //拍照
                //是否支持相机
                if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                {
                    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                    [self presentViewController:imagePickerController animated:YES completion:NULL];
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"该设备不支持相机" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                }
                break;
            case 1:
                //相册
                imagePickerController.sourceType =UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:imagePickerController animated:YES completion:NULL];
            default:
                break;
        }
    }
}
#pragma mark - UIAlertDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag==2598)
    {
        if (buttonIndex == 1) {
            CGFloat kSystemMainVersion = [UIDevice currentDevice].systemVersion.floatValue;
            if (kSystemMainVersion >= 8.0) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
                //@"1.iOS8以后支持跳转到设置,设置完成后,系统会自启应用,刷新应用权限 2.由于系统自启应用,连接Xcode调试会crash,断开与Xcode连接,进行操作即可";
            }
        }
    }
}
#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image;
    //是否要裁剪
    if ([picker allowsEditing]){
        
        //编辑之后的图像
        image = [info objectForKey:UIImagePickerControllerEditedImage];
        
    } else {
        
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    if(self.photoBlock)
    {
        self.photoBlock(image);
    }
}

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method method1 = class_getInstanceMethod(self, NSSelectorFromString(@"dealloc"));
        Method method2 = class_getInstanceMethod(self, @selector(my_dealloc));
        method_exchangeImplementations(method1, method2);
    });
}

- (void)my_dealloc
{
    NSLog(@"%@销毁了", self);
    [self my_dealloc];
}

@end



