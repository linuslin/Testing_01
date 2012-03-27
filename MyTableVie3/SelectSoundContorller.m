//
//  SelectSoundContorller.m
//  MyTableVie3
//
//  Created by Linus Lin on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SelectSoundContorller.h"
#import "ViewController.h"

@implementation SelectSoundContorller

@synthesize selectSoundTableViewCell;
@synthesize songList;
@synthesize selectTableView;
@synthesize currentSong;
@synthesize myPlayer;
@synthesize selectedRow;
@synthesize sharedObject;
@synthesize imageMapping;

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

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    // disable player
    
    if (self.myPlayer != nil) {
        [self.myPlayer stop];
        [self.selectTableView deselectRowAtIndexPath:[self.selectTableView indexPathForSelectedRow] animated:NO];
    }
	//[super viewWillDisappear:animated];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration: 1.0];
    
    //Hook To MainView
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:YES];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    [super viewWillDisappear:NO];
    
    [UIView commitAnimations];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
    if(self.myPlayer != nil){
        [self.myPlayer setDelegate:nil];
        [self.myPlayer stop];
        //[self.myPlayer release];
        self.myPlayer = nil;
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    NSMutableArray * songArray = [[NSMutableArray alloc] initWithCapacity:10];
    for (NSString * song in [[NSBundle mainBundle] pathsForResourcesOfType:@"mp3" inDirectory:@"media/"]) {
        //NSString * filename = [[song lastPathComponent] stringByDeletingPathExtension];
        NSString * filename = [song lastPathComponent];
        [songArray addObject:filename];
        NSLog(@"%@", filename);	
    }
    
    
    self.songList = songArray;
    if (songArray.count > 0) {
        self.currentSong = [songArray objectAtIndex:0];
        
    }else {
        self.currentSong = nil;
    }
    
    // setting done button action to clickDoneButton
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
                                  target:self 
                                  action:@selector(clickDoneButton:)];
    
    [doneButton setEnabled:NO];
    [[self navigationItem] setRightBarButtonItem:doneButton];
    [doneButton release];
    
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStyleBordered target:self action:@selector(clickBackButton:)];
	[[self navigationItem] setLeftBarButtonItem: temporaryBarButtonItem];
	[temporaryBarButtonItem release];
    
    
    [songArray release];
    
    self.sharedObject = [SharedObject sharedInstance];
    self.imageMapping = [sharedObject imageMapping];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    selectSoundTableViewCell = nil;
    songList = nil;
    selectTableView = nil;
    currentSong = nil;
    myPlayer = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) dealloc{
    [selectSoundTableViewCell release];
    [songList release];
    [selectTableView release];
    [currentSong release];
    [myPlayer release];
    [super dealloc];
}

#pragma mark -
#pragma mark tableview delegate and data source

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"%@", [listData count]);
    return [self.songList count];; //[listData count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // need to check the songs count.
    static NSString * CellTableIdentifier = @"SelectSoundTableViewCell";
    UITableViewCell * cell;
    cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if(cell == nil){
        [[NSBundle mainBundle] loadNibNamed:@"SelectSoundTableViewCell" owner:self options:nil];
        cell = self.selectSoundTableViewCell;
        self.selectSoundTableViewCell = nil;
    }
    
    NSUInteger row = [indexPath row];
    UILabel * label = (UILabel *)[cell viewWithTag:kSelectTableViewCellLabelTag];
    label.text = [self.songList objectAtIndex:row];
    [label sizeToFit];
    
    
    //load image
    NSString * imgPath = [self.imageMapping objectForKey:[[self.songList objectAtIndex:row] lastPathComponent]];
    NSLog(@"%@",imgPath);
    UIImage * img = [UIImage imageNamed:imgPath];
    //UIImageView * imgView = [[UIImageView alloc] initWithImage:img];
    UIImageView * imgV = (UIImageView *)[cell viewWithTag:kSelectTableViewCellImageTag];
    imgV.image = img;
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [[[self navigationItem] rightBarButtonItem] setEnabled:YES];
    if(self.myPlayer != nil){
        [self.myPlayer setDelegate:nil];
        [self.myPlayer stop];
        //[self.myPlayer release];
        self.myPlayer = nil;
    }
    
    NSInteger row = [indexPath row];
    NSString * fileName = [[self.songList objectAtIndex:row] stringByDeletingPathExtension];
    NSString * extension = [[self.songList objectAtIndex:row] pathExtension];
    NSString * soundFilePath = [[NSBundle mainBundle] pathForResource: fileName ofType: extension];
    //NSLog(@"%@", soundFilePath);
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
    AVAudioPlayer *newPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
    
    self.myPlayer = newPlayer;
    //[tmpPlayer release];
    [newPlayer release];
    [fileURL release];
    //[songURL release];
    
    //[player setVolume:0.5f];
    [self.myPlayer setVolume:0.5f];
    [self.myPlayer setDelegate: self];
    //[self.player prepareToPlay];
    [self.myPlayer play];
    
}

#pragma mark -
#pragma mark VideoController delegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"Hi~~~");
    //[player release];
    if (flag == YES)
        NSLog(@"PlayBack finish");
}


#pragma mark -
#pragma mark SelectSoundController methods

- (IBAction)clickSelect:(id)sender
{
    
}

- (void) playSound:(NSString *) seletedSong{

}

- (void) clickDoneButton:(id)sender{
    NSLog(@"Done Button Clicked");  
    //[self saveChange:sender];
    [self notifyChange:sender];
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void) clickBackButton:(id)sender{
    NSLog(@"Pressed Back button");
    [[self navigationController] popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark Private Methods


- (void) notifyChange:(id) sender{
    NSInteger row = [[self.selectTableView indexPathForSelectedRow]row]; 
    NSString * soundPath = [NSString stringWithString:[self.songList objectAtIndex:row]];
    //NSLog(@"NSInteger %@\n soundPath %@\n",row,soundPath);
    NSDictionary * passData = [[NSDictionary alloc] initWithObjectsAndKeys:
                               soundPath,kSoundPath,
                               [NSNumber numberWithInteger:selectedRow],kRowIndex,
                               [NSNumber numberWithFloat:[self.myPlayer volume]],kVolume,
                               nil];
    NSLog(@"%@",passData);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateSonglist"
                                                        object:sender
                                                      userInfo:passData];
    //[passData release];
}


@end
