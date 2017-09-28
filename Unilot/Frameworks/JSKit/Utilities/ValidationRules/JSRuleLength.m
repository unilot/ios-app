//
//  JSRuleLength.m
//  JSUIComponents
//
//  Created by Jitendra Singh on 3/9/12.
//  Copyright (c) 2012 JS. All rights reserved.
//

#import "JSRuleLength.h"
#import "JSRule.h"

@implementation JSRuleLength
@synthesize maxLength;

- (id)initWithMaxLength:(NSInteger)max
{
    if ((self = [super init])) {
        self.maxLength = max;
    }
    return self;
}

- (BOOL)validate:(id *)value forKey:(NSString*)key error:(NSError**)error
{
    BOOL isValid = YES;
    NSInteger length = [*value length];
    if (*value != nil && length > maxLength) {
        isValid = NO;
        if (error != NULL) {
            *error = [NSError validationErrorWithCode:1001 reason:[NSString stringWithFormat:@"%@ length should be less than %ld.",key, (long)maxLength]];
        }
    }
    return isValid;
}

@end
