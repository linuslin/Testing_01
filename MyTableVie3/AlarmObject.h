//
//  AlarmObject.h
//  MyTableVie3
//
//  Created by Linus Lin on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface AlarmObject : NSObject {
    NSInteger fadeInSeconds;
    NSInteger fadeOutSeconds;
    NSInteger snoozeSeconds;
    NSTimeInterval duration;
    NSDate * alarmClockDate;
    BOOL enabled;
    UIDatePickerMode alarmMode;
    NSMutableArray * playersArray;
    NSTimer * timersArray;
    NSMutableArray * soundName;
}

@property (nonatomic, assign) NSInteger fadeInSeconds;
@property (nonatomic, assign) NSInteger fadeOutSeconds;
@property (nonatomic, assign) NSInteger snoozeSeconds;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, retain) NSDate * alarmClockDate;
@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, assign) UIDatePickerMode alarmMode;


@end
