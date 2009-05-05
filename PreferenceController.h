#import <Cocoa/Cocoa.h>


@interface PreferenceController : NSWindowController {
    IBOutlet NSButton *iChatCheckBox;
    IBOutlet NSButton *soundCheckBox;
    IBOutlet NSButton *dockCheckBox;
    IBOutlet NSButton *dockBounceCheckBox;
    IBOutlet NSTextField *iChatTomato;
    IBOutlet NSTextField *iChatBreak;
}

- (IBAction)preferencesChanged:(id)sender;
@end
