//
//  TomatoController.m
//  Tomato
//
//  Created by Scott Barron on 3/25/09.
//  Copyright 2009. All rights reserved.
//

#import "TomatoController.h"
#import "iChat.h"


@implementation TomatoController

- (void)startTimer {
    timerStart = [NSDate timeIntervalSinceReferenceDate];
    tomatoTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(tick:) userInfo:NULL repeats:YES];
}

- (void)updateStatusLine {
    [statusLabel setStringValue:[NSString stringWithFormat:@"Completed: %d  Popped: %d", completedTomatoes, poppedTomatoes]];
}

- (void)iChatTomatoStatus {
    if ([iChatApp isRunning]) {
        iChatApp.statusMessage = [NSString stringWithFormat:@"tomato (%d minutes)", tickCounter];
    }
}

- (void)iChatInTomato {
    if ([iChatApp isRunning]) {
        iChatApp.status = iChatAccountStatusAway;
        [self iChatTomatoStatus];
    }
}

- (void)iChatOnBreak {
    if ([iChatApp isRunning]) {
        iChatApp.status = iChatAccountStatusAvailable;
        iChatApp.statusMessage = @"tomato break";
    }
}

- (IBAction)tomatoStart:(id)sender {
    if (status == NOTHINGRUNNING) {
        NSLog(@"Starting tomato");
        status = TOMATORUNNING;
        [self startTimer];
        [breakButton setEnabled:NO];
        [tomatoButton setTitle:@"Pop"];
        [self iChatInTomato];
    } else if (status == TOMATORUNNING) {
        NSLog(@"Popping the  tomato");
        poppedTomatoes++;
        [tomatoTimer invalidate];
        [tomatoLabel setStringValue:@"25:00"];
        [breakButton setEnabled:YES];
        [tomatoButton setTitle:@"Start"];
        status = NOTHINGRUNNING;
        [self updateStatusLine];
        [self iChatOnBreak];
    }
}

- (IBAction)breakStart:(id)sender {
    if (status == NOTHINGRUNNING) {
        NSLog(@"Starting break");
        status = BREAKRUNNING;
        [self startTimer];
        [tomatoButton setEnabled:NO];
        [breakButton setTitle:@"Stop"];
        [self iChatOnBreak];
    } else if (status == BREAKRUNNING) {
        NSLog(@"Stopping break");
        [tomatoTimer invalidate];
        [breakLabel setStringValue:@"05:00"];
        [tomatoButton setEnabled:YES];
        [breakButton setTitle:@"Start"];
        status = NOTHINGRUNNING;
    }
}

- (void)playSound {
    if (status == TOMATORUNNING) {
        AudioServicesPlaySystemSound(tomatoSound);
    } else if (status == BREAKRUNNING) {
        AudioServicesPlaySystemSound(breakSound);
    }
}

- (void)expireTimer {
    [self playSound];
    if (status == TOMATORUNNING) {
        [tomatoTimer invalidate];
        [tomatoLabel setStringValue:@"25:00"];
        [breakButton setEnabled:YES];
        [tomatoButton setTitle:@"Start"];
        status = NOTHINGRUNNING;
        completedTomatoes++;
        tickCounter = (TOMATOTIME / 60);
        [self breakStart:nil];
    } else if (status == BREAKRUNNING) {
        [tomatoTimer invalidate];
        [breakLabel setStringValue:@"05:00"];
        [tomatoButton setEnabled:YES];
        [breakButton setTitle:@"Start"];
        status = NOTHINGRUNNING;
    }
    [self updateStatusLine];
}

- (void)tick:(NSTimer *)theTimer {
    NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
    int interval = (int)(now - timerStart);
    NSTextField *field;
    int remaining;
    
    if (status == TOMATORUNNING) {
        remaining = TOMATOTIME - interval;
        field = tomatoLabel;
        if ((tickCounter > 0) && (remaining % 60 == 0)) {
            tickCounter--;
            [self iChatTomatoStatus];
        }
    } else if (status == BREAKRUNNING) {
        remaining = BREAKTIME - interval;
        field = breakLabel;
    }

    [field setStringValue:[NSString stringWithFormat:@"%02d:%02d", (remaining / 60), (remaining % 60)]];
    
    if (remaining == 0) {
        [self expireTimer];
    }
}

- (void)getIChatApp {
    @try {
        iChatApp = (iChatApplication *)[[SBApplication applicationWithBundleIdentifier:@"com.apple.iChat"] retain];
    }
    @catch(NSException *except) {
        NSLog(@"Exception %@", except);
    }
}

- (id)init {
    if (self = [super init]) {
        status = NOTHINGRUNNING;
        completedTomatoes = 0;
        poppedTomatoes = 0;
        tickCounter = (TOMATOTIME / 60);
        
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSURL *aFileURL = [NSURL fileURLWithPath:[mainBundle pathForResource:@"Bell" ofType:@"aif"] isDirectory:NO];
        if (aFileURL != nil) {
            SystemSoundID aSoundID;
            OSStatus error = AudioServicesCreateSystemSoundID((CFURLRef)aFileURL, &aSoundID);
            if (error == kAudioServicesNoError) {
                tomatoSound = aSoundID;
            } else {
                NSLog(@"Error %d loading tomato sound", error);
            }
        }

        aFileURL = [NSURL fileURLWithPath:[mainBundle pathForResource:@"Hamon" ofType:@"aif"] isDirectory:NO];
        if (aFileURL != nil) {
            SystemSoundID aSoundID;
            OSStatus error = AudioServicesCreateSystemSoundID((CFURLRef)aFileURL, &aSoundID);
            if (error == kAudioServicesNoError) {
                breakSound = aSoundID;
            } else {
                NSLog(@"Error %d loading break sound", error);
            }
        }
        
        [self getIChatApp];
    }
    return self;
}

@end
