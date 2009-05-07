#import <Cocoa/Cocoa.h>

#define NOTHINGRUNNING 0
#define TOMATORUNNING  1
#define BREAKRUNNING   2

@interface TomatoTimer : NSObject {
    int tomatoTime;
    int breakTime;
    
    int status;
    int remaining;
    int tickCounter;

    NSTimer *tomatoTimer;
    NSTimeInterval timerStart;
}

- (void)startStopPop;

@property (nonatomic, readonly) int tomatoTime;
@property (nonatomic, readonly) int breakTime;
@property (nonatomic, readonly) int status;
@property (nonatomic, readonly) int remaining;

@end
