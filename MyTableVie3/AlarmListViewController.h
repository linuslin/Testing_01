//
//  AlarmListViewController.h
//  MyTableVie3
//
//  Created by Linus Lin on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlarmViewController.h"

const static NSUInteger kLABEL_TAG = 100;
const static NSUInteger kSWITCH_TAG = 110;
const static NSString * kAlarmListCellLabel = @"LabelTag";
const static NSString * kAlarmListCellSwitch = @"SwitchTag";

@interface AlarmListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray * timerArray;
    UITableViewCell * selectedCell;
}

@property (nonatomic, retain) NSMutableArray * timerArray;
@property (nonatomic, retain) IBOutlet UITableViewCell * selectedCell;

- (IBAction)tapSwitch:(id)sender;
@end
