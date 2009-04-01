//
//  TomatoController.m
//  Tomato
//
//  Created by Scott Barron on 3/25/09.
//  Copyright 2009. All rights reserved.
//

#import "TomatoController.h"
#import "iChat.h"

@interface TomatoController(Private)
- (void)startTomato;
- (void)popTomato;
- (void)startBreak;
- (void)stopBreak;
- (void)getIChatApp;
- (void)iChatTomatoStatus;
- (void)iChatInTomato;
- (void)iChatOnBreak;
- (void)updateStatusLine;
- (void)startTimer;
- (void)expireTimer;
- (void)initializeSounds;
- (SystemSoundID)initializeSoundFromFile:(NSString *)file;
@end

@implementation TomatoController

#pragma mark -
#pragma mark Initialization methods
- (id)init {
    if (self = [super init]) {
        status = NOTHINGRUNNING;
        completedTomatoes = 0;
        poppedTomatoes = 0;
        tickCounter = (TOMATOTIME / 60);
        
        [self initializeSounds];
        [self getIChatApp];
    }
    return self;
}

- (void)initializeSounds {
    tomatoSound = [self initializeSoundFromFile:@"Bell"];
    breakSound = [self initializeSoundFromFile:@"Hamon"];
}

- (SystemSoundID)initializeSoundFromFile:(NSString *)file {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSURL *aFileURL = [NSURL fileURLWithPath:[mainBundle pathForResource:file ofType:@"aif"] isDirectory:NO];
    if (aFileURL != nil) {
        SystemSoundID aSoundID;
        OSStatus error = AudioServicesCreateSystemSoundID((CFURLRef)aFileURL, &aSoundID);
        if (error == kAudioServicesNoError) {
            return aSoundID;
        } else {
            NSLog(@"Error %d loading sound %@", error, file);
            return 0;
        }
    }
    return 0;
}


#pragma mark -
#pragma mark IChat Methods
- (void)getIChatApp {
    @try {
        iChatApp = (iChatApplication *)[[SBApplication applicationWithBundleIdentifier:@"com.apple.iChat"] retain];
    }
    @catch(NSException *except) {
        NSLog(@"Exception %@", except);
    }
}

- (void)iChatTomatoStatus {
    return; // This isn't working right
    if ([iChatApp isRunning]) {
        iChatApp.statusMessage = [NSString stringWithFormat:@"tomato (%d minutes)", tickCounter];
    }
}

- (void)iChatInTomato {
    if ([iChatApp isRunning]) {
        iChatApp.status = iChatMyStatusAway;
        iChatApp.statusMessage = @"tomato";
        [self iChatTomatoStatus];
    }
}

- (void)iChatOnBreak {
    if ([iChatApp isRunning]) {
        iChatApp.status = iChatMyStatusAvailable;
        iChatApp.statusMessage = @"tomato break";
    }
}



#pragma mark -
#pragma mark State Change Methods
- (IBAction)startStopPop:(id)sender {
    switch (status) {
        case NOTHINGRUNNING:
            [self startTomato];
            break;
        case TOMATORUNNING:
            [self popTomato];
            break;
        case BREAKRUNNING:
            [self stopBreak];
            break;
    }
}

- (void)startTomato {
    NSLog(@"Starting tomato");
    status = TOMATORUNNING;
    [self startTimer];
    [tomatoButton setTitle:@"Pop"];
    [self updateStatusLine];
    [self iChatInTomato];
}

- (void)popTomato {
    NSLog(@"Popping the  tomato");
    poppedTomatoes++;
    [tomatoTimer invalidate];
    [timeLabel setStringValue:@"25:00"];
    [tomatoButton setTitle:@"Start"];
    status = NOTHINGRUNNING;
    [[[NSApplication sharedApplication] dockTile] setBadgeLabel:@""];
    [self updateStatusLine];
    [self iChatOnBreak];
}

- (void)startBreak {
    NSLog(@"Starting break");
    status = BREAKRUNNING;
    [self startTimer];
    [tomatoButton setTitle:@"Stop"];
    [self updateStatusLine];
    [self iChatOnBreak];
}

- (void)stopBreak {
    NSLog(@"Stopping break");
    [tomatoTimer invalidate];
    [tomatoButton setTitle:@"Start"];
    status = NOTHINGRUNNING;
    [timeLabel setStringValue:@"25:00"];
    [self updateStatusLine];
}

- (void)updateStatusLine {
    [completedPoppedLabel setStringValue:[NSString stringWithFormat:@"%d/%d", completedTomatoes, poppedTomatoes]];
    switch(status) {
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


- (void)playSound {
    if (status == TOMATORUNNING) {
        AudioServicesPlaySystemSound(tomatoSound);
    } else if (status == BREAKRUNNING) {
        AudioServicesPlaySystemSound(breakSound);
    }
}




#pragma mark -
#pragma mark Timer Methods
- (void)startTimer {
    timerStart = [NSDate timeIntervalSinceReferenceDate];
    tomatoTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tick:) userInfo:NULL repeats:YES];
}

- (void)tick:(NSTimer *)theTimer {
    NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
    int interval = (int)(now - timerStart);
    int remaining;
    
    if (status == TOMATORUNNING) {
        remaining = TOMATOTIME - interval;
        
        [[[NSApplication sharedApplication] dockTile] setBadgeLabel:[NSString stringWithFormat:@"%02d:%02d", (remaining / 60), (remaining % 60)]];
        
        if ((tickCounter > 0) && (remaining % 60 == 0)) {
            tickCounter--;
            [self iChatTomatoStatus];
        }
    } else if (status == BREAKRUNNING) {
        remaining = BREAKTIME - interval;
    }
    
    [timeLabel setStringValue:[NSString stringWithFormat:@"%02d:%02d", (remaining / 60), (remaining % 60)]];
    
    if (remaining == 0) {
        [self expireTimer];
    }
}

- (void)expireTimer {
    [self playSound];
    if (status == TOMATORUNNING) {
        [tomatoTimer invalidate];
        [timeLabel setStringValue:@"05:00"];
        [tomatoButton setTitle:@"Stop"];
        status = NOTHINGRUNNING;
        completedTomatoes++;
        tickCounter = (TOMATOTIME / 60);
        [self startBreak];
        [[[NSApplication sharedApplication] dockTile] setBadgeLabel:@""];
    } else if (status == BREAKRUNNING) {
        [tomatoTimer invalidate];
        [timeLabel setStringValue:@"25:00"];
        [tomatoButton setTitle:@"Start"];
        status = NOTHINGRUNNING;
    }
    [self updateStatusLine];
}

@end
