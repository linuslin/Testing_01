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

#define kFavoriteName @"favoriteName"
#define kFavoriteDescription @"favoriteDescription"

@interface DataManager : NSObject{
    NSString * documentsDirectory;
    NSString * tmpDirectory;
    NSString * favoriteDirectory;
}

@property (nonatomic, copy) NSString * documentsDirectory;
@property (nonatomic, copy) NSString * tmpDirectory;
@property (nonatomic, copy) NSString * favoriteDirectory;


+ (DataManager *) defaultManger;


- (void) writeToTmp:(NSString *)filename: (id)data;
- (void) writeToDocuments:(NSString *) filename: (id)data;
- (void) writeToFavorite:(NSString *) filename: (id)data;

- (NSMutableDictionary *) readFromDocuments:(NSString *) filename;
- (NSMutableDictionary *) readFromTmp:(NSString *) filename;
- (NSMutableDictionary *) readFromFavorite:(NSString *) filename;

- (void) removeFileFromDocuments:(NSString *) path;
- (void) removeFileFromTmp:(NSString *) path;
- (void) removeFileFromFavorite:(NSString *) path;

@end

#endif