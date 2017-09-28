//
//  JSRuleNumberRange.m
//  JSUIComponents
//
//  Created by Jitendra Singh on 3/12/12.
//  Copyright (c) 2012 JS. All rights reserved.
//

#import "JSRuleNumberRange.h"

@implementation JSRuleNumberRange

@synthesize minRange;
@synthesize maxRange;

- (id)initWithMinValue:(NSNumber*)min andMaxValue:(NSNumber*)max
{
    if ((self = [super init])) {
        self.minRange = min;
        self.maxRange = max;
    }
    return self;
}

- (BOOL)validate:(id *)value forKey:(NSString*)key error:(NSError**)error
{
    BOOL isValid = YES;
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    NSString *decimalSeparator = [nf decimalSeparator];
    NSString *numberRegex = [NSString stringWithFormat:@"([0-9]*)?+(\\%@[0-9]{0,100})?$",decimalSeparator];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex];
    id str = *value;
    if ([*value respondsToSelector:@selector(stringValue)]) {
        str = [*value stringValue];
    }
    NSNumber *num = [nf numberFromString:str];
    if (str != nil && ![predicate evaluateWithObject:str]) {
        isValid = NO;
        if (error != NULL) {
            *error = [NSError validationErrorWithCode:1001 reason:[NSString stringWithFormat:@"%@ should be numeric only.",key]];
        }
    }
    else if (num != nil && ([num doubleValue] > [maxRange doubleValue] || [num doubleValue] < [minRange doubleValue])) {
        isValid = NO;
        if (error != NULL) {
            *error = [NSError validationErrorWithCode:1001 reason:[NSString stringWithFormat:@"%@ must be between %@ and %@.",key, [minRange stringValue], [maxRange stringValue]]];
        }
    }
    return isValid;
}


@end
