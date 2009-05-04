#import "TomatoWindow.h"
#import <AppKit/AppKit.h>

@implementation TomatoWindow
- (id)initWithContentRect:(NSRect)contentRect styleMask:(unsigned int)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag {
    NSWindow *result = [super initWithContentRect:contentRect styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:NO];
    [result setBackgroundColor:[NSColor clearColor]];
    [result setAlphaValue:1.0];
    [result setOpaque:NO];
    [result setHasShadow:YES];
    return result;
}

- (BOOL)canBecomeKeyWindow {
    return YES;
}

- (void)mouseDragged:(NSEvent  *)theEvent {
    NSPoint currentLocation;
    NSPoint newOrigin;
    NSRect screenFrame = [[NSScreen mainScreen] frame];
    NSRect windowFrame = [self frame];
    
    currentLocation = [self convertBaseToScreen:[self mouseLocationOutsideOfEventStream]];
    newOrigin.x = currentLocation.x - initialLocation.x;
    newOrigin.y = currentLocation.y - initialLocation.y;
    
    if ((newOrigin.y + windowFrame.size.height) > (screenFrame.origin.y + screenFrame.size.height) ) {
        newOrigin.y = screenFrame.origin.y + (screenFrame.size.height - windowFrame.size.height);
    }
    
    [self setFrameOrigin:newOrigin];
}

- (void)mouseDown:(NSEvent *)theEvent {
    NSRect windowFrame = [self frame];
    
    initialLocation = [self convertBaseToScreen:[theEvent locationInWindow]];
    initialLocation.x -= windowFrame.origin.x;
    initialLocation.y -= windowFrame.origin.y;
}
    
@end
