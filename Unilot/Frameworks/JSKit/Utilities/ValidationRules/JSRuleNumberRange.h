//
//  JSRuleNumberRange.h
//  JSUIComponents
//
//  Created by Jitendra Singh on 3/12/12.
//  Copyright (c) 2012 JS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSRule.h"


@interface JSRuleNumberRange : NSObject <JSRule>
{
    NSNumber *minRange;
    NSNumber *maxRange;
}
@property (nonatomic, retain) NSNumber *minRange;
@property (nonatomic, retain) NSNumber *maxRange;

- (id)initWithMinValue:(NSNumber*)min andMaxValue:(NSNumber*)max;

@end

