//
//  JSLogger.m
//  JSUIComponents
//
//  Created by Jitendra Singh on 12/3/12.
//  Copyright (c) 2012 JS. All rights reserved.
//

#import "JSLogger.h"

#define MaxFileAllowed 5
#define FILE_SIZE_MAX 21     // in MBs
#define STACK_SIZE 50


@interface JSLogger ()
- (void)startWithNewFileIfCrossedThreshold;
@end

@implementation JSLogger
@synthesize level;

+ (id)sharedJSLogger {
    static dispatch_once_t predicate;
    static JSLogger *instance = nil;
    dispatch_once(&predicate, ^{instance = [[self alloc] init];});
    return instance;
}

- (void)dealloc {
    logFile = nil;
    _callStack = nil;
}

- (NSString*)storageDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

- (id) init {
    self = [super init];
    if (self) {
        level = LogLevelAll;
        _callStack = [[NSMutableArray alloc] initWithCapacity:STACK_SIZE];
        NSString *filePath = [[self storageDirectory] stringByAppendingPathComponent:@"application.log"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:filePath])
            [fileManager createFileAtPath:filePath
                                 contents:nil
                               attributes:nil];
        logFile = [NSFileHandle fileHandleForWritingAtPath:filePath];
        [logFile seekToEndOfFile];
    }
    return self;
}

- (void)logOfLevel:(JSLogLevel)logLevel method:(const char *)methodName line:(NSInteger)line inThread:(NSString*)thread withMessage:(NSString *)format, ...
{
    
#ifdef DEBUG
    logLevel = LogLevelAll;
#endif
    
    va_list ap;
    va_start(ap, format);
    NSMutableString *logDesc = [NSMutableString stringWithCapacity:0];
    if (format && logLevel > LogLevelMethodCalls) {
        NSString *msg = [[NSString alloc] initWithFormat:format arguments:ap];
        [logDesc appendString:msg];
    }
    
    
    @synchronized(logFile)
    {
        [self startWithNewFileIfCrossedThreshold];
        
        NSMutableString *message = [[NSMutableString alloc] initWithCapacity:0];
        NSString *msg = [[NSString alloc] initWithFormat:@" %@:%s(%ld)",thread, methodName, (long)line];
        [message appendString:msg];
        
        if (logDesc.length) {
            [message appendString:logDesc];
        }
        
        
#ifdef DEBUG
        NSLog(@"%@",message);
#endif
        NSDate *today = [NSDate date];
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        [gregorian setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        NSDateComponents *weekdayComponents = [gregorian components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:today];
        NSInteger day = [weekdayComponents day];
        NSInteger month = [weekdayComponents month];
        NSInteger year = [weekdayComponents year];
        NSInteger hour = [weekdayComponents hour];
        NSInteger min = [weekdayComponents minute];
        NSInteger sec = [weekdayComponents second];
        [message insertString:[NSString stringWithFormat:@"%ld-%ld-%ld %ld:%ld:%ld",(long)year, (long)month, (long)day, (long)hour, (long)min, (long)sec] atIndex:0];
        
        if(message.length) {
            [_callStack insertObject:message atIndex:0];
        }
        if ([_callStack count] > STACK_SIZE) {
            [_callStack removeLastObject];
        }
        
        
        [logFile writeData:[[message stringByAppendingString:@"\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [logFile synchronizeFile];
        
    }
    
}

- (void)startWithNewFileIfCrossedThreshold
{
    NSString *filePath = [[self storageDirectory] stringByAppendingPathComponent:@"application.log"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:filePath error:NULL];
    if ([fileAttributes fileSize] > (FILE_SIZE_MAX*1024*1024)) {
        
        NSInteger fileCounter = [self nextFileCounter];
        NSString *newPath = [[self storageDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"application%ld.log.zip", (long)fileCounter]];
        [fileManager removeItemAtPath:newPath error:NULL];
        
        [fileManager removeItemAtPath:filePath error:NULL];
        
        [fileManager createFileAtPath:filePath
                             contents:nil
                           attributes:nil];
        logFile = nil;
        
        logFile = [NSFileHandle fileHandleForWritingAtPath:filePath];
        [logFile seekToEndOfFile];
    }
    
}

- (NSInteger)nextFileCounter
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *files = [fileManager contentsOfDirectoryAtPath:[self storageDirectory] error:nil];
    NSPredicate *myTest = [NSPredicate predicateWithFormat:@"SELF ENDSWITH '.log.zip' AND SELF BEGINSWITH 'application'"];
    NSArray *filesFiltered = [files filteredArrayUsingPredicate:myTest];
    if (filesFiltered.count == 0) {
        return 1;
    }
    NSMutableArray *existingLogFiles = [NSMutableArray arrayWithCapacity:0];
    [filesFiltered enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *fileName = obj;
        
        NSString *subString = nil;
        NSRange range = NSMakeRange(0, 0);
        NSRange range2 = NSMakeRange(fileName.length, 0);
        range = [fileName rangeOfString:@"application"];
        range2 = [fileName rangeOfString:@".log.zip"];
        
        if (range.location != NSNotFound && range2.location != NSNotFound) {
            subString = [fileName substringWithRange:NSMakeRange(range.location+range.length, range2.location-(range.location+range.length))];
        }
        fileName = subString;
        [existingLogFiles addObject:[NSNumber numberWithInt:fileName.intValue]];
    }];
    [existingLogFiles sortUsingSelector:@selector(compare:)];
    
    if (existingLogFiles.count >= MaxFileAllowed) {
        NSString *filePath = [[self storageDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"application%ld.log.zip", [[existingLogFiles firstObject] longValue]]];
        [fileManager removeItemAtPath:filePath error:nil];
    }
    
    return [[existingLogFiles lastObject] integerValue]+1;
}


- (NSString*)methodCallStackTrace
{
    if ([_callStack count] == 0) {
        return nil;
    }
    return [_callStack description];
}


@end

