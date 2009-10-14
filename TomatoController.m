#import "TomatoController.h"
#import "TomatoTimer.h"
#import "PreferenceController.h"

@interface TomatoController(Private)
- (void)registerNotifications;

- (void)updateStatusLine;

- (void)tomatoStarted:(NSNotification *)notification;
- (void)tomatoPopped:(NSNotification *)notification;
- (void)tomatoEnded:(NSNotification *)notification;
- (void)breakStarted:(NSNotification *)notification;
- (void)breakEnded:(NSNotification *)notification;
- (void)tomatoTick:(NSNotification *)notification;
@end

@implementation TomatoController

#pragma mark -
#pragma mark Initialization methods
+ (void)initialize {
    NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary];
    [defaultValues setObject:[NSNumber numberWithBool:YES]
                      forKey:@"TOMiChat"];
    [defaultValues setObject:[NSNumber numberWithBool:YES]
                      forKey:@"TOMautoBreak"];
    [defaultValues setObject:[NSNumber numberWithBool:YES]
                      forKey:@"TOMSound"];
    [defaultValues setObject:[NSNumber numberWithBool:YES]
                      forKey:@"TOMDock"];
    [defaultValues setObject:[NSNumber numberWithBool:YES]
                      forKey:@"TOMDockBounce"];
    [defaultValues setObject:@"tomato" forKey:@"TOMiChatTomato"];
    [defaultValues setObject:@"tomato break" forKey:@"TOMiChatBreak"];
    [defaultValues setObject:[NSNumber numberWithInt:1500] forKey:@"TOMTomatoTime"];
    [defaultValues setObject:[NSNumber numberWithInt:300] forKey:@"TOMBreakTime"];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
}

- (id)init {
    if (self = [super init]) {
        tomatoTimer = [[TomatoTimer alloc] init];
        completedTomatoes = 0;
        poppedTomatoes = 0;
        
        [self registerNotifications];
    }
    return self;
}

- (void)setTimerLabelForTomato {
    [timeLabel setObjectValue:[NSNumber numberWithInt:tomatoTimer.tomatoTime]];
}

- (void)setTimerLabelForBreak {
    [timeLabel setObjectValue:[NSNumber numberWithInt:tomatoTimer.breakTime]];
}

- (void)awakeFromNib {
    [self setTimerLabelForTomato];
}

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] 
     addObserver:self 
     selector:@selector(tomatoStarted:) 
     name:@"tomatoStarted" 
     object:tomatoTimer]; 
    
    [[NSNotificationCenter defaultCenter] 
     addObserver:self 
     selector:@selector(tomatoPopped:) 
     name:@"tomatoPopped" 
     object:tomatoTimer]; 
    
    [[NSNotificationCenter defaultCenter] 
     addObserver:self 
     selector:@selector(tomatoEnded:) 
     name:@"tomatoEnded" 
     object:tomatoTimer]; 
    
    [[NSNotificationCenter defaultCenter] 
     addObserver:self 
     selector:@selector(breakStarted:) 
     name:@"breakStarted" 
     object:tomatoTimer]; 
    
    [[NSNotificationCenter defaultCenter] 
     addObserver:self 
     selector:@selector(breakEnded:) 
     name:@"breakEnded" 
     object:tomatoTimer]; 
    
    [[NSNotificationCenter defaultCenter] 
     addObserver:self 
     selector:@selector(tomatoTick:) 
     name:@"tomatoTick" 
     object:tomatoTimer]; 

    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(preferencesUpdated:)
     name:@"tomatoPreferencesUpdated"
     object:nil];
}

#pragma mark -
#pragma tomatoTimer Notification Methods
- (void)tomatoStarted:(NSNotification *)notification {
    [tomatoButton setTitle:@"Pop"];
    [self updateStatusLine];
}

- (void)tomatoPopped:(NSNotification *)notification {
    poppedTomatoes++;
    [self setTimerLabelForTomato];
    [tomatoButton setTitle:@"Start"];
    [self updateStatusLine];
}

- (void)tomatoEnded:(NSNotification *)notification {
    [self setTimerLabelForBreak];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"TOMautoBreak"]) {
        [tomatoButton setTitle:@"Stop"];
    } else {
        [tomatoButton setTitle:@"Start Break"];
    }

    completedTomatoes++;
    [self updateStatusLine];
}

- (void)breakStarted:(NSNotification *)notification {
    [tomatoButton setTitle:@"Stop"];
    [self updateStatusLine];
}

- (void)breakEnded:(NSNotification *)notification {
    [self setTimerLabelForTomato];
    [tomatoButton setTitle:@"Start"];
    [self updateStatusLine];
}

- (void)tomatoTick:(NSNotification *)notification {
    [timeLabel setObjectValue:[NSNumber numberWithInt:tomatoTimer.remaining]];
}

- (void)preferencesUpdated:(NSNotification *)notification {
    if (tomatoTimer.status == NOTHINGRUNNING) {
        // Pull the pref directly because we can't guarantee the timer has reloaded
        [timeLabel setObjectValue:[NSNumber numberWithInt:[[NSUserDefaults standardUserDefaults] integerForKey:@"TOMTomatoTime"]]];
    }
}




- (IBAction)startStopPop:(id)sender {
    [tomatoTimer startStopPop];
}

- (void)updateStatusLine {
    [completedPoppedLabel setStringValue:[NSString stringWithFormat:@"%d/%d", completedTomatoes, poppedTomatoes]];
    switch(tomatoTimer.status) {
        case TOMATORUNNING:
            [statusLabel setStringValue:@"Tomato"];
            break;
        case BREAKRUNNING:
            [statusLabel setStringValue:@"Break"];
            break;
        default:
            [statusLabel setStringValue:@"Waiting"];
    }
}

- (IBAction)showPreferencePanel:(id)sender {
    if (!preferenceController) {
        preferenceController = [[PreferenceController alloc] init];
    }
    [preferenceController showWindow:self];
}

@end
