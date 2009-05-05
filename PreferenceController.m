#import "PreferenceController.h"


@implementation PreferenceController

- (id)init {
    if (![super initWithWindowNibName:@"Preferences"])
        return nil;
    return self;
}
@end
