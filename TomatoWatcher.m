#import "TomatoWatcher.h"

@interface TomatoWatcher(Private)
- (void)tomatoStarted:(NSNotification *)notification;
- (void)tomatoPopped:(NSNotification *)notification;
- (void)tomatoEnded:(NSNotification *)notification;
- (void)breakStarted:(NSNotification *)notification;
- (void)breakEnded:(NSNotification *)notification;
- (void)tomatoTick:(NSNotification *)notification;
@end

@implementation TomatoWatcher
- (id)init {
    if (self = [super init]) {
        NSLog(@"Initializing a %@", self);
        [self loadNotifications:nil];
    }
    return self;
}

- (BOOL)isEnabled {
    return FALSE;
}

- (void)loadNotifications:(NSNotification *)notification {
    if ([self isEnabled]) {
        [self watchTomato];
    } else {
        [self unwatchTomato];
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
     selector:@selector(tomatoStarted:) 
     name:@"tomatoStarted" 
     object:nil]; 
    
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
     selector:@selector(breakStarted:) 
     name:@"breakStarted" 
     object:nil]; 
    
    [[NSNotificationCenter defaultCenter] 
     addObserver:self 
     selector:@selector(breakEnded:) 
     name:@"breakEnded" 
     object:nil]; 
    
    [[NSNotificationCenter defaultCenter] 
     addObserver:self 
     selector:@selector(tomatoTick:) 
     name:@"tomatoTick" 
     object:nil];     
}

- (void)unwatchTomato {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)tomatoStarted:(NSNotification *)notification {
}
- (void)tomatoPopped:(NSNotification *)notification {
}
- (void)tomatoEnded:(NSNotification *)notification {
}
- (void)breakStarted:(NSNotification *)notification {
}
- (void)breakEnded:(NSNotification *)notification {
}
- (void)tomatoTick:(NSNotification *)notification {
}

@end
