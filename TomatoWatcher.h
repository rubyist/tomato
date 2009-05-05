#import <Cocoa/Cocoa.h>


@interface TomatoWatcher : NSObject {

}

- (BOOL)isEnabled;
- (void)loadNotifications:(NSNotification *)notification;
- (void)watchTomato;
- (void)unwatchTomato;

@end
