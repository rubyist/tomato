#import "TomatoView.h"


@implementation TomatoView

- (void)awakeFromNib {
    tomatoImage = [NSImage imageNamed:@"tomato"];
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)rect {
    [[NSColor clearColor] set];
    NSRectFill([self frame]);

    [tomatoImage compositeToPoint:NSZeroPoint operation:NSCompositeSourceOver];
    
    [[self window] invalidateShadow];
}

@end
