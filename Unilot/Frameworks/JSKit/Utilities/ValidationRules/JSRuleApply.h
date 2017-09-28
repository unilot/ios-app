//
//  JSRuleApply.h
//  JSUIComponents
//
//  Created by Jitendra Singh on 3/12/12.
//  Copyright (c) 2012 JS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSRule.h"
@interface JSRuleApply : NSObject

+ (BOOL)applyRules:(NSArray*)validationRules toValue:(id *)valueRef forKey:(NSString*)key error:(NSError **)outError;

@end

