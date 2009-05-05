#import "TomatoSound.h"

@interface TomatoSound(Private)
- (SystemSoundID)initializeSoundFromFile:(NSString *)file;
@end

@implementation TomatoSound

- (id)init {
    if (self = [super init]) {        
        tomatoSound = [self initializeSoundFromFile:@"Bell"];
        breakSound  = [self initializeSoundFromFile:@"Hamon"];
    }
    return self;
}

- (BOOL)isEnabled {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"TOMSound"];
}

- (SystemSoundID)initializeSoundFromFile:(NSString *)file {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSURL *aFileURL = [NSURL fileURLWithPath:[mainBundle pathForResource:file ofType:@"aif"] isDirectory:NO];
    if (aFileURL != nil) {
        SystemSoundID aSoundID;
        OSStatus error = AudioServicesCreateSystemSoundID((CFURLRef)aFileURL, &aSoundID);
        if (error == kAudioServicesNoError) {
            return aSoundID;
        } else {
            NSLog(@"Error %d loading sound %@", error, file);
            return 0;
        }
    }
    return 0;
}

- (void)tomatoEnded:(NSNotification *)notification {
    AudioServicesPlaySystemSound(tomatoSound);    
}

- (void)breakEnded:(NSNotification *)notification {
    AudioServicesPlaySystemSound(breakSound);    
}

@end
