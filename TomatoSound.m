#import "TomatoSound.h"

@interface TomatoSound(Private)
- (void)loadNotifications:(NSNotification *)notification;
- (void)watchTomato;
- (void)unwatchTomato;

- (SystemSoundID)initializeSoundFromFile:(NSString *)file;

- (void)tomatoEnded:(NSNotification *)notification;
- (void)breakEnded:(NSNotification *)notification;
@end

@implementation TomatoSound

- (id)init {
    if (self = [super init]) {
        [self loadNotifications:nil];
        
        tomatoSound = [self initializeSoundFromFile:@"Bell"];
        breakSound = [self initializeSoundFromFile:@"Hamon"];
    }
    return self;
}

- (void)loadNotifications:(NSNotification *)notification {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"TOMSound"]) {
        [self watchTomato];
    } else {
        [self unwatchTomato];
    }
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(loadNotifications:)
     name:@"tomatoPreferencesUpdated"
     object:nil];
}

- (void)watchTomato {
    [[NSNotificationCenter defaultCenter] 
     addObserver:self 
     selector:@selector(tomatoEnded:) 
     name:@"tomatoEnded" 
     object:nil]; 
    
    [[NSNotificationCenter defaultCenter] 
     addObserver:self 
     selector:@selector(breakEnded:) 
     name:@"breakEnded" 
     object:nil];    
}

- (void)unwatchTomato {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
