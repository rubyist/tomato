#import "TomatoTimer.h"

@interface TomatoTimer(Private)
- (void)startTomato;
- (void)popTomato;
- (void)startBreak;
- (void)stopBreak;
- (void)startTimer;
- (void)expireTimer;
@end

@implementation TomatoTimer

@synthesize status, remaining;

- (id)init {
    if (self = [super init]) {
        status = NOTHINGRUNNING;
        tickCounter = (TOMATOTIME / 60);
        remaining = TOMATOTIME;
    }
    return self;
}

- (void)startStopPop {
    switch (status) {
        case NOTHINGRUNNING:
            [self startTomato];
            break;
        case TOMATORUNNING:
            [self popTomato];
            break;
        case BREAKRUNNING:
            [self stopBreak];
            break;
    }
}

- (void)startTomato {
    status = TOMATORUNNING;
    [self startTimer];
    [[NSNotificationCenter defaultCenter] 
     postNotificationName: @"tomatoStarted" object:self];
}

- (void)popTomato {
    [tomatoTimer invalidate];
    status = NOTHINGRUNNING;
    [[NSNotificationCenter defaultCenter] 
     postNotificationName: @"tomatoPopped" object:self];
}

- (void)startBreak {
    status = BREAKRUNNING;
    [self startTimer];
    [[NSNotificationCenter defaultCenter] 
     postNotificationName: @"breakStarted" object:self];
}

- (void)stopBreak {
    [tomatoTimer invalidate];
    status = NOTHINGRUNNING;
    [[NSNotificationCenter defaultCenter] 
     postNotificationName: @"breakEnded" object:self];
}

- (void)startTimer {
    timerStart = [NSDate timeIntervalSinceReferenceDate];
    tomatoTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tick:) userInfo:NULL repeats:YES];
}

- (void)tick:(NSTimer *)theTimer {
    NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
    int interval = (int)(now - timerStart);
    
    if (status == TOMATORUNNING) {
        remaining = TOMATOTIME - interval;
        
        if ((tickCounter > 0) && (remaining % 60 == 0)) {
            tickCounter--;
        }
    } else if (status == BREAKRUNNING) {
        remaining = BREAKTIME - interval;
    }
    
    [[NSNotificationCenter defaultCenter] 
     postNotificationName: @"tomatoTick" object:self];
    
    if (remaining == 0) {
        [self expireTimer];
    }
}

- (void)expireTimer {
    if (status == TOMATORUNNING) {
        [tomatoTimer invalidate];
        status = NOTHINGRUNNING;
        tickCounter = (TOMATOTIME / 60);
        [[NSNotificationCenter defaultCenter] 
         postNotificationName: @"tomatoEnded" object:self];        
        [self startBreak];
    } else if (status == BREAKRUNNING) {
        [tomatoTimer invalidate];
        status = NOTHINGRUNNING;
        [[NSNotificationCenter defaultCenter] 
         postNotificationName: @"breakEnded" object:self];        
    }
}
@end
