//
//  UIView+Layout.m
//  JSUIComponents
//
//  Created by Jitendra Singh on 4/18/16.
//  Copyright © 2016 Jitendra Singh. All rights reserved.
//

#import "UIView+JSLayout.h"
#import <objc/runtime.h>

static void const *kUninstallNibConstraintsKey = "kUninstallNibConstraintsKey";

@implementation UIView (JSLayout)

- (NSLayoutConstraint*)leftEqualToView:(UIView*)view
{
    return [self leftEqualToView:view offset:0];
}

- (NSLayoutConstraint*)leftEqualToView:(UIView*)view offset:(CGFloat)offset
{
    UIView *commonSuperView = [self closestCommonSuperview:view];
    [self uninstallNibConstraintsFromView:commonSuperView];
    NSLayoutConstraint *c = [NSLayoutConstraint constraintWithItem:self
                                                         attribute:NSLayoutAttributeLeft
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:view
                                                         attribute:NSLayoutAttributeLeft
                                                        multiplier:1.0
                                                          constant:offset];
    [commonSuperView addConstraint:c];
    return c;
}

- (NSLayoutConstraint*)leftEqualToRightOfView:(UIView*)view
{
    return [self leftEqualToRightOfView:view offset:0];
}

- (NSLayoutConstraint*)leftEqualToRightOfView:(UIView*)view offset:(CGFloat)offset
{
    UIView *commonSuperView = [self closestCommonSuperview:view];
    [self uninstallNibConstraintsFromView:commonSuperView];
    NSLayoutConstraint *c = [NSLayoutConstraint constraintWithItem:self
                                                         attribute:NSLayoutAttributeLeft
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:view
                                                         attribute:NSLayoutAttributeRight
                                                        multiplier:1.0
                                                          constant:offset];
    [commonSuperView addConstraint:c];
    return c;
}


- (NSLayoutConstraint*)topEqualToView:(UIView*)view
{
    return [self topEqualToView:view offset:0];
}

- (NSLayoutConstraint*)topEqualToView:(UIView*)view offset:(CGFloat)offset
{
    UIView *commonSuperView = [self closestCommonSuperview:view];
    [self uninstallNibConstraintsFromView:commonSuperView];
    NSLayoutConstraint *c = [NSLayoutConstraint constraintWithItem:self
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:view
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1.0
                                                          constant:offset];
    [commonSuperView addConstraint:c];
    return c;
}

- (NSLayoutConstraint*)topEqualToBottomOfView:(UIView*)view
{
    return [self topEqualToBottomOfView:view offset:0];
}

- (NSLayoutConstraint*)topEqualToBottomOfView:(UIView*)view offset:(CGFloat)offset
{
    UIView *commonSuperView = [self closestCommonSuperview:view];
    [self uninstallNibConstraintsFromView:commonSuperView];
    NSLayoutConstraint *c = [NSLayoutConstraint constraintWithItem:self
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:view
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1.0
                                                          constant:offset];
    [commonSuperView addConstraint:c];
    return c;
}

- (NSLayoutConstraint*)rightEqualToView:(UIView*)view
{
    return [self rightEqualToView:view offset:0];
}

- (NSLayoutConstraint*)rightEqualToView:(UIView*)view offset:(CGFloat)offset
{
    UIView *commonSuperView = [self closestCommonSuperview:view];
    [self uninstallNibConstraintsFromView:commonSuperView];
    NSLayoutConstraint *c = [NSLayoutConstraint constraintWithItem:self
                                                         attribute:NSLayoutAttributeRight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:view
                                                         attribute:NSLayoutAttributeRight
                                                        multiplier:1.0
                                                          constant:offset];
    [commonSuperView addConstraint:c];
    return c;
}

- (NSLayoutConstraint*)rightEqualToLeftOfView:(UIView*)view
{
    return [self rightEqualToLeftOfView:view offset:0];
}

- (NSLayoutConstraint*)rightEqualToLeftOfView:(UIView*)view offset:(CGFloat)offset
{
    UIView *commonSuperView = [self closestCommonSuperview:view];
    [self uninstallNibConstraintsFromView:commonSuperView];
    NSLayoutConstraint *c = [NSLayoutConstraint constraintWithItem:self
                                                         attribute:NSLayoutAttributeRight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:view
                                                         attribute:NSLayoutAttributeLeft
                                                        multiplier:1.0
                                                          constant:offset];
    [commonSuperView addConstraint:c];
    return c;
}

- (NSLayoutConstraint*)bottomEqualToView:(UIView*)view
{
    return [self bottomEqualToView:view offset:0];
}

- (NSLayoutConstraint*)bottomEqualToView:(UIView*)view offset:(CGFloat)offset
{
    UIView *commonSuperView = [self closestCommonSuperview:view];
    [self uninstallNibConstraintsFromView:commonSuperView];
    NSLayoutConstraint *c = [NSLayoutConstraint constraintWithItem:view
                                                         attribute:NSLayoutAttributeBottom
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1.0
                                                          constant:offset];
    [commonSuperView addConstraint:c];
    return c;
}

- (NSLayoutConstraint*)bottomEqualToTopOfView:(UIView*)view
{
    return [self bottomEqualToTopOfView:view offset:0];
}

- (NSLayoutConstraint*)bottomEqualToTopOfView:(UIView*)view offset:(CGFloat)offset
{
    UIView *commonSuperView = [self closestCommonSuperview:view];
    [self uninstallNibConstraintsFromView:commonSuperView];
    NSLayoutConstraint *c = [NSLayoutConstraint constraintWithItem:view
                                                         attribute:NSLayoutAttributeBottom
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1.0
                                                          constant:offset];
    [commonSuperView addConstraint:c];
    return c;
}

- (NSLayoutConstraint*)widthEqualTo:(id)viewOrConstant
{
    return [self widthEqualTo:viewOrConstant multiplyBy:1.0];
}

- (NSLayoutConstraint*)widthEqualTo:(id)viewOrConstant multiplyBy:(CGFloat)multiplier
{
    UIView *commonSuperView = [self closestCommonSuperview:viewOrConstant];
    [self uninstallNibConstraintsFromView:commonSuperView];
    NSLayoutConstraint *c = [NSLayoutConstraint constraintWithItem:self
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:([viewOrConstant isKindOfClass:[UIView class]]) ? viewOrConstant : nil
                                                         attribute:([viewOrConstant isKindOfClass:[UIView class]]) ? NSLayoutAttributeWidth : NSLayoutAttributeNotAnAttribute
                                                        multiplier:multiplier
                                                          constant:[viewOrConstant isKindOfClass:[UIView class]] ? 0 : [viewOrConstant floatValue]];
    
    commonSuperView = commonSuperView ? commonSuperView : self;
    [commonSuperView addConstraint:c];
    return c;
}

- (NSLayoutConstraint*)heightEqualTo:(id)viewOrConstant
{
    return [self heightEqualTo:viewOrConstant multiplyBy:1.0];
}

- (NSLayoutConstraint*)heightEqualTo:(id)viewOrConstant multiplyBy:(CGFloat)multiplier
{
    UIView *commonSuperView = [self closestCommonSuperview:viewOrConstant];
    [self uninstallNibConstraintsFromView:commonSuperView];
    NSLayoutConstraint *c = [NSLayoutConstraint constraintWithItem:self
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:([viewOrConstant isKindOfClass:[UIView class]]) ? viewOrConstant : nil
                                                         attribute:([viewOrConstant isKindOfClass:[UIView class]]) ? NSLayoutAttributeHeight : NSLayoutAttributeNotAnAttribute
                                                        multiplier:multiplier
                                                          constant:[viewOrConstant isKindOfClass:[UIView class]] ? 0 : [viewOrConstant floatValue]];
    commonSuperView = commonSuperView ? commonSuperView : self;
    [commonSuperView addConstraint:c];
    return c;
}

- (NSLayoutConstraint*)centerXEqualToView:(UIView*)view
{
    return [self centerXEqualToView:view offset:0];
}

- (NSLayoutConstraint*)centerXEqualToView:(UIView*)view offset:(CGFloat)offset
{
    UIView *commonSuperView = [self closestCommonSuperview:view];
    [self uninstallNibConstraintsFromView:commonSuperView];
    NSLayoutConstraint *c = [NSLayoutConstraint constraintWithItem:view
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1.0
                                                          constant:offset];
    [commonSuperView addConstraint:c];
    return c;
}

- (NSLayoutConstraint*)centerYEqualToView:(UIView*)view
{
    return [self centerYEqualToView:view offset:0];
}

- (NSLayoutConstraint*)centerYEqualToView:(UIView*)view offset:(CGFloat)offset
{
    UIView *commonSuperView = [self closestCommonSuperview:view];
    [self uninstallNibConstraintsFromView:commonSuperView];
    NSLayoutConstraint *c = [NSLayoutConstraint constraintWithItem:view
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1.0
                                                          constant:offset];
    [commonSuperView addConstraint:c];
    return c;
}



- (instancetype)closestCommonSuperview:(UIView *)view {
    if (view && ![view isKindOfClass:[UIView class]]) {
        return nil;
    }
    UIView *closestCommonSuperview = nil;
    
    UIView *secondViewSuperview = view;
    while (!closestCommonSuperview && secondViewSuperview) {
        UIView *firstViewSuperview = self;
        while (!closestCommonSuperview && firstViewSuperview) {
            if (secondViewSuperview == firstViewSuperview) {
                closestCommonSuperview = secondViewSuperview;
            }
            firstViewSuperview = firstViewSuperview.superview;
        }
        secondViewSuperview = secondViewSuperview.superview;
    }
    return closestCommonSuperview;
}

- (void)uninstallNibConstraintsFromView:(UIView*)commonView
{
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    if (commonView) {
        id obj = objc_getAssociatedObject(commonView, kUninstallNibConstraintsKey);
        if (!obj) {
            [commonView removeConstraints:commonView.constraints];
            
            objc_setAssociatedObject(commonView, kUninstallNibConstraintsKey, [NSNumber numberWithBool:YES], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
}

@end
