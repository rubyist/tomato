#import "TomatoDock.h"
#import "TomatoTimer.h"

@interface TomatoDock(Private)
- (void)loadNotifications:(NSNotification *)notification;
- (void)watchTomato;
- (void)unwatchTomato;

- (void)tomatoPopped:(NSNotification *)notification;
- (void)tomatoEnded:(NSNotification *)notification;
- (void)tomatoTick:(NSNotification *)notification;
@end

@implementation TomatoDock

- (id)init {
    if (self = [super init]) {
        [self loadNotifications:nil];
    }
    return self;
}

- (void)loadNotifications:(NSNotification *)notification {    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"TOMDock"]) {
        [self watchTomato];
    } else {
        [self unwatchTomato];
        [[[NSApplication sharedApplication] dockTile] setBadgeLabel:@""];
    }
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(loadNotifications:)
     name:@"tomatoPreferencesUpdated"
     object:nil];
}

- (void)watchTomato {
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

- (void)unwatchTomato {
    [[NSNotificationCenter defaultCenter]
     removeObserver:self];
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
