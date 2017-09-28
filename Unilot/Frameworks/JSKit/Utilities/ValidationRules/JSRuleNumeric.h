//
//  JSRuleNumeric.h
//  JSUIComponents
//
//  Created by Jitendra Singh on 3/12/12.
//  Copyright (c) 2012 JS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSRule.h"



@interface JSRuleNumeric : NSObject <JSRule>
{
    NSInteger decimalPlace;
}
@property (nonatomic, assign) NSInteger decimalPlace;

- (id)initWithDecimalPlace:(NSInteger)decimal;

@end

