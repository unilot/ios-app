//
//  JSRuleLength.h
//  JSUIComponents
//
//  Created by Jitendra Singh on 3/9/12.
//  Copyright (c) 2012 JS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSRule.h"


@interface JSRuleLength : NSObject <JSRule>
@property (nonatomic, assign) NSInteger maxLength;

- (id)initWithMaxLength:(NSInteger)max;

@end

