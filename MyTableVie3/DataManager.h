//
//  DataManager.h
//  MyTableVie3
//
//  Created by Linus Lin on 2/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef DataManager_h
#define DataManager_h

#define kFavoriteDirectory @"favorite"
#define kDownloadDirectory @"download"

#define kFavoriteName @"favoriteName"
#define kFavoriteDescription @"favoriteDescription"
#define kRealFileName @"realFileName"

typedef enum DATAMANAGERDIRECTORY {
    DOCUMENTDIRECTORY = 0,
    FAVORITEDIRECTORY = 1,
    TMPDIRECTORY = 2,
    DOWNLOADDIRECTORY = 3
} DATAMANAGERDIRECTORY;

@interface DataManager : NSObject{
    NSString * documentsDirectory;
    NSString * tmpDirectory;
    NSString * favoriteDirectory;
    NSString * downloadDirectory;
    //NSMutableArray * fileInfoArray;
}

@property (nonatomic, copy) NSString * documentsDirectory;
@property (nonatomic, copy) NSString * tmpDirectory;
@property (nonatomic, copy) NSString * favoriteDirectory;
@property (nonatomic, copy) NSString * downloadDirectory;
//@property (nonatomic, retain) NSString * fileInfoArray;

+ (DataManager *) defaultManger;

- (void) saveData:(id)data asFileName:(NSString *)filename inDirectory:(DATAMANAGERDIRECTORY) Directory;
- (void) saveData:(id)data atPath:(NSString *) path;
- (void) writeToTmp:(NSString *)filename :(id)data;
- (void) writeToDocuments:(NSString *) filename :(id)data;
- (void) writeToFavorite:(NSString *) filename :(id)data;
- (void) writeToDownload:(NSString *) filename data:(id)data;


- (NSMutableDictionary *) readFromDocuments:(NSString *) filename;
- (NSMutableDictionary *) readFromTmp:(NSString *) filename;
- (NSMutableDictionary *) readFromFavorite:(NSString *) filename;
- (NSMutableDictionary *) readFromDownload:(NSString *) filename;

- (void) removeFileFromDocuments:(NSString *) path;
- (void) removeFileFromTmp:(NSString *) path;
- (void) removeFileFromFavorite:(NSString *) path;
- (void) removeFileFromDownload:(NSString *) path;

- (NSMutableArray *) getFileInfoArray;

@end

#endif