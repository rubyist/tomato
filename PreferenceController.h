#import <Cocoa/Cocoa.h>


@interface PreferenceController : NSWindowController {
    IBOutlet NSButton *iChatCheckBox;
    IBOutlet NSButton *soundCheckBox;
    IBOutlet NSButton *dockCheckBox;
    IBOutlet NSButton *dockBounceCheckBox;
}

- (IBAction)preferencesChanged:(id)sender;
@end
