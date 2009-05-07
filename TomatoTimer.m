#import "TomatoTimer.h"

@interface TomatoTimer(Private)
- (void)loadTimesFromPreferences;
- (void)startTomato;
- (void)popTomato;
- (void)startBreak;
- (void)stopBreak;
- (void)startTimer;
- (void)expireTimer;
@end

@implementation TomatoTimer

@synthesize tomatoTime, breakTime, status, remaining;

- (id)init {
    if (self = [super init]) {
        [self loadTimesFromPreferences];
        
        status = NOTHINGRUNNING;
        tickCounter = (tomatoTime / 60);
        remaining = tomatoTime;
        
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(preferencesUpdated:)
         name:@"tomatoPreferencesUpdated"
         object:nil];
    }
    return self;
}

- (void)loadTimesFromPreferences {
    tomatoTime = [[NSUserDefaults standardUserDefaults] integerForKey:@"TOMTomatoTime"];
    breakTime  = [[NSUserDefaults standardUserDefaults] integerForKey:@"TOMBreakTime"];    
}

- (void)preferencesUpdated:(NSNotification *)notification {
    [self loadTimesFromPreferences];
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
        remaining = tomatoTime - interval;
        
        if ((tickCounter > 0) && (remaining % 60 == 0)) {
            tickCounter--;
        }
    } else if (status == BREAKRUNNING) {
        remaining = breakTime - interval;
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
        tickCounter = (tomatoTime / 60);
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
