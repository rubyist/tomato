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
    [autoStartBreakBox setState:[defaults boolForKey:@"TOMautoBreak"]];
    [iChatTomato setStringValue:[defaults stringForKey:@"TOMiChatTomato"]];
    [iChatBreak setStringValue:[defaults stringForKey:@"TOMiChatBreak"]];
    [soundCheckBox setState:[defaults boolForKey:@"TOMSound"]];
    [dockCheckBox setState:[defaults boolForKey:@"TOMDock"]];
    [dockBounceCheckBox setState:[defaults boolForKey:@"TOMDockBounce"]];

    NSNumber *tt = [NSNumber numberWithInt:[[NSUserDefaults standardUserDefaults] integerForKey:@"TOMTomatoTime"]];
    [tomatoTime setObjectValue:tt];

    NSNumber *bt = [NSNumber numberWithInt:[[NSUserDefaults standardUserDefaults] integerForKey:@"TOMBreakTime"]];
    [breakTime setObjectValue:bt];
}

- (void)preferencesChanged:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:[iChatCheckBox state] forKey:@"TOMiChat"];
    [defaults setBool:[autoStartBreakBox state] forKey:@"TOMautoBreak"];
    [defaults setObject:[iChatTomato stringValue] forKey:@"TOMiChatTomato"];
    [defaults setObject:[iChatBreak stringValue] forKey:@"TOMiChatBreak"];
    [defaults setBool:[soundCheckBox state] forKey:@"TOMSound"];
    [defaults setBool:[dockCheckBox state] forKey:@"TOMDock"];
    [defaults setBool:[dockBounceCheckBox state] forKey:@"TOMDockBounce"];

    [defaults setObject:[tomatoTime objectValue] forKey:@"TOMTomatoTime"];
    [defaults setObject:[breakTime objectValue] forKey:@"TOMBreakTime"];
    
    [[NSNotificationCenter defaultCenter] 
     postNotificationName: @"tomatoPreferencesUpdated" object:nil];
}
@end
