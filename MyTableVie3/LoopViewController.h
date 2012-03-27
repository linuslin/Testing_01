//
//  LoopViewController.h
//  MyTableVie3
//
//  Created by Linus Lin on 3/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LabeledPickerView.h"
#import "SharedDefinition.h"


#define kHourComponent 0
#define kMinComponent 1
#define kSecComponent 2

#define secLabel @"sec"
#define minLabel @"min"
#define hourLabel @"hr"

@interface LoopViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>{
    
    LabeledPickerView * timePicker;
    UISwitch * loopSwitch;
    
    NSArray * secArray;
    NSArray * minArray;
    NSArray * hourArray;
    
    BOOL loopOn;
    NSInteger selectedRow;
    NSInteger loopTime;
    
}

@property (nonatomic, retain) IBOutlet LabeledPickerView * timePicker;
@property (nonatomic, retain) IBOutlet UISwitch * loopSwitch;
@property (nonatomic, retain) NSArray * secArray;
@property (nonatomic, retain) NSArray * minArray;
@property (nonatomic, retain) NSArray * hourArray;
@property (nonatomic, assign) NSInteger selectedRow;
@property (nonatomic, assign) BOOL loopOn;
@property (nonatomic, assign) NSInteger loopTime;


- (IBAction)switchLoop :(id)sender;
//- (IBAction)pickTime:(id)sender;

- (void) clickDoneButton: (id) sender;

@end
