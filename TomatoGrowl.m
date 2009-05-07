#import "TomatoGrowl.h"

@implementation TomatoGrowl

- (id)init {
    if (self = [super init]) {
        [GrowlApplicationBridge setGrowlDelegate:self];
    }
    return self;
}

- (BOOL)isEnabled {
    return YES;
}

- (NSDictionary *)registrationDictionaryForGrowl {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSArray *notifications = [[NSArray alloc] initWithObjects:@"Tomato Ended", @"Break Ended", nil];
    
    [dict setObject:notifications forKey:GROWL_NOTIFICATIONS_ALL];
    [dict setObject:notifications forKey:GROWL_NOTIFICATIONS_DEFAULT];
    
    return dict;    
}

- (NSString *)applicationNameForGrowl {
    return @"Tomato";
}

- (void)tomatoEnded:(NSNotification *)notification {    
    [GrowlApplicationBridge
     notifyWithTitle:@"Tomato Ended"
     description:@"Tomato Ended"
     notificationName:@"Tomato Ended"
     iconData:nil
     priority:0
     isSticky:NO
     clickContext:nil];
}

- (void)breakEnded:(NSNotification *)notification {
    [GrowlApplicationBridge
     notifyWithTitle:@"Break Ended"
     description:@"Break Ended"
     notificationName:@"Break Ended"
     iconData:nil
     priority:0
     isSticky:NO
     clickContext:nil];    
}

@end
