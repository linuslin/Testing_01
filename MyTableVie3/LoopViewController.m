//
//  LoopViewController.m
//  MyTableVie3
//
//  Created by Linus Lin on 3/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoopViewController.h"


@interface LoopViewController(PivateMethod)
- (void) initPicker;
- (void) initToolBar;
- (NSMutableArray *) getTimeArray:(NSInteger) count;
- (void) setupSettings;
- (void) setupSwitch:(BOOL) On;
- (void) setupPicker:(NSInteger) time;
- (NSInteger) getSeconds;
@end

@implementation LoopViewController

@synthesize loopSwitch;
@synthesize timePicker;
@synthesize selectedRow;
@synthesize secArray;
@synthesize hourArray;
@synthesize minArray;
@synthesize loopOn;
@synthesize loopTime;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void) viewDidAppear:(BOOL)animated{
    [self setupSettings];

//    [[[self navigationItem] rightBarButtonItem] setEnabled:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    // setting done button action to clickDoneButton
    
    
    // Do any additional setup after loading the view from its nib.
    [self initToolBar];
    [self initPicker];
    [self setupSettings];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.timePicker = nil;
    self.loopSwitch = nil;
    self.secArray = nil;
    self.hourArray = nil;
    self.minArray = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) dealloc{
    [timePicker release];
    [loopSwitch release];
    [secArray release];
    [hourArray release];
    [minArray release];
}

#pragma mark - IBActions

- (IBAction)switchLoop:(id)sender{
    [self.timePicker setUserInteractionEnabled:[sender isOn]];
    [[[self navigationItem] rightBarButtonItem] setEnabled:YES];
}

- (IBAction)pickTime:(id)sender{
    
}

#pragma mark - picker DataSurce and Delegate

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *) pickerView{
    return 3;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
  
    switch (component) {
        case kHourComponent:
            return [hourArray count];
            break;
//        case kHourLabel:
//            return 1;
//            break;
        case kMinComponent:
            return [minArray count];
            break;
//        case kMinLabel:
//            return 1;
//            break;
        case kSecComponent:
            return [secArray count];
            break;
//        case kSecLabel:
//            return 1;
//            break;
        default:
            NSLog(@"Should never in here pickerView numberOfRows");
            break;
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    switch (component) {
        case kHourComponent:
            return [self.hourArray objectAtIndex:row];
            break;
        case kMinComponent:
            return [self.minArray objectAtIndex:row];
            break;
        case kSecComponent:
            return [self.secArray objectAtIndex:row];
            break;
        default:
            NSLog(@"Should never in here pickerView numberOfRows");
            break;
    }
    return 0;
}
//- (UIView *) pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
//    UILabel *pickerLabel = (UILabel *)view;
//    
//    if (pickerLabel == nil) {
//        CGRect frame = CGRectMake(0.0, 0.0, 80, 32);
//        pickerLabel = [[[UILabel alloc] initWithFrame:frame] autorelease];
//        [pickerLabel setTextAlignment:UITextAlignmentLeft];
//        [pickerLabel setBackgroundColor:[UIColor clearColor]];
//        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
//    }
//    
//    [pickerLabel setText:[pickerDataArray objectAtIndex:row]];
//    
//    return pickerLabel;
//}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    [[[self navigationItem] rightBarButtonItem] setEnabled:YES];
    NSString * tmpStr = [timePicker.labels objectForKey:[NSNumber numberWithInt:component]];
    NSString * lastChar = [tmpStr substringFromIndex:[tmpStr length]-1];
    NSLog(@"tmpStr:%@",tmpStr);
    NSLog(@"lastChar:%@", lastChar);
    
    switch (component) {
        case kHourComponent:
            tmpStr = @"hour";
            break;
        case kMinComponent:
            tmpStr = @"min";
            break;
        case kSecComponent:
            tmpStr = @"sec";
            break;
        default:
            NSLog(@"Should never in here pickerView numberOfRows");
            break;
    }
    
    if(row == 1) {
        [timePicker updateLabel:tmpStr forComponent:component];
    }else{
        [timePicker updateLabel:[tmpStr stringByAppendingString:@"s"] forComponent:component];
    }
}


#pragma mark - instance methods

- (void) clickDoneButton: (id) sender{
    NSLog(@"clicked done button");

    NSNumber * totalSec; 
    
    if([self.loopSwitch isOn]){
        totalSec = [NSNumber numberWithInteger:[self getSeconds]];
    }else {
        totalSec = [NSNumber numberWithInt:-1];
    }

    NSDictionary * userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                               [NSNumber numberWithInteger:self.selectedRow],kRowIndex,
                               totalSec,kLoop,
                               nil];
    NSLog(@"%@",userInfo);

    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateLoopTime"
                                                        object:sender
                                                      userInfo:userInfo];
    [totalSec release];
    [[self navigationController] popViewControllerAnimated:YES];
}

#pragma mark - Private Methods

- (NSInteger) getSeconds{
    NSInteger tmpSec = [self.timePicker selectedRowInComponent:kSecComponent];
    NSInteger tmpMin = [self.timePicker selectedRowInComponent:kMinComponent];
    NSInteger tmpHr = [self.timePicker selectedRowInComponent:kHourComponent];
    NSInteger totalTime = tmpSec + (tmpMin + tmpHr * 60) * 60;
    return totalTime;
}
- (void) initPicker{
    [self.timePicker addLabel:@"hour" forComponent:kHourComponent forLongestString:@"hours"];
    [self.timePicker addLabel:@"min" forComponent:kMinComponent forLongestString:@"mins"];
    [self.timePicker addLabel:@"sec" forComponent:kSecComponent forLongestString:@"secs"];
    self.secArray = [self getTimeArray:60];
    self.minArray = [self getTimeArray:60];
    self.hourArray = [self getTimeArray:24];
    
    [self.timePicker reloadAllComponents];

}

- (void) setupSettings{
    [self setupSwitch:self.loopOn];
    [self setupPicker:self.loopTime];
    [[[self navigationItem] rightBarButtonItem] setEnabled:NO];
}

- (void) setupSwitch:(BOOL)On{
    [self.loopSwitch setOn:On];
}

- (void) setupPicker:(NSInteger)time{
    if(self.loopOn){
        [self.timePicker setUserInteractionEnabled:YES];
        NSInteger tmpSec = self.loopTime % 60;
        NSInteger tmpMin = (self.loopTime / 60) % 60;
        NSInteger tmpHr = (self.loopTime / 3600);
        [self.timePicker selectRow:tmpSec inComponent:kSecComponent animated:NO];
        [self.timePicker selectRow:tmpMin inComponent:kMinComponent animated:NO];
        [self.timePicker selectRow:tmpHr inComponent:kHourComponent animated:NO];
    }else{
        [self.timePicker setUserInteractionEnabled:NO];
        [self.timePicker selectRow:0 inComponent:kSecComponent animated:NO];
        [self.timePicker selectRow:0 inComponent:kMinComponent animated:NO];
        [self.timePicker selectRow:0 inComponent:kHourComponent animated:NO];
    }
}

- (void) initToolBar{
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
                                    target:self
                                    action:@selector(clickDoneButton:)];
    
    [doneButton setEnabled:NO];
    [[self navigationItem] setRightBarButtonItem:doneButton];
    [doneButton release];
}

- (NSArray *) getTimeArray:(NSInteger)count{
    NSMutableArray * tmpArray = [[NSMutableArray alloc]initWithCapacity:count];
    for (int i = 0 ; i <count;i++){
        [tmpArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    NSArray * result = [NSArray arrayWithArray:tmpArray];
    [tmpArray release];
    return result;
}
@end
