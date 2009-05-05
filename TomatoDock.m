#import "TomatoDock.h"
#import "TomatoTimer.h"

@implementation TomatoDock

- (BOOL)isEnabled {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"TOMDock"];
}

- (void)unwatchTomato {
    [super unwatchTomato];
    [[[NSApplication sharedApplication] dockTile] setBadgeLabel:@""];
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
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"TOMDockBounce"])
        [[NSApplication sharedApplication] requestUserAttention:NSCriticalRequest];
}

@end
