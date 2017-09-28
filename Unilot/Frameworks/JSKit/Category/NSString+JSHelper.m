//
//  NSString+JSHelper.m
//  JSUIComponents
//
//  Created by Jitendra Singh on 8/6/16.
//  Copyright © 2016 Jitendra Singh. All rights reserved.
//

#import "NSString+JSHelper.h"

@implementation NSString (JSHelper)

- (CGFloat)widthConstrainedToHeight:(CGFloat)heightValue andFont:(UIFont *)font
{
    CGFloat result = font.pointSize+4;
    if (self) {
        CGSize size;
        CGRect frame = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, heightValue) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
        size = CGSizeMake(frame.size.width, frame.size.height+1);
        result = MAX(size.width, result);
    }
    return result;
}

@end
