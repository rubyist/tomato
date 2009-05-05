#import "TomatoController.h"
#import "TomatoTimer.h"
#import "PreferenceController.h"

@interface TomatoController(Private)
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
- (id)init {
    if (self = [super init]) {
        tomatoTimer = [[TomatoTimer alloc] init];
        completedTomatoes = 0;
        poppedTomatoes = 0;
        
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
                
    }
    return self;
}



#pragma mark -
#pragma tomatoTimer Notification Methods
- (void)tomatoStarted:(NSNotification *)notification {
    [tomatoButton setTitle:@"Pop"];
    [self updateStatusLine];
}

- (void)tomatoPopped:(NSNotification *)notification {
    poppedTomatoes++;
    [timeLabel setStringValue:@"25:00"];
    [tomatoButton setTitle:@"Start"];
    [self updateStatusLine];
}

- (void)tomatoEnded:(NSNotification *)notification {
    [timeLabel setStringValue:@"05:00"];
    [tomatoButton setTitle:@"Stop"];
    completedTomatoes++;
    [self updateStatusLine];
}

- (void)breakStarted:(NSNotification *)notification {
    [tomatoButton setTitle:@"Stop"];
    [self updateStatusLine];
}

- (void)breakEnded:(NSNotification *)notification {
    [timeLabel setStringValue:@"25:00"];
    [tomatoButton setTitle:@"Start"];
    [self updateStatusLine];
}

- (void)tomatoTick:(NSNotification *)notification {
    [timeLabel setStringValue:[NSString stringWithFormat:@"%02d:%02d", (tomatoTimer.remaining / 60), (tomatoTimer.remaining % 60)]];    
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
    NSLog(@"Showing prefs %@", preferenceController);
    [preferenceController showWindow:self];
}

@end
