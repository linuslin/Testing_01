//
//  ImageMapping.h
//  MyTableVie3
//
//  Created by Linus Lin on 2/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//




#import <Foundation/Foundation.h>
#import "SharedDefinition.h"

#ifndef SharedObject_h
#define SharedObject_h

#define kImageMappingFileName @"__icons"
#define kAppImagePoolFileName @"_AppImages"


@interface SharedObject : NSObject {
    //ImageMapping * sharedInstance;
    NSDictionary * imageMapping;
    NSDictionary * appImagePool;
}

@property (atomic, retain) NSDictionary * imageMapping;
@property (atomic, retain) NSDictionary * appImagePool;

+ (id)sharedInstance;
- (UIImage *) getApplictionImageFrom:(NSString *)key;

@end

#endif