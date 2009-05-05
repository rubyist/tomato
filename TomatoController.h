#import <Cocoa/Cocoa.h>

@class TomatoTimer;
@class PreferenceController;

@interface TomatoController : NSObject {
    TomatoTimer *tomatoTimer;
    
    int completedTomatoes;
    int poppedTomatoes;

    IBOutlet NSTextField *timeLabel;
    IBOutlet NSTextField *statusLabel;
    IBOutlet NSTextField *completedPoppedLabel;
    IBOutlet NSButton *tomatoButton;
    
    PreferenceController *preferenceController;
}

- (IBAction)startStopPop:(id)sender;
- (IBAction)showPreferencePanel:(id)sender;

@end
