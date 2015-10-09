//
//  TimeEngine.m
//  TimeEngine1
//
//  Created by doyoung gwak on 2014. 9. 7..
//  Copyright (c) 2014년 doyoung gwak. All rights reserved.
//

#import "TimeEngine.h"







@interface TimeEngine () {
    NSTimer *willTimer;
    NSTimer *timer;
}

@property (nonatomic, retain) NSDate *willDate;
@property (nonatomic, retain) NSDate *nowDate;





// DEBUG를 위한 시간 세팅
@property (nonatomic, retain) NSDate *debugStartDate;
@property (nonatomic, retain) NSCalendar *cal;
@property (nonatomic, retain) NSDateComponents *debugCompGap;
//


@end


@implementation TimeEngine

- (void)setChangeType:(enum TimeChangeType)changeType {
    _changeType = changeType;
}


+(TimeEngine *)shared {
    static dispatch_once_t pred;
    static TimeEngine *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[TimeEngine alloc] init];
    });
    return shared;
}
- (instancetype)init {
    if (self=[super init]) {
        
    }
    return self;
}
- (void) MAKE_TIMER {
    if (timer) {[timer invalidate];timer=nil;}
    if (willTimer) {[willTimer invalidate];willTimer=nil;}
    
    NSDate *now = [NSDate date];
    NSLog(@"now : %@", now);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@".SSS"];
    
    NSTimeInterval afterCallInterval = 1.f + 1.f-[[formatter stringFromDate:now] floatValue];
    [self performSelector:@selector(makeTimer)
               withObject:nil
               afterDelay:afterCallInterval];
    [self performSelector:@selector(makeWillTimer)
               withObject:nil
               afterDelay:afterCallInterval-self.afterInterval];
}


- (void) makeTimer {
    if (timer) [timer invalidate];
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd hh:mm:ss:SSS"];
    NSLog(@"make Timer : %@", [formatter stringFromDate:now]);
    if (self.changeType & tType_second) {
        timer = [NSTimer scheduledTimerWithTimeInterval:1.f
                                                 target:self
                                               selector:@selector(callTimerSchedule)
                                               userInfo:nil
                                                repeats:YES];
    } else if (self.changeType & tType_minute) {
        timer = [NSTimer scheduledTimerWithTimeInterval:1.f*60.f
                                                 target:self
                                               selector:@selector(callTimerSchedule)
                                               userInfo:nil
                                                repeats:YES];
    } else if (self.changeType & tType_hour) {
        timer = [NSTimer scheduledTimerWithTimeInterval:1.f*60.f*60.f
                                                 target:self
                                               selector:@selector(callTimerSchedule)
                                               userInfo:nil
                                                repeats:YES];
    } else if (self.changeType & tType_day) {
        timer = [NSTimer scheduledTimerWithTimeInterval:1.f*60.f*60.f*24.f
                                                 target:self
                                               selector:@selector(callTimerSchedule)
                                               userInfo:nil
                                                repeats:YES];
    } else {
        assert(0);
    }
    
}



- (void) makeWillTimer {
    if (willTimer) [willTimer invalidate];
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd hh:mm:ss:SSS"];
    NSLog(@"make will Timer : %@", [formatter stringFromDate:now]);
    if (self.changeType & tType_second) {
        willTimer = [NSTimer scheduledTimerWithTimeInterval:1.f
                                                 target:self
                                               selector:@selector(callWillTimerSchedule)
                                               userInfo:nil
                                                repeats:YES];
    } else if (self.changeType & tType_minute) {
        willTimer = [NSTimer scheduledTimerWithTimeInterval:1.f*60.f
                                                 target:self
                                               selector:@selector(callWillTimerSchedule)
                                               userInfo:nil
                                                repeats:YES];
    } else if (self.changeType & tType_hour) {
        willTimer = [NSTimer scheduledTimerWithTimeInterval:1.f*60.f*60.f
                                                 target:self
                                               selector:@selector(callWillTimerSchedule)
                                               userInfo:nil
                                                repeats:YES];
    } else if (self.changeType & tType_day) {
        willTimer = [NSTimer scheduledTimerWithTimeInterval:1.f*60.f*60.f*24.f
                                                 target:self
                                               selector:@selector(callWillTimerSchedule)
                                               userInfo:nil
                                                repeats:YES];
    } else {
        assert(0);
    }
    
}



// 2. 바로 이전에 호출되는 메서드
- (void) callWillTimerSchedule {
    if (!willTimer) return;
//    
//    
//    
//    NSDate *now = [NSDate date];
//    [now dateByAddingSecond:1];
//   
////    NSLog(@"call will Timer Schedule : %.4i-%.2i-%.2i %.2i:%.2i:%.2i", now.year, now.month, now.day, now.hour, now.minute, now.second);
//    if (DEBUG) {
//        self.debugStartDate = DEBUG_START_DATE;
//    }
//    //
//    if (DEBUG && self.debugStartDate) {
//        now = [self debugDateWithNow:now];
//    }
//    enum TimeChangeType changeType = [self compareNewDate:now originalDate:self.willDate];
//    [self.delegate timeWillChange:now changeType:changeType afterInterval:self.afterInterval];
}

// 1. 정확한 시간에 호출되는 메서드
- (void) callTimerSchedule {
    if (!timer) return;
    
    
    
    NSDate *now = [NSDate date];
  
//    NSLog(@"call Timer Schedule : %.4i-%.2i-%.2i %.2i:%.2i:%.2i", now.year, now.month, now.day, now.hour, now.minute, now.second);
    
    
    
    //
    //
    //
    //
    //
    if (DEBUG) {
        self.debugStartDate = DEBUG_START_DATE;
    }
    //
    if (DEBUG && self.debugStartDate) {
        now = [self debugDateWithNow:now];
    }

    enum TimeChangeType changeType = [self compareNewDate:now originalDate:self.willDate];
    [self.delegate timeChanged:now changeType:changeType];
}


- (enum TimeChangeType) compareNewDate:(NSDate *)newDate originalDate:(NSDate *)originalDate {
    enum TimeChangeType tpye = 0;
    if (!originalDate) {
        tpye += tType_second;
        tpye += tType_minute;
        tpye += tType_hour;
        tpye += tType_day;
        tpye += tType_month;
        tpye += tType_year;
    } else {
        if (originalDate.second!=newDate.second) tpye += tType_second;
        if (originalDate.minute!=newDate.minute) tpye += tType_minute;
        if (originalDate.hour!=newDate.hour) tpye += tType_hour;
        if (originalDate.day!=newDate.day) tpye += tType_day;
        if (originalDate.month!=newDate.month) tpye += tType_month;
        if (originalDate.year!=newDate.year) tpye += tType_year;
    }
    self.willDate = newDate;
    return tpye;
}



- (NSDate *) debugDateWithNow:(NSDate *)now {
    if (DEBUG && self.debugStartDate) {
        NSUInteger unit = NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        if (!self.debugCompGap) {
            self.cal = [NSCalendar currentCalendar];
            self.debugCompGap = [self.cal components:unit
                                            fromDate:self.debugStartDate
                                              toDate:now
                                             options:0];
        }
        now = [self.cal dateFromComponents:[self.cal components:unit
                                                       fromDate:[self.cal dateFromComponents:self.debugCompGap]
                                                         toDate:now
                                                        options:0]];
    }
    return now;
}


@end
