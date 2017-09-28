//
//  JSRuleRegex.h
//  JSUIComponents
//
//  Created by Jitendra Singh on 6/26/12.
//  Copyright (c) 2012 JS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSRule.h"


@interface JSRuleRegex : NSObject <JSRule>
{
    NSString *regex;
    NSString *_key;
    NSString *message;
}

@property (nonatomic, retain) NSString *regex;
@property (nonatomic, retain) NSString *message;

- (id)initWithRegex:(NSString*)aRegex;
- (id)initWithRegex:(NSString*)aRegex forKey:(NSString*)key;
@end

