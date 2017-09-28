//
//  JSRule.h
//  JSUIComponents
//
//  Created by Jitendra Singh on 3/9/12.
//  Copyright (c) 2012 JS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSError+JSHelper.h"

@protocol JSRule <NSObject>

- (BOOL)validate:(id *)value forKey:(NSString*)key error:(NSError**)error;

@end

// Common import for all rules
#import "JSRuleApply.h"
#import "JSRuleNotNull.h"
#import "JSRuleLength.h"
#import "JSRuleNumberRange.h"
#import "JSRuleNumeric.h"
#import "JSRuleRegex.h"




//Shorthands for creating rules
#define JSCreateRuleLength(length) [[JSRuleLength alloc] initWithMaxLength:length]
#define JSCreateRuleNotNullValue [[JSRuleNotNull alloc] init]
#define JSCreateRuleNumberRangeInt(int1,int2) [[JSRuleNumberRange alloc] initWithMinValue:[NSNumber numberWithLongLong:int1] andMaxValue:[NSNumber numberWithLongLong:int2]]
#define JSCreateRuleNumberRangeFloat(float1,float2) [[JSRuleNumberRange alloc] initWithMinValue:[NSNumber numberWithDouble:float1] andMaxValue:[NSNumber numberWithDouble:float2]]
#define JSCreateRuleNumeric(decimal) [[JSRuleNumeric alloc] initWithDecimalPlace:decimal]
#define JSCreateRuleRegex(regex) [[JSRuleRegex alloc] initWithRegex:regex]
#define JSCreateRuleRegexWithKey(regex, key) [[JSRuleRegex alloc] initWithRegex:regex forKey:key]
