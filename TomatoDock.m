#import "TomatoDock.h"
#import "TomatoTimer.h"

@interface TomatoDock(Private)
- (void)tomatoPopped:(NSNotification *)notification;
- (void)tomatoEnded:(NSNotification *)notification;
- (void)tomatoTick:(NSNotification *)notification;
@end

@implementation TomatoDock

- (id)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] 
         addObserver:self 
         selector:@selector(tomatoPopped:) 
         name:@"tomatoPopped"
         object:nil]; 
        
        [[NSNotificationCenter defaultCenter] 
         addObserver:self 
         selector:@selector(tomatoEnded:) 
         name:@"tomatoEnded"
         object:nil]; 

        [[NSNotificationCenter defaultCenter] 
         addObserver:self 
         selector:@selector(tomatoTick:) 
         name:@"tomatoTick"
         object:nil];
    }
    return self;
}

- (void)tomatoPopped:(NSNotification *)notification {
    [[[NSApplication sharedApplication] dockTile] setBadgeLabel:@""];
}

- (void)tomatoTick:(NSNotification *)notification {
    TomatoTimer *timer = [notification object];
    
    if (timer.status == TOMATORUNNING) {
        [[[NSApplication sharedApplication] dockTile] setBadgeLabel:[NSString stringWithFormat:@"%02d:%02d", (timer.remaining / 60), (timer.remaining % 60)]];
    }
}

- (void)tomatoEnded:(NSNotification *)notification {
    [[[NSApplication sharedApplication] dockTile] setBadgeLabel:@""];    
}
@end
