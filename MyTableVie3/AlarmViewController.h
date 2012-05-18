//
//  AlarmViewController.h
//  MyTableVie3
//
//  Created by Linus Lin on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectSoundContorller.h"
#import "AlarmDetailViewController.h"

static NSString * SOUND_LABEL = @"Sound";
static NSString * FADEOUT_LABEL = @"Fade In";
static NSString * SNOOZE_LABEL = @"Snooze";

static NSMutableDictionary * FadeTimeDict;
static NSMutableDictionary * SnoozeTimeDict;
static NSMutableDictionary * AlarmDefinition;

static NSString * kFadeTime = @"FadeInOutSecondsDict";
static NSString * kSnoozeTime = @"SnoozeSecondsDict";

static NSString * kAlarmDefinitionFileName = @"AlarmDefinition.plist";

static NSString * kTextLableText = @"kTextLableText";
static NSString * kDetailLableText = @"kDetailLableText";

@interface AlarmViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    UITableView * myTableView;
    UIDatePicker * datePicker;
    UITableViewCell * tableViewCell;
    UISegmentedControl * segmentedControl;
    NSMutableArray * labelArray;
    
    NSInteger fadeTime;
    NSInteger snoozeTime;
    NSString * selectedSong;
    
}

@property (nonatomic, retain) UITableView * myTableView;
@property (nonatomic, retain) UIDatePicker * datePicker;
@property (nonatomic, retain) UITableViewCell * tableViewCell;
@property (nonatomic, retain) UISegmentedControl * segmentedControl;
@property (nonatomic, retain) NSMutableArray * labelArray;
@property (nonatomic, assign) NSInteger fadeTime;
@property (nonatomic, assign) NSInteger snoozeTime;
@property (nonatomic, copy)   NSString * selectedSongName;

- (IBAction)tapDoneButton:(id)sender;
- (IBAction)segmentChanged:(id)sender;
@end
