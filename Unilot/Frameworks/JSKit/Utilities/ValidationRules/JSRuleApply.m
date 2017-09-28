//
//  JSRuleApply.m
//  JSUIComponents
//
//  Created by Jitendra Singh on 3/12/12.
//  Copyright (c) 2012 JS. All rights reserved.
//

#import "JSRuleApply.h"

@implementation JSRuleApply

+ (BOOL)applyRules:(NSArray*)validationRules toValue:(id *)valueRef forKey:(NSString*)key error:(NSError **)outError
{
    // loop through all the validation and validate the value for each rule
    int index = 0;
    BOOL isValid = YES;
    while (isValid && index < [validationRules count]) {
        id <JSRule> rule = [validationRules objectAtIndex:index];
        isValid = [rule validate:&*valueRef forKey:(NSString*)key error:&*outError];
        index++;
    }
    return isValid;
}

@end

