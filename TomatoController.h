#import <Cocoa/Cocoa.h>

@class TomatoTimer;

@interface TomatoController : NSObject {
    TomatoTimer *tomatoTimer;
    
    int completedTomatoes;
    int poppedTomatoes;

    IBOutlet NSTextField *timeLabel;
    IBOutlet NSTextField *statusLabel;
    IBOutlet NSTextField *completedPoppedLabel;
    IBOutlet NSButton *tomatoButton;
}

- (IBAction)startStopPop:(id)sender;

@end
