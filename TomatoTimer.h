#import <Cocoa/Cocoa.h>

#define NOTHINGRUNNING 0
#define TOMATORUNNING  1
#define BREAKRUNNING   2

#define TOMATOTIME 5 // 1500
#define BREAKTIME  3 // 300

@interface TomatoTimer : NSObject {
    int status;
    int remaining;
    int tickCounter;

    NSTimer *tomatoTimer;
    NSTimeInterval timerStart;
}

- (void)startStopPop;
// read only tick property
@property (nonatomic, readonly) int status;
@property (nonatomic, readonly) int remaining;

@end
