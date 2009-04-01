//
//  TomatoController.h
//  Tomato
//
//  Created by Scott Barron on 3/25/09.
//  Copyright 2009. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AudioToolbox/AudioServices.h>

#define NOTHINGRUNNING 0
#define TOMATORUNNING  1
#define BREAKRUNNING   2

#define TOMATOTIME 1500
#define BREAKTIME   300

@class iChatApplication;

@interface TomatoController : NSObject {
    int status;
    int tickCounter;
    int completedTomatoes;
    int poppedTomatoes;

    IBOutlet NSTextField *timeLabel;
    IBOutlet NSTextField *statusLabel;
    IBOutlet NSTextField *completedPoppedLabel;
    IBOutlet NSButton *tomatoButton;
    
    NSTimer *tomatoTimer;
    NSTimeInterval timerStart;
    
    SystemSoundID tomatoSound;
    SystemSoundID breakSound;
    
    iChatApplication *iChatApp;
}

- (IBAction)startStopPop:(id)sender;

@end
