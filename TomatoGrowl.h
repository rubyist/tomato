#import <Cocoa/Cocoa.h>
#import "TomatoWatcher.h"
#import "Growl/GrowlApplicationBridge.h"

@interface TomatoGrowl : TomatoWatcher <GrowlApplicationBridgeDelegate> {
    BOOL growlReady;
}

@end
