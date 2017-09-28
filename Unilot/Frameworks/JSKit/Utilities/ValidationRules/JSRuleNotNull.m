//
//  JSRuleNotNull.m
//  JSUIComponents
//
//  Created by Jitendra Singh on 3/9/12.
//  Copyright (c) 2012 JS. All rights reserved.
//

#import "JSRuleNotNull.h"

@implementation JSRuleNotNull

- (BOOL)validate:(id *)value forKey:(NSString*)key error:(NSError**)error
{
    BOOL isValid = YES;
    if (*value == nil) 
    {
        isValid = NO;
        if (error != NULL) {
            *error = [NSError validationErrorWithCode:1001
                                               reason:[NSString stringWithFormat:@"%@ cannot be blank.",key]];
        }
    }
    return isValid;
}

@end

