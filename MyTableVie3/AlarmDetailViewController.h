//
//  AlarmDetailViewController.h
//  MyTableVie3
//
//  Created by Linus Lin on 5/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum ALRARM_DETAIL_VIEW_TYPE {
    SNOOZE = 0,
    FADEIN = 1,
    FADEOUT = 2
}ALRARM_DETAIL_VIEW_TYPE;

@interface AlarmDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    UITableView * myTableView;
    NSArray * dataArray;
    NSIndexPath * selectedIndexPath;
    NSString * navigationTitle;
    SEL callBackSelector;
}

@property (nonatomic, retain) IBOutlet UITableView * myTableView;
@property (nonatomic, retain) NSArray * dataArray;
@property (nonatomic, retain) NSIndexPath * selectedIndexPath;
@property (nonatomic, copy) NSString * navigationTitle;
@property (nonatomic, assign) SEL callBackSelector;

- (IBAction)tapDone:(id)sender;
//- (IBAction)tapCancel:(id)sender;
@end
