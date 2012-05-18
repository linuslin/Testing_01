//
//  AlarmDetailViewController.m
//  MyTableVie3
//
//  Created by Linus Lin on 5/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AlarmDetailViewController.h"

@interface AlarmDetailViewController ()

@end

@implementation AlarmDetailViewController
@synthesize myTableView;
@synthesize navigationTitle;
@synthesize dataArray;
@synthesize selectedIndexPath;
@synthesize callBackSelector;


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
//    NSMutableArray * tmpArr;
//    NSMutableArray * tmpTimeArr;
//    switch (self.viewType) {
//        case SNOOZE:
//            tmpArr = [[NSMutableArray alloc] initWithObjects:@"None", @"3 mins", @"5 mins", @"10 minutes", @"15 mins", @"30 mins", nil];
//            tmpTimeArr = [[NSMutableArray alloc] initWithObjects:0, 180, 300, 600, 900, 1800, nil];
//            break;
//        case FADEIN:
//            tmpArr = [[NSMutableArray alloc] initWithObjects:@"None",@"10 secs", @"15 secs", @"30 secs", @"60 secs",@"120 secs", nil];
//            tmpTimeArr = [[NSMutableArray alloc] initWithObjects:0, 10, 15, 30, 60, 120, nil];
//            break;
//        case FADEOUT:
//            tmpArr = [[NSMutableArray alloc] initWithObjects:@"None",@"10 secs", @"15 secs", @"30 secs", @"60 secs",@"120 secs", nil];
//            tmpTimeArr = [[NSMutableArray alloc] initWithObjects:0, 10, 15, 30, 60, 120, nil];
//            break;
//        default:
//            NSLog(@"AlarmDetailViewController viewDidLoad viewType not matched");
//            tmpArr = [[NSMutableArray alloc] initWithObjects:@"None", @"3 mins", @"5 mins", @"10 mins", @"15 mins", @"30 mins", nil];
//            tmpTimeArr = [[NSMutableArray alloc] initWithObjects:0, 180, 300, 600, 900, 1800, nil];
//            break;
//    }
//    self.dataArray = tmpArr;
//    self.timeArray = tmpTimeArr;
//    [tmpArr release];
//    [tmpTimeArr release];
    
    [[self navigationItem] setTitle:navigationTitle];
    
    [self.myTableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(tapDoneButton:)];
    [[self navigationItem] setRightBarButtonItem:doneButton];
    [doneButton release];
    
    // Do any additional setup after loading the view from its nib.
    
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
    return [dataArray count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * ALARM_DETAIL_CELL_IDENTIFIER = @"ALARM_DETAIL_CELL_IDENTIFIER";
    UITableViewCell * cell;
    cell = [tableView dequeueReusableCellWithIdentifier:ALARM_DETAIL_CELL_IDENTIFIER];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ALARM_DETAIL_CELL_IDENTIFIER];
    }

    NSUInteger row = [indexPath row];
    cell.textLabel.text = [dataArray objectAtIndex:row];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
}

- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setAccessoryType:UITableViewCellAccessoryNone];
}

#pragma mark - IBAction Methods

- (IBAction)tapDone:(id)sender{
    [[self navigationController] popViewControllerAnimated:YES];
    if([self.selectedIndexPath isEqual:self.myTableView.indexPathForSelectedRow])
        return;
    
    self.selectedIndexPath = self.myTableView.indexPathForSelectedRow;
    [self performSelector:self.callBackSelector];
    //self.navigationController
    NSArray * allControllers = [self.navigationController viewControllers];
    UIViewController * parent = [allControllers lastObject];
    [parent performSelector:self.callBackSelector];
}

@end
