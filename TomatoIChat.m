#import "TomatoIChat.h"
#import "iChat.h"

@interface TomatoIChat(Private)
- (void)getIChatApp;
@end

@implementation TomatoIChat

- (id)init {
    if (self = [super init]) {
        [self getIChatApp];
    }
    return self;
}

- (BOOL)isEnabled {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"TOMiChat"];
}

- (void)getIChatApp {
    @try {
        iChatApp = (iChatApplication *)[[SBApplication applicationWithBundleIdentifier:@"com.apple.iChat"] retain];
    }
    @catch(NSException *except) {
        NSLog(@"Exception %@", except);
    }
}

- (void)iChatInTomato {
    if ([iChatApp isRunning]) {
        iChatApp.status = iChatMyStatusAway;
        iChatApp.statusMessage = [[NSUserDefaults standardUserDefaults] stringForKey:@"TOMiChatTomato"];
    }
}

- (void)iChatOnBreak {
    if ([iChatApp isRunning]) {
        iChatApp.status = iChatMyStatusAvailable;
        iChatApp.statusMessage = [[NSUserDefaults standardUserDefaults] stringForKey:@"TOMiChatBreak"];
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
