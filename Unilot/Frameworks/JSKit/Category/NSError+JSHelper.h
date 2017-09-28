//
//  NSError+Helper.h
//  JSUIComponents
//
//  Created by Jitendra Singh on 10/14/14.
//  Copyright (c) 2014 Jitendra Singh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (JSHelper)

+ (id)validationErrorWithCode:(NSInteger)code reason:(NSString*)reason;
+ (id)validationErrorWithCode:(NSInteger)code reason:(NSString*)reason andDescription:(NSString*)description;
id weakObject(id object);
@end
