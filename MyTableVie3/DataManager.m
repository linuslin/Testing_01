//
//  DataManager.m
//  MyTableVie3
//
//  Created by Linus Lin on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataManager.h"

@interface DataManager(PrivateMethod)
- (void) __initDocumentDirectory;
- (void) __initTmpDirectory;
- (void) __initFavoriteDirectory;

- (id) __readFromDirectory:(NSString *)filename;
- (void) __removeFileFrom:(NSString *)path;
   
@end

@implementation DataManager

static DataManager * defaultManager = nil;

@synthesize tmpDirectory, documentsDirectory, favoriteDirectory;


#pragma mark -
#pragma mark construction methods

- (id) init{
    NSLog(@"init DataManager");
    self = [super init];
    if (self) {
        // Work your initialising magic here as you normally would
        // init document directory path;
        [self __initDocumentDirectory];
        [self __initTmpDirectory];
        [self __initFavoriteDirectory];
        // init tmp directory path;
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
    return [[self defaultManger] retain];
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
#pragma mark class mehtods

+ (DataManager *) defaultManger {
    if (defaultManager == nil) {
        defaultManager = [[super allocWithZone:NULL] init];
    }
    return defaultManager;
}


#pragma mark -
#pragma mark instance methods

- (void) writeToTmp:(NSString *)filename:(id)data{
    //NSError * error = [[NSError alloc] init];
    NSString * path = [self.tmpDirectory stringByAppendingPathComponent:filename];
    [data writeToFile:path atomically:YES];
}

- (void) writeToDocuments:(NSString *) filename:(id)data{
    //NSError * error = [[NSError alloc] init];
    NSString * path = [self.documentsDirectory stringByAppendingPathComponent:filename];
    [data writeToFile:path atomically:YES];
}

- (void) writeToFavorite:(NSString *) filename:(id)data{
    //NSError * error = [[NSError alloc] init];
    NSString * path = [self.documentsDirectory stringByAppendingPathComponent:[kFavoriteDirectory stringByAppendingPathComponent:filename]];
    [data writeToFile:path atomically:YES];
}


- (NSMutableDictionary *) readFromDocuments:(NSString *) filename{
    NSString * path = [self.documentsDirectory stringByAppendingPathComponent:filename];
    return [self __readFromDirectory:path];
}

- (NSMutableDictionary *) readFromTmp:(NSString *) filename{
    NSString * path = [self.tmpDirectory stringByAppendingPathComponent:filename];
    return [self __readFromDirectory:path];
}

- (NSMutableDictionary *) readFromFavorite:(NSString *) filename{
    NSString * path = [self.favoriteDirectory stringByAppendingPathComponent:filename];
    NSLog(@"readFromFavorite: %@", filename);
    return [self __readFromDirectory:path];
}


- (void) removeFileFromDocuments:(NSString *) path{
    NSString * truePath = [self.documentsDirectory stringByAppendingPathComponent:path];
    [self __removeFileFrom:truePath];
}
- (void) removeFileFromTmp:(NSString *) path{
    NSString * truePath = [self.tmpDirectory stringByAppendingPathComponent:path];
    [self __removeFileFrom:truePath];
}
- (void) removeFileFromFavorite:(NSString *) path{
    NSString * truePath = [self.favoriteDirectory stringByAppendingPathComponent:path];
    [self __removeFileFrom:truePath];
}

//- (NSArray*) listDirectory:(NSString*)path{
//    NSSearchPathForDirectoriesInDomains
//}

#pragma mark -
#pragma mark private methods

- (void) __initTmpDirectory{
    self.tmpDirectory = NSTemporaryDirectory();
}

- (void) __initDocumentDirectory{
    //NSLog(@"__initDocumentPath")
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentsDir = [paths objectAtIndex:0];
    self.documentsDirectory = documentsDir;
}


- (void) __initFavoriteDirectory{
    NSError * error;
    NSString * path = [self.documentsDirectory stringByAppendingPathComponent:kFavoriteDirectory];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]){
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:&error];
    }
    self.favoriteDirectory = path;
}

- (id) __readFromDirectory:(NSString *)filename{
    NSMutableDictionary * tmpDict = nil;
    if([[NSFileManager defaultManager] fileExistsAtPath:filename]){
        NSString * extension = [filename pathExtension];
        NSLog(@"Extention: %@",extension);
        if([extension isEqualToString:@"plist"]){
            tmpDict = [[[NSMutableDictionary alloc] initWithContentsOfFile:filename] autorelease];
        }else {
            NSLog(@"Not a Plist: %@", [extension isEqualToString:@"plist"]);
        }
    }
    return tmpDict;
}

- (void) __removeFileFrom:(NSString *)path{
    NSError * error;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) //checking file
    {
        if (![[NSFileManager defaultManager] removeItemAtPath:path error:&error]) //Delete
        {
            NSLog(@"Delete file error: %@", error);
        }
    }
}
@end
