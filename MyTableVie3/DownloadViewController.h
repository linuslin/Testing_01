//
//  DownloadViewController.h
//  MyTableVie3
//
//  Created by Linus Lin on 4/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "SharedObject.h"
#import "SharedDefinition.h"


@interface DownloadViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>{
    NSMutableData * fileData;
	NSURLConnection * connectionInProgress;
}

- (IBAction)clickDownloadButton:(id)sender;

- (void)DownloadFileFromUrl:(NSString *)fileURL;

@end
