//
//  JSRuleNumeric.m
//  JSUIComponents
//
//  Created by Jitendra Singh on 3/12/12.
//  Copyright (c) 2012 JS. All rights reserved.
//

#import "JSRuleNumeric.h"

@implementation JSRuleNumeric
@synthesize decimalPlace;

- (id)initWithDecimalPlace:(NSInteger)decimal
{
    if ((self = [super init])) {
        self.decimalPlace = decimal;
    }
    return self;
}

- (BOOL)validate:(id *)value forKey:(NSString*)key error:(NSError**)error
{
    BOOL isValid = YES;
    NSString *regexDecimal = @"([0-9]*)?$";
    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    NSString *decimalSeparator = [nf decimalSeparator];
    regexDecimal = [NSString stringWithFormat:@"([0-9]*)?+(\\%@[0-9]*)?$",decimalSeparator];
    if (self.decimalPlace > 0) {
        
    }
    NSPredicate *predicateDecimal = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexDecimal];
    NSString *newVal = *value;
    if ([*value isKindOfClass:[NSNumber class]]) {
        newVal = [*value stringValue];
    }
    
    
    if (newVal) {
        if([predicateDecimal evaluateWithObject:newVal])    //[*value isKindOfClass:[NSNumber class]] this was here in 'if' with OR condition
        {
            isValid = YES;
            
            if (self.decimalPlace) {
                
            }
            
            NSArray *explodedString = [newVal componentsSeparatedByString:decimalSeparator];
            if (self.decimalPlace && [explodedString count]==2) {
                NSString *decimalPart = [explodedString objectAtIndex:1];
                if (decimalPart.length > self.decimalPlace) {
                    if (error != NULL) {
                        isValid = NO;
                        *error = [NSError validationErrorWithCode:1001 reason:[NSString stringWithFormat:@"%@ can have %ld decimal precision only.", key, (long)self.decimalPlace]];
                    }
                }
            }
            else if (self.decimalPlace == 0 && [explodedString count]==2){
                if (error != NULL) {
                    isValid = NO;
                    *error = [NSError validationErrorWithCode:1001 reason:[NSString stringWithFormat:@"%@ should be a non-decimal only.", key]];
                }
            }
            
        }
        else
        {
            if (error != NULL) {
                isValid = NO;
                *error = [NSError validationErrorWithCode:1001 reason:[NSString stringWithFormat:@"%@ must be a valid number.",key]];
            }
            
        }
    }
    return isValid;
}


@end
