//
//  JSRuleRegex.m
//  JSUIComponents
//
//  Created by Jitendra Singh on 6/26/12.
//  Copyright (c) 2012 JS. All rights reserved.
//

#import "JSRuleRegex.h"
#import "NSString+JSHelper.h"

@implementation JSRuleRegex
@synthesize regex;
@synthesize message;

- (id)initWithRegex:(NSString*)aRegex
{
    if ((self = [super init])) {
        self.regex = aRegex;
    }
    return self;
}

- (id)initWithRegex:(NSString*)aRegex forKey:(NSString*)key
{
    if ((self = [super init])) {
        self.regex = aRegex;
        _key = key;
    }
    return self;
}

- (BOOL)validate:(id *)value forKey:(NSString*)key error:(NSError**)error
{
    if (*value == nil) {
        return YES;
    }
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", self.regex];
    BOOL isValid = [emailTest evaluateWithObject:*value];
    if (!isValid) {
        if (NSStringHasData(_key)) {
            key = _key;
        }
        NSString *errMessage = message;
        if (!NSStringHasData(errMessage)) {
            errMessage = [NSString stringWithFormat:@" %@ format is invalid.",key];
        }
        if (error != NULL) {
            *error = [NSError validationErrorWithCode:1001 reason:[NSString stringWithFormat:@"Invalid %@ format.",key] andDescription:errMessage];
        }
    }
    return isValid;
}

@end
