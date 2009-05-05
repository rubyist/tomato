#import <Cocoa/Cocoa.h>
#import <AudioToolbox/AudioServices.h>
#import "TomatoWatcher.h"

@interface TomatoSound : TomatoWatcher {
    SystemSoundID tomatoSound;
    SystemSoundID breakSound;
}

@end
