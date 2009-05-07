#import "TimeFormatter.h"


@implementation TimeFormatter

- (NSString *)stringForObjectValue:(id)obj {
    int n = [obj intValue];
    return [NSString stringWithFormat:@"%02d:%02d", (n / 60), (n % 60)];
}

- (BOOL)getObjectValue:(id *)obj
             forString:(NSString *)string
      errorDescription:(NSString **)errorString {
    NSArray *parts = [string componentsSeparatedByString:@":"];
    if ([parts count] == 2) {
        int total = ([[parts objectAtIndex:0] intValue] * 60) + [[parts objectAtIndex:1] intValue];
        *obj = [NSNumber numberWithInt:total];
        return YES;
    }
    return NO;
}
@end
