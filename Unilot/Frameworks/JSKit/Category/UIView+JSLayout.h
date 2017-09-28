//
//  UIView+Layout.h
//  JSUIComponents
//
//  Created by Jitendra Singh on 4/18/16.
//  Copyright © 2016 Jitendra Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (JSLayout)

- (NSLayoutConstraint*)leftEqualToView:(UIView*)view;
- (NSLayoutConstraint*)leftEqualToView:(UIView*)view offset:(CGFloat)offset;
- (NSLayoutConstraint*)leftEqualToRightOfView:(UIView*)view;
- (NSLayoutConstraint*)leftEqualToRightOfView:(UIView*)view offset:(CGFloat)offset;


- (NSLayoutConstraint*)topEqualToView:(UIView*)view;
- (NSLayoutConstraint*)topEqualToView:(UIView*)view offset:(CGFloat)offset;
- (NSLayoutConstraint*)topEqualToBottomOfView:(UIView*)view;
- (NSLayoutConstraint*)topEqualToBottomOfView:(UIView*)view offset:(CGFloat)offset;

- (NSLayoutConstraint*)rightEqualToView:(UIView*)view;
- (NSLayoutConstraint*)rightEqualToView:(UIView*)view offset:(CGFloat)offset;
- (NSLayoutConstraint*)rightEqualToLeftOfView:(UIView*)view;
- (NSLayoutConstraint*)rightEqualToLeftOfView:(UIView*)view offset:(CGFloat)offset;

- (NSLayoutConstraint*)bottomEqualToView:(UIView*)view;
- (NSLayoutConstraint*)bottomEqualToView:(UIView*)view offset:(CGFloat)offset;
- (NSLayoutConstraint*)bottomEqualToTopOfView:(UIView*)view;
- (NSLayoutConstraint*)bottomEqualToTopOfView:(UIView*)view offset:(CGFloat)offset;

- (NSLayoutConstraint*)centerXEqualToView:(UIView*)view;
- (NSLayoutConstraint*)centerXEqualToView:(UIView*)view offset:(CGFloat)offset;

- (NSLayoutConstraint*)centerYEqualToView:(UIView*)view;
- (NSLayoutConstraint*)centerYEqualToView:(UIView*)view offset:(CGFloat)offset;


- (NSLayoutConstraint*)widthEqualTo:(id)viewOrConstant;
- (NSLayoutConstraint*)widthEqualTo:(id)viewOrConstant multiplyBy:(CGFloat)multiplier;

- (NSLayoutConstraint*)heightEqualTo:(id)viewOrConstant;
- (NSLayoutConstraint*)heightEqualTo:(id)viewOrConstant multiplyBy:(CGFloat)multiplier;

@end
