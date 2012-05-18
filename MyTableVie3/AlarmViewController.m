//
//  AlarmViewController.m
//  MyTableVie3
//
//  Created by Linus Lin on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AlarmViewController.h"

@interface AlarmViewController (PrivateMethod)
- (void) initAlarmDefinition;
- (void) initFadeTimeDict;
- (void) initSnoozeTimeDict;
- (void) initLabelArray;
- (NSString *) getFadeTimeString : (NSNumber *) key;
- (NSString *) getSoonzeTimeString : (NSNumber *) key;
@end


@implementation AlarmViewController
@synthesize datePicker;
@synthesize segmentedControl;
@synthesize myTableView;
@synthesize tableViewCell;
@synthesize labelArray;
@synthesize fadeTime;
@synthesize snoozeTime;
@synthesize selectedSongName;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initLabelArray];
    [self initFadeTimeDict];
    [self initSnoozeTimeDict];
    [self initAlarmDefinition];
//    NSMutableArray * tmpLabelArray = [[NSMutableArray alloc] initWithObjects:SOUND_LABEL,FADEOUT_LABEL,SNOOZE_LABEL, nil];
//    self.labelArray = tmpLabelArray;
//    [tmpLabelArray release];
    
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
                                    target:self
                                    action:@selector(tapDoneButton:)];
    [[self navigationItem] setRightBarButtonItem:doneButton];
    [doneButton release];
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table View Delegate and DataSource


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [labelArray count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * ALARMVIEW_CELL_IDENTIFIER = @"ALARMVIEWCELLIDENTIFIER";
    UITableViewCell * cell;
    cell = [tableView dequeueReusableCellWithIdentifier:ALARMVIEW_CELL_IDENTIFIER];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ALARMVIEW_CELL_IDENTIFIER];
    }
    NSUInteger row = [indexPath row];
    cell.textLabel.text = [self.labelArray objectAtIndex:row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    
    if (row == 0) {
        cell.detailTextLabel.text = @"None";
    }else if (row == 1){
        cell.detailTextLabel.text = @"None";
    }else if (row == 2) {
        cell.detailTextLabel.text = @"None";
    }
    return cell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUInteger row = [indexPath row];
    UIViewController * controller;
    if (row == 0) {
        controller = [[SelectSoundContorller alloc] initWithNibName:@"SelectSoundContorller" bundle:nil];
    }else if (row == 1){
        //controller = XXXView;
        controller = [[AlarmDetailViewController alloc] initWithNibName:@"AlarmDetailViewController" bundle:nil];
        ((AlarmDetailViewController *)controller).dataArray = [FadeTimeDict allValues];
        ((AlarmDetailViewController *)controller).selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        controller.title = @"Fade Time";
        
    }else if (row == 2) {
        //  controller = XXXView;
        controller = [[AlarmDetailViewController alloc] initWithNibName:@"AlarmDetailViewController" bundle:nil];
        ((AlarmDetailViewController *)controller).dataArray = [SnoozeTimeDict allValues];
        ((AlarmDetailViewController *)controller).selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        controller.title = @"Snooze Time";
    }
    
    [UIView transitionWithView:self.navigationController.view duration:1.0
                       options: UIViewAnimationOptionTransitionFlipFromRight    animations:^{ [self.navigationController pushViewController:controller animated:NO];}
                    completion:NULL];
    [controller release];
    
}
#pragma mark - IBAction methods

- (IBAction)segmentChanged:(id)sender{
    NSInteger index =  self.segmentedControl.selectedSegmentIndex;
    if(index == 0){
        [self.datePicker setDatePickerMode:UIDatePickerModeCountDownTimer];
        [self.datePicker setCountDownDuration:30];
    }else if(index == 1){
        [self.datePicker setDatePickerMode:UIDatePickerModeTime];
        [self.datePicker setDate:[NSDate dateWithTimeIntervalSinceNow:3600] animated:YES];
    }
}
- (IBAction)tapDoneButton:(id)sender{}


#pragma mark - Selector

- (void) reloadData{
    [self.myTableView reloadData];
}

#pragma mark - Private methods

- (void) initFadeTimeDict {
    if(!AlarmDefinition){
        [self initAlarmDefinition];
    }
    FadeTimeDict = [AlarmDefinition objectForKey:kFadeTime];
}

- (void) initSnoozeTimeDict {
    if(!AlarmDefinition){
        [self initAlarmDefinition];
    }
    SnoozeTimeDict= [AlarmDefinition objectForKey:kSnoozeTime];
}
                        
- (void) initAlarmDefinition{
    if (!AlarmDefinition) {
        AlarmDefinition = [[NSMutableDictionary alloc] initWithContentsOfFile:@"AlarmDefinition.plist"];
    }
}

- (void) initLabelArray{
    //NSMutableArray * tmpLabelArray = [[NSMutableArray alloc] initWithObjects:SOUND_LABEL,FADEOUT_LABEL,SNOOZE_LABEL, nil];
    NSMutableArray * tmpLabelArray = [[NSMutableArray alloc] initWithCapacity:5];
    NSMutableDictionary * tmpDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys:SOUND_LABEL,kTextLableText, nil];
    [tmpLabelArray addObject:tmpDict];
}

- (NSString *) getFadeTimeString : (NSNumber *) key{
    return [FadeTimeDict objectForKey:key];
}


- (NSString *) getSoonzeTimeString : (NSNumber *) key{
    return [SnoozeTimeDict objectForKey:key];
}
@end
