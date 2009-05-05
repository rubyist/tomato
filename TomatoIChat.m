#import "TomatoIChat.h"
#import "iChat.h"

@interface TomatoIChat(Private)
- (void)loadNotifications:(NSNotification *)notification;
- (void)watchTomato;
- (void)unwatchTomato;

- (void)getIChatApp;
- (void)iChatInTomato;
- (void)iChatOnBreak;

- (void)tomatoStarted:(NSNotification *)notification;
- (void)tomatoPopped:(NSNotification *)notification;
- (void)breakStarted:(NSNotification *)notification;
@end

@implementation TomatoIChat

- (id)init {
    if (self = [super init]) {
        [self getIChatApp];
        [self loadNotifications:nil];        
    }
    return self;
}

- (void)getIChatApp {
    @try {
        iChatApp = (iChatApplication *)[[SBApplication applicationWithBundleIdentifier:@"com.apple.iChat"] retain];
    }
    @catch(NSException *except) {
        NSLog(@"Exception %@", except);
    }
}

- (void)loadNotifications:(NSNotification *)notification {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"TOMiChat"]) {
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
     selector:@selector(breakStarted:) 
     name:@"breakStarted" 
     object:nil];    
}

- (void)unwatchTomato {
    [[NSNotificationCenter defaultCenter]
     removeObserver:self];
}

- (void)iChatInTomato {
    if ([iChatApp isRunning]) {
        iChatApp.status = iChatMyStatusAway;
        iChatApp.statusMessage = @"tomato";
    }
}

- (void)iChatOnBreak {
    if ([iChatApp isRunning]) {
        iChatApp.status = iChatMyStatusAvailable;
        iChatApp.statusMessage = @"tomato break";
    }
}

- (void)tomatoStarted:(NSNotification *)notification {
    [self iChatInTomato];
}

- (void)tomatoPopped:(NSNotification *)notification {
    [self iChatOnBreak];
}

- (void)breakStarted:(NSNotification *)notification {
    [self iChatOnBreak];
}

@end
