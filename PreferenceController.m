#import "PreferenceController.h"


@implementation PreferenceController

- (id)init {
    if (![super initWithWindowNibName:@"Preferences"])
        return nil;
    return self;
}

- (void)windowDidLoad {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [iChatCheckBox setState:[defaults boolForKey:@"TOMiChat"]];
    [soundCheckBox setState:[defaults boolForKey:@"TOMSound"]];
    [dockCheckBox setState:[defaults boolForKey:@"TOMDock"]];
    [dockBounceCheckBox setState:[defaults boolForKey:@"TOMDockBounce"]];
}

- (void)preferencesChanged:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:[iChatCheckBox state] forKey:@"TOMiChat"];
    [defaults setBool:[soundCheckBox state] forKey:@"TOMSound"];
    [defaults setBool:[dockCheckBox state] forKey:@"TOMDock"];
    [defaults setBool:[dockBounceCheckBox state] forKey:@"TOMDockBounce"];

    [[NSNotificationCenter defaultCenter] 
     postNotificationName: @"tomatoPreferencesUpdated" object:nil];
}
@end
