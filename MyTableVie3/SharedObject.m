//
//  ImageMapping.m
//  MyTableVie3
//
//  Created by Linus Lin on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SharedObject.h"

@interface SharedObject (PrivateMethods)
- (void) _initImageMapping;
- (void) _initAppImagePool;
@end


@implementation SharedObject

static SharedObject *sharedInstance = nil;

@synthesize imageMapping;
@synthesize appImagePool;

// Get the shared instance and create it if necessary.
+ (SharedObject *)sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    
    return sharedInstance;
}

// We can still have a regular init method, that will get called the first time the Singleton is used.
- (id)init
{
    self = [super init];
    
    if (self) {
        // Work your initialising magic here as you normally would
        [self _initImageMapping];
        [self _initAppImagePool];
    }
    
    return self;
}

// Your dealloc method will never be called, as the singleton survives for the duration of your app.
// However, I like to include it so I know what memory I'm using (and incase, one day, I convert away from Singleton).
-(void)dealloc
{
    // I'm never called!
    [super dealloc];
}

// We don't want to allocate a new instance, so return the current one.
+ (id)allocWithZone:(NSZone*)zone {
    return [[self sharedInstance] retain];
}

// Equally, we don't want to generate multiple copies of the singleton.
- (id)copyWithZone:(NSZone *)zone {
    return self;
}

// Once again - do nothing, as we don't have a retain counter for this object.
- (id)retain {
    return self;
}

// Replace the retain counter so we can never release this object.
- (NSUInteger)retainCount {
    return NSUIntegerMax;
}

// This function is empty, as we don't want to let the user release this object.
- (oneway void)release {
    
}

//Do nothing, other than return the shared instance - as this is expected from autorelease.
- (id)autorelease {
    return self;
}


#pragma mark -
#pragma mark imageMapping Methods

- (void) _initImageMapping{
    NSString *path = [[NSBundle mainBundle] pathForResource:
                      kImageMappingFileName ofType:@"plist"];
    
    // Build the array from the plist  
    if([[NSFileManager defaultManager] fileExistsAtPath:path]){
        //NSMutableArray * array = [[NSMutableArray alloc] initWithContentsOfFile:path];
        NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        self.imageMapping = dict;
        [dict release];
        NSLog(@"imageMapping %@", self.imageMapping);
    }
}

- (void) _initAppImagePool{
    NSString *path = [[NSBundle mainBundle] pathForResource:
                      kAppImagePoolFileName ofType:@"plist"];
     
    if([[NSFileManager defaultManager] fileExistsAtPath:path]){
        NSMutableDictionary * pathDict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        NSArray * keyArray = [[NSArray alloc] initWithObjects:
                              kPlayButtonImage,
                              kPauseButtonImage,
                              kLoopButtonImage,
                              kLoadButtonImage,
                              kTimerButtonImage,
                              kInfoButtonImage
                              kClockButtonImage,nil];
        NSLog(@"pathDict: %@",pathDict);
        NSMutableDictionary * tmpDict = [[NSMutableDictionary alloc] init];
        for (NSString * key in keyArray) {
            NSString * imgType = [[pathDict objectForKey:key] pathExtension];
            NSString * imgFileName = [[pathDict objectForKey:key] stringByDeletingPathExtension];
            NSString * imgPath = [[NSBundle mainBundle] pathForResource:
                              imgFileName ofType:imgType];
            
            NSLog(@"imagePath: %@",imgPath);
            if([[NSFileManager defaultManager] fileExistsAtPath:imgPath]){
                UIImage * img = [UIImage imageWithContentsOfFile:imgPath];
                [tmpDict setValue:img forKey:[NSString stringWithString:key]];
            }
            else{
                NSLog(@"_initAppImagePool Fail: No image path for key: %@",key);
            }
        }
        self.appImagePool = tmpDict;
        
        [keyArray release];
        [pathDict release];
        [tmpDict release];
        NSLog(@"appImagePool %@", self.appImagePool);
    }
}

- (UIImage *) getApplictionImageFrom:(NSString *)key{
    return [self.appImagePool objectForKey:key];
}
@end
