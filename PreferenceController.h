#import <Cocoa/Cocoa.h>


@interface PreferenceController : NSWindowController {
    IBOutlet NSButton *iChatCheckBox;
    IBOutlet NSButton *soundCheckBox;
    IBOutlet NSButton *dockCheckBox;
}

- (IBAction)preferencesChanged:(id)sender;
@end
