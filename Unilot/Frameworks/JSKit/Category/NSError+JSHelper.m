//
//  NSError+Helper.m
//  JSUIComponents
//
//  Created by Jitendra Singh on 10/14/14.
//  Copyright (c) 2014 Jitendra Singh. All rights reserved.
//

#import "NSError+JSHelper.h"

@implementation NSError (JSHelper)

+ (id)validationErrorWithCode:(NSInteger)code reason:(NSString*)reason
{
    NSArray *objArray = [NSArray arrayWithObjects:reason, reason, nil];
    NSArray *keyArray = [NSArray arrayWithObjects:NSLocalizedDescriptionKey, NSLocalizedFailureReasonErrorKey, nil];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjects:objArray forKeys:keyArray];
    NSError *error = [NSError errorWithDomain:@"InputValidationErrorDomain" code:code userInfo:userInfo];
    return error;
}

+ (id)validationErrorWithCode:(NSInteger)code reason:(NSString*)reason andDescription:(NSString*)description
{
    NSArray *objArray = [NSArray arrayWithObjects:description, reason, nil];
    NSArray *keyArray = [NSArray arrayWithObjects:NSLocalizedDescriptionKey, NSLocalizedFailureReasonErrorKey, nil];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjects:objArray forKeys:keyArray];
    NSError *error = [NSError errorWithDomain:@"InputValidationErrorDomain" code:code userInfo:userInfo];
    return error;
}

id weakObject(id object) {
    __weak __typeof__(object) weakSelf = object;
    return weakSelf;
}

@end
