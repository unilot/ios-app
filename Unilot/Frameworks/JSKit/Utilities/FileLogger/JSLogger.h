//
//  JSLogger.h
//  JSUIComponents
//
//  Created by Jitendra Singh on 12/3/12.
//  Copyright (c) 2012 JS. All rights reserved.
//

#import <Foundation/Foundation.h>

#define JLog(fmt, ...) [[JSLogger sharedJSLogger] logOfLevel:LogLevelAll method:__PRETTY_FUNCTION__ line:__LINE__ inThread:[[[NSThread currentThread]description] stringByReplacingOccurrencesOfString:@"NSThread:" withString:([NSThread isMainThread]) ? @"Main" : @"Background"] withMessage:fmt, ##__VA_ARGS__];


typedef enum
{
    LogLevelNone = 0,
    LogLevelMethodCalls,
    LogLevelAll
}JSLogLevel;

@interface JSLogger : NSObject
{
    NSFileHandle *logFile;
    JSLogLevel level;
    NSMutableArray *_callStack;
}
@property (nonatomic, assign) JSLogLevel level;

+ (id)sharedJSLogger;
- (void)logOfLevel:(JSLogLevel)logLevel method:(const char *)methodName line:(NSInteger)line inThread:(NSString*)thread withMessage:(NSString *)format, ...;
- (NSString*)methodCallStackTrace;

@end

