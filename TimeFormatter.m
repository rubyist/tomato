#import "TimeFormatter.h"


@implementation TimeFormatter

- (NSString *)stringForObjectValue:(id)obj {
    int n = [obj intValue];
    return [NSString stringWithFormat:@"%02d:%02d", (n / 60), (n % 60)];
}

- (BOOL)getObjectValue:(id *)obj
             forString:(NSString *)string
      errorDescription:(NSString **)errorString {
    NSLog(@"Building object for %@", *obj);
    *obj = [NSNumber numberWithInt:0];
    return YES;
}
@end
