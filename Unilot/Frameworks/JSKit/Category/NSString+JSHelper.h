//
//  NSString+JSHelper.h
//  JSUIComponents
//
//  Created by Jitendra Singh on 8/6/16.
//  Copyright © 2016 Jitendra Singh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define IsSameString(x, y) (x && [x caseInsensitiveCompare:y] == NSOrderedSame)
#define NSStringHasData(_x) ( [(_x) isKindOfClass:[NSString class]] && ((_x) != nil) && ( [(_x) length] > 0 ) && !IsSameString(@"(null)", _x) && !IsSameString(@"<null>", _x))


@interface NSString (JSHelper)

- (CGFloat)widthConstrainedToHeight:(CGFloat)heightValue andFont:(UIFont *)font;

@end
