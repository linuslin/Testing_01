//
//  AlarmListViewController.m
//  MyTableVie3
//
//  Created by Linus Lin on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AlarmListViewController.h"

@interface AlarmListViewController ()

@end

@implementation AlarmListViewController

@synthesize timerArray;
@synthesize selectedCell;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem * addButton = [[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
                                    target:self
                                    action:@selector(tapAddButton:)];
    [[self navigationItem] setRightBarButtonItem:addButton];
    [addButton release];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - tableview delegate and datasource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [timerArray count];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * ALARM_LIST_CELL_IDENTIFIER = @"ALARM_LIST_CELL_IDENTIFIER";
    UITableViewCell * cell;
    cell = [tableView dequeueReusableCellWithIdentifier:ALARM_LIST_CELL_IDENTIFIER];
    if(cell == nil){
        [[NSBundle mainBundle] loadNibNamed:@"AlarmListViewControllerTableViewCell" owner:self options:nil];
        cell = self.selectedCell;
        self.selectedCell = nil;
    }
    
    NSUInteger row = [indexPath row];
    UISwitch * tmpSwitch = (UISwitch *)[cell viewWithTag:kSWITCH_TAG];    
    UILabel * tmpLable = (UILabel *) [cell viewWithTag:kLABEL_TAG];
    NSMutableDictionary * selectedElement = [self.timerArray objectAtIndex:row];
    [tmpSwitch setOn:[[selectedElement objectForKey:kAlarmListCellSwitch] boolValue]];
    [tmpLable setText:[selectedElement objectForKey:kAlarmListCellLabel]];
    
    [tmpLable release];
    [tmpSwitch release];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEditing]) {
        
    } 
}

- (void) tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSUInteger row = [indexPath row];
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    UISwitch * tmpSwitch = (UISwitch *)[cell viewWithTag:kSWITCH_TAG];
    [tmpSwitch setHidden:YES];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    // Chagne the button to Done
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
                                   target:self
                                   action:@selector(tapDoneButton:)];
    [[self navigationItem] setRightBarButtonItem:doneButton];
    [doneButton release];
    
    UIBarButtonItem * fakeButton = [[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace 
                                    target:self
                                    action:nil];
    [[self navigationItem] setLeftBarButtonItem:fakeButton];
    [fakeButton release];

}

- (void) tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    UISwitch * tmpSwitch = (UISwitch *)[cell viewWithTag:kSWITCH_TAG];
    [tmpSwitch setHidden:NO];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    // change the add button back
    
    UIBarButtonItem * addButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
                                   target:self
                                   action:@selector(clickAddButton:)];
    [[self navigationItem] setRightBarButtonItem:addButton];
    [addButton release];
    
    
    [[self navigationItem] setLeftBarButtonItem:nil];
}

#pragma mark - IBAction Methods

- (IBAction)tapSwitch:(id)sender{
    // add to main controller
    // need to draw the main controll out
}

- (IBAction)tapAddButton:(id)sender{
    AlarmViewController * alarm = [[AlarmViewController alloc] initWithNibName:@"AlarmViewController" bundle:nil];
    
    [UIView transitionWithView:self.navigationController.view duration:1.0
                       options: UIViewAnimationOptionTransitionFlipFromRight    animations:^{ [self.navigationController pushViewController:alarm animated:NO];}
                    completion:NULL];
    [alarm release];
}

@end
