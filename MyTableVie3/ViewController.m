//
//  ViewController.m
//  MyTableVie3
//
//  Created by Linus Lin on 1/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "SaveViewController.h"
//#import "SelectSoundContorller.h"


static NSUInteger kNumberOfPages = 2;

static NSString *NameKey = @"nameKey";
static NSString *ImageKey = @"imageKey";


@interface ViewController (PrivateMethods)
- (void)loadScrollViewWithPage:(int)page;
- (void)scrollViewDidScroll:(UIScrollView *)sender;
- (void)_awakeFromMyNib;
- (void) changePlayingIcon:(ICONTYPE)icon atIndexPath:(NSIndexPath *) path;
- (void)_play:(AVAudioPlayer *) player At:(NSIndexPath*)path;
- (void)_pause:(AVAudioPlayer *) player At:(NSIndexPath*)path;
- (void)_stop:(AVAudioPlayer *) player At:(NSIndexPath*)path;
- (NSIndexPath *) _getIndexPathFrom:(id)sender;
- (void) _initTimerArray;
- (void) invalidateTimer:(NSInteger) index;

- (void) initPlayers;

@end


@implementation ViewController

@synthesize currentPlayList;
@synthesize currentPlayListDict;
@synthesize tvCell;
@synthesize btnCell;
@synthesize myTableView;
@synthesize saveVC;
@synthesize selectVC;
@synthesize soundPlayers;
@synthesize playingIndex;
@synthesize sharedObject;
@synthesize imageMapping;
@synthesize scrollView, pageControl, viewControllers;
@synthesize toolBarView0;
@synthesize toolBarView1;
@synthesize loopVC;
@synthesize timersArray;
@synthesize players;


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.currentPlayList = 
    sharedObject = [SharedObject sharedInstance];
    [self _initCurrentPlayListAndDict];
    [self initPlayers];
    [self _initSoundPlayers];
    [self _initImageMapping];
    //[self _initTimerArray];
    [self _awakeFromMyNib];
     
    
    //register for selectView notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateSonglist:)
                                                 name:@"updateSonglist"
                                               object:nil];
    //register for loopView notification 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLoopTime:) name:@"updateLoopTime" object:nil];
    
    
    SaveViewController * save = [[SaveViewController alloc] initWithNibName:@"SaveViewController" bundle:nil];
    self.saveVC = save;
    [save release];
    
    SelectSoundContorller * select = [[SelectSoundContorller alloc] initWithNibName:@"SelectSoundContorller" bundle:nil];
    self.selectVC = select;
    [select release];
    
    LoopViewController * loop = [[LoopViewController alloc] initWithNibName:@"LoopViewController" bundle:nil];
    self.loopVC = loop;
    [loop release];
    
    
    //self.myTableView.rowHeight = 100;
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    //self.tvCell = nil;
    self.currentPlayList = nil;
    self.myTableView = nil;
    
    //Save Button
    //SaveViewController * saveButtonController = [[SaveViewController alloc] init];
    
}

- (void) dealloc{
    //[tvCell release];
    [currentPlayList release];
    [myTableView release];
    [viewControllers release];
    [scrollView release];
    [pageControl release];
    
    [super dealloc];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    //[self.navigationController se
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewDidAppear:animated];
    //[self palyAllPlayers];
    [self restorePausedPlayers];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [self savePlayingIndex];
    [self pauseAllPlayers];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


#pragma mark -
#pragma mark tableView Delegate and Data Source
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.currentPlayList count] + 1; 
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * CellTableIdentifier = @"TVCELL";
    static NSString * BtnCellIdentifier = @"BTNCELLIDENTIFER";
    UITableViewCell * cell;
    NSUInteger row = [indexPath row];
    if (row == [self.currentPlayList count]) {
        cell = [tableView dequeueReusableCellWithIdentifier:BtnCellIdentifier];
        if(cell == nil){
            //cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellTableIdentifier] autorelease];
            [[NSBundle mainBundle] loadNibNamed:@"BtnCell" owner:self options:nil];
            cell = self.btnCell;
            self.btnCell = nil;
        }
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
        if(cell == nil){
            //cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellTableIdentifier] autorelease];
            [[NSBundle mainBundle] loadNibNamed:@"TvCell" owner:self options:nil];
            cell = self.tvCell;
            self.tvCell = nil;
            // player.volume = tmpVolume
        }
        
        NSDictionary * currentObjectAtIndex = [self.currentPlayList objectAtIndex:row];
        // Load button Title
        UIButton * selectButton = (UIButton *)[cell viewWithTag:kTableViewCellSelectButtonTag];
        NSString * tmpLabelText = [[[currentObjectAtIndex objectForKey:kSoundPath]lastPathComponent] stringByDeletingPathExtension];
        NSLog(@"%@", tmpLabelText);
        [selectButton setTitle:tmpLabelText forState:UIControlStateNormal];
        
        // Load Image
        NSString * imgPath = [self.imageMapping objectForKey:[[currentObjectAtIndex objectForKey:kSoundPath]lastPathComponent]];
        NSLog(@"%@",imgPath);
        UIImage * img = [UIImage imageNamed:imgPath];
        //UIImageView * imgView = [[UIImageView alloc] initWithImage:img];
        UIImageView * imgV = (UIImageView *)[cell viewWithTag:kTableViewCellImageTag];
        imgV.image = img;
        
        //Load Slider
        NSNumber * tmpVolume = [currentObjectAtIndex objectForKey: kVolume];
        NSLog(@"%@", tmpVolume);
        UISlider * tmpSlider = (UISlider *) [cell viewWithTag:kTableViewCellSliderTag];
        tmpSlider.value = [tmpVolume floatValue];
        
    }
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

#pragma mark -
#pragma mark Scroll View Controll delegate methods

- (void)_awakeFromMyNib
{
	// load our data from a plist file inside our app bundle
    //NSString *path = [[NSBundle mainBundle] pathForResource:@"content_iPhone" ofType:@"plist"];
    //self.contentList = [NSArray arrayWithContentsOfFile:path];
    
    // view controllers are created lazily
    // in the meantime, load the array with placeholders which will be replaced on demand
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    [self.toolBarView0 removeFromSuperview];
    [self.toolBarView1 removeFromSuperview];
    
    [controllers addObject:self.toolBarView0];
    [controllers addObject:self.toolBarView1];
    
    //for (unsigned i = 0; i < kNumberOfPages; i++)
    //{
	//	[controllers addObject:[NSNull null]];
    //}
    
    self.viewControllers = controllers;
    [controllers release];
    
    // a page is the width of the scroll view
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * kNumberOfPages, scrollView.frame.size.height);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
    
    pageControl.numberOfPages = kNumberOfPages;
    pageControl.currentPage = 0;
    
    // pages are created on demand
    // load the visible page
    // load the page on either side to avoid flashes when the user starts scrolling
    //
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
}


//- (UIView *)view
//{
//    return self.scrollView;
//}

- (void)loadScrollViewWithPage:(int)page
{
    if (page < 0)
        return;
    if (page >= kNumberOfPages)
        return;
    
    // replace the placeholder if necessary
    UIView *controller = [viewControllers objectAtIndex:page];
    //if ((NSNull *)controller == [NSNull null])
    //{
        //controller = [[UIView alloc] init];
        //[controller setBackgroundColor:[UIColor colorWithRed:page*0.5 green:page*0.5*page blue:page*0.1*page alpha:1]];
    //    [viewControllers replaceObjectAtIndex:page withObject:self];
    //    [controller release];
    //}
    
    // add the controller's view to the scroll view
    if (controller.superview == nil)
    {
        CGRect frame = scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        controller.frame = frame;
        [scrollView addSubview:controller];
        
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    if (pageControlUsed)
    {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
	
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
    // A possible optimization would be to unload the views+controllers which are no longer visible
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}

- (IBAction)changePage:(id)sender
{
    int page = pageControl.currentPage;
	
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
	// update the scroll view to the appropriate page
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
    
	// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    pageControlUsed = YES;
}


#pragma mark -
#pragma mark ViewController IBAction Implement Method

- (IBAction)clickSave:(id)sender
{
//    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Save as Favorite" message:@"Type a name to save" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
//    [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
//    [alertView show];
//                               
    self.saveVC.currentSongListDict = self.currentPlayListDict;
    
    [UIView transitionWithView:self.navigationController.view duration:1.0
     options: UIViewAnimationOptionTransitionFlipFromRight    animations:^{ [self.navigationController pushViewController:self.saveVC animated:NO];}
     completion:NULL];
}

- (IBAction)clickSelect:(id)sender
{
    //NSLog(@"%@",[self.myTableView indexPathForCell:(UITableViewCell *)[[(UIButton *)sender superview]superview]]);
    
    //setting the selected row
    self.selectVC.selectedRow = [[self.myTableView indexPathForCell:(UITableViewCell *)[[(UIButton *)sender superview]superview]] row];

    // select view
    [UIView transitionWithView:self.navigationController.view duration:1.0
                       options: UIViewAnimationOptionTransitionFlipFromRight    animations:^{ [self.navigationController pushViewController:self.selectVC animated:NO];}
                    completion:NULL];
    
    
}

- (IBAction)clickPlayButton:(id)sender
{
    NSLog(@"ClickPlayButton");
    NSUInteger row = [self _getRowOfCell:sender];
    NSIndexPath * indexPath = [self _getIndexPathFrom:sender];
    AVAudioPlayer * selectedPlayer = [self getPlayerAt:row];
    BOOL isPlaying = [selectedPlayer isPlaying];
    if (isPlaying) {
        [self _pause: selectedPlayer At:indexPath];
    }else {
        [self _play: selectedPlayer At:indexPath];
    }
}

- (IBAction)clickLoopButton:(id)sender
{
    NSLog(@"ClickLoopButton");
    NSInteger selectedRow = [[self.myTableView indexPathForCell:(UITableViewCell *)[[(UIButton *)sender superview]superview]] row];
    self.loopVC.selectedRow = selectedRow;
    self.loopVC.loopTime = [[[self.currentPlayList objectAtIndex:selectedRow]objectForKey:kLoop] integerValue];
    if(self.loopVC.loopTime < 0)
        self.loopVC.loopOn = NO;
    else
        self.loopVC.loopOn = YES;
    
    // loop view
    [UIView transitionWithView:self.navigationController.view duration:1.0
                       options: UIViewAnimationOptionTransitionFlipFromRight    animations:^{ [self.navigationController pushViewController:self.loopVC animated:NO];}
                    completion:NULL];
}

- (IBAction)changeSliderValue:(id)sender
{
    NSLog(@"ChangeSliderValue");
    NSUInteger row = [self _getRowOfCell:sender];
    //NSIndexPath * rowIndex = [self _getIndexPathFrom:sender];
    
    AVAudioPlayer * selectedPlayer = [self getPlayerAt:row];
    NSLog(@"%@",sender);
    [selectedPlayer setVolume:[(UISlider *)sender value]];
    
    NSDictionary * elemntOfPlayerList = [self.currentPlayList objectAtIndex:row];
    [elemntOfPlayerList setValue:[NSNumber numberWithFloat:[(UISlider *)sender value]] forKey:kVolume];
}


- (IBAction)clickTrackMangeButton:(id)sender{
    NSLog(@"Click Track Manage Button");
}
//- (void) clickBackButton:(id) sender{
//    NSLog(@"First View clickBackButton event");
//}

- (IBAction)clickImage:(id) sender{
    NSLog(@"Click Image Button");
}


#pragma mark -
#pragma mark private methods

- (void) _initTimerArray{
//    NSMutableArray * tmpArr = [[NSMutableArray alloc] initWithCapacity:[self.players count]];
//    for (int i =0 ; i<[self.soundPlayers count]; i++) {
//        [tmpArr addObject:[[NSTimer alloc] init]];
//    }
//    self.timersArray = tmpArr;
//    [tmpArr release];
}

- (void) _initCurrentPlayListAndDict{
    [self.currentPlayList release];
    // Path to the plist (in the application bundle)
    NSString *path = [[NSBundle mainBundle] pathForResource:
                      kCurrentPlayListFileName ofType:@"plist"];
    
    // Build the array from the plist  
    if([[NSFileManager defaultManager] fileExistsAtPath:path]){
        //NSMutableArray * array = [[NSMutableArray alloc] initWithContentsOfFile:path];
        NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        NSLog(@"%@",[dict objectForKey:@"songList"]);
        self.currentPlayListDict = dict;
        self.currentPlayList = (NSMutableArray *)[dict objectForKey:@"songList"];
        [dict release];
    }
    //return nil;
}

- (NSInteger) _getRowOfCell:(id)sender{
    NSInteger row;
    row = [[self.myTableView indexPathForCell:(UITableViewCell *)[[sender superview] superview]] row] ;
    return row;
}

- (NSIndexPath *) _getIndexPathFrom:(id)sender{
    NSIndexPath * path;
    path = [self.myTableView indexPathForCell:(UITableViewCell *)[[sender superview] superview]];
    return path;
}

- (void) _initImageMapping {
    self.imageMapping = [sharedObject imageMapping];
}


- (void) updateSonglist:(id)sender{  


    NSDictionary * userInfo = [sender userInfo];
    NSLog(@"Received userInfo: %@",userInfo);
    NSString * tmpSoundPath = [NSString stringWithString:[userInfo objectForKey:kSoundPath]];
    NSUInteger rowIndex = [[userInfo objectForKey:kRowIndex] unsignedIntegerValue];
    NSString * fileName = [tmpSoundPath stringByDeletingPathExtension];
    NSString * extension = [tmpSoundPath pathExtension];
    NSString * soundFilePath = [[NSBundle mainBundle] pathForResource: fileName ofType: extension];
    NSURL * fileURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
    
    NSLog(@"Pass initial");
    
    AVAudioPlayer * oldPlayer = [self getPlayerAt: rowIndex];
    
    NSIndexPath * indexPath = [self.myTableView indexPathForCell:[[self.myTableView visibleCells] objectAtIndex:rowIndex]];
    AVAudioPlayer * newPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
    [newPlayer setVolume:[oldPlayer volume]];
    [newPlayer prepareToPlay];
    [self _stop:oldPlayer At:indexPath];
    [self invalidateTimer: rowIndex];
    oldPlayer = nil;
    [self setPlayingState:STOPPED At:rowIndex];
    [self setPlayer:newPlayer At:rowIndex];
    [newPlayer release];
    [fileURL release];
    
    
    //Update playerList
    NSDictionary * elemntOfPlayerList = [self.currentPlayList objectAtIndex:rowIndex];
    [elemntOfPlayerList setValue:tmpSoundPath forKey:kSoundPath];
    [elemntOfPlayerList setValue:[NSNumber numberWithFloat:0.5f] forKey:kVolume];
    [elemntOfPlayerList setValue:[NSNumber numberWithInt:-1] forKey:kLoop];
    //[elemntOfPlayerList setValue:tmpSoundPath forKey:kImagePath];
    
    
    [self _reloadTableView];
}

- (void) updateLoopTime:(id)sender{
    NSDictionary * userInfo = [sender userInfo];
    NSLog(@"Received userInfo: %@",userInfo);
    NSNumber * loopTime = [userInfo objectForKey:kLoop];
    NSInteger selectedRow = [[userInfo objectForKey:kRowIndex] integerValue];
    // update currentPlayList
    NSMutableDictionary * tmpDict = [self.currentPlayList objectAtIndex:selectedRow];
    [tmpDict setObject:loopTime forKey:kLoop];
    
    // update loops
    AVAudioPlayer * player = [self getPlayerAt:selectedRow];
    if ([loopTime intValue]==0){
        player.numberOfLoops = -1;
    }else{
        player.numberOfLoops = 0;
    }
    // Invalidate timer
    NSLog(@"invalide timer");
    [self invalidateTimer: selectedRow];
    
}

- (void) invalidateTimer:(NSInteger)index{
    NSTimer * timer = [self getTimerAt:index];
    if(timer && [timer isValid]){
        [timer invalidate];
    }
}

- (void) _reloadTableView
{
    NSLog(@"_reloadTableView wakeup");
    [self.myTableView reloadData];
    
}

- (void) _saveCurrentPlayList:(id) sender{
    
}

- (void) _savePlayList:(NSString *) filename{

}

- (void) _initSoundPlayers {
    NSUInteger count = [self.currentPlayList count];
    
    //self.soundPlayers = [[NSMutableArray alloc] initWithCapacity:count];

    NSString * fileName;
    NSString * extension;
    NSString * soundFilePath;
    NSURL * fileURL;
    AVAudioPlayer * tmpPlayer;
    float volume;
    
    for (NSUInteger i = 0 ; i< count; i++){
        fileName = [[[self.currentPlayList objectAtIndex:i] objectForKey:kSoundPath] stringByDeletingPathExtension];
        extension = [[[self.currentPlayList objectAtIndex:i] objectForKey:kSoundPath] pathExtension];
        soundFilePath = [[NSBundle mainBundle] pathForResource: fileName ofType: extension];
        fileURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
        tmpPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
        
        volume = [[[self.currentPlayList objectAtIndex:i] objectForKey:kVolume] floatValue];
        
        [tmpPlayer setVolume:volume];
        [tmpPlayer setDelegate: self];
        [tmpPlayer prepareToPlay];
        [self setPlayer:tmpPlayer At:i];
        [tmpPlayer release];
        [fileURL release];
    }
}

- (NSIndexPath *) getIndexPathFromTableViewBy:(NSInteger)row{
    NSIndexPath * resultPath = [[self.myTableView indexPathsForVisibleRows] objectAtIndex:row];
    return resultPath;
}

- (void) pauseAllPlayers {
    NSLog(@"Pause all players");
    AVAudioPlayer * player;
    for (int i=0; i<[players count]; i++) {
        player = [self getPlayerAt:i];
        if([player isPlaying]){
            NSIndexPath * indexPath = [self getIndexPathFromTableViewBy:i];
            [self _pause:player At: indexPath];
            //[player pause];
            
        }
        
    }
    //need to invalidate the timer.
}


- (void) playAllPlayers {
    NSLog(@"Play All Players");
    AVAudioPlayer * player;
    for (int i=0; i<[players count]; i++) {
        player = [self getPlayerAt:i];
        if(![player isPlaying]){
            NSIndexPath * indexPath = [self getIndexPathFromTableViewBy:i];
            [self _play:player At:indexPath];
        }
        
    }
}

- (void) stopAllPlayers {
    NSLog(@"stop All players");
    for (int i = 0; i < [self.players count]; i++) {
        AVAudioPlayer * player = [self getPlayerAt:i];
        NSIndexPath * indexPath = [self getIndexPathFromTableViewBy:i];
        [self _stop:player At:indexPath];
    }
}

- (void) releaseAllPlayers {
    NSLog(@"release All players");
}


//same as replayAllplayers
- (void) restorePausedPlayers {
    // need to refire the timer
    NSLog(@"Replay all players");
    for (int i = 0; i < [self.players count]; i++){
        PLAYINGSTATE state = [self getPlayingStateAt:i];
        NSIndexPath * indexPath = [self getIndexPathFromTableViewBy:i];
        if (state == PLAYING){
            AVAudioPlayer * player = [self getPlayerAt:i];
            [self _play:player At: indexPath];
        }else if(state == LOOPING){
            AVAudioPlayer * player = [self getPlayerAt:i];
            NSTimeInterval interval = [self getFireTimeIntervalAt:i];
            NSDictionary * userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:player,kPlayerInstance, nil];
            NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(playPlayer:) userInfo:userInfo repeats:NO];
            [self setTimer:timer At:i];
            [self changePlayingIcon:PLAYINGICON atIndexPath:indexPath];
        }else{
            
        }
    }
}

- (void) savePlayingIndex {
    NSUInteger count = [self.players count];
    for(int i = 0 ; i<count; i++){
        AVAudioPlayer * player = [self getPlayerAt:i];
        NSTimer * timer = [self getTimerAt:i];
        if ([player isPlaying]) {
            [self setPlayingState:PLAYING At:i];
        }else if([timer isValid]){
            //need to save timer left time then invalidate it.
            NSDate * date = [timer fireDate];
            NSTimeInterval timeInterval = [date timeIntervalSinceNow];
            [self setFireTimeInterval:timeInterval At:i];
            [self setPlayingState:LOOPING At:i];
            
            [timer invalidate];
        }else{
            [self setPlayingState:PAUSED At:i];
        }
    }
}


- (void) _play:(AVAudioPlayer *)player At:(NSIndexPath *)path{
    [self changePlayingIcon:PLAYINGICON atIndexPath:path];
    [player play];
    
}

- (void) _pause:(AVAudioPlayer *)player At:(NSIndexPath *)path{
    NSInteger index = [path row];
    [self changePlayingIcon:PAUSEDICON atIndexPath:path];
    [self invalidateTimer:index];
    [player pause];
    
}


- (void)_stop:(AVAudioPlayer *) player At:(NSIndexPath *)path{
    NSInteger index = [path row];
    [self changePlayingIcon:STOPPEDICON atIndexPath:path];
    [self invalidateTimer:index];
    [player stop];
}

- (void) changePlayingIcon:(ICONTYPE)icon atIndexPath:(NSIndexPath *) path{
    UITableViewCell * selectedCell = [self.myTableView cellForRowAtIndexPath:path];
    UIButton * clickedButton = (UIButton *)[selectedCell viewWithTag:kTableViewCellPlayButtonTag];
    UIImage * image;
    if (icon == PLAYINGICON) {
        image = [sharedObject getApplictionImageFrom:kPauseButtonImage];
    }else if (icon == PAUSEDICON || icon == STOPPEDICON){
        image = [sharedObject getApplictionImageFrom:kPlayButtonImage];
    }
    [clickedButton setImage:image forState:UIControlStateNormal];
}

#pragma mark -
#pragma mark UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1){
        NSLog(@"Alert View Inputed text: %@", [alertView textFieldAtIndex:0].text);
        UIAlertView * secAlertView = [[UIAlertView alloc] initWithTitle:@"Save as Favorite" 
                                                             message:[NSString stringWithFormat:@"Hi %@",[alertView textFieldAtIndex:0].text]
                                                            delegate:nil 
                                                   cancelButtonTitle:@"Cancel" 
                                                   otherButtonTitles:@"OK", nil];
        [secAlertView setAlertViewStyle:UIAlertViewStyleDefault];
        [secAlertView show];
    }
}

#pragma mark - AudioPlayer Delegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    NSLog(@"Hi FinishPlaying");
    NSInteger index = [self getIndexOfPlayerBy:player];// need to rewrite
    if( index == -1){
        NSLog(@"The player is not found in self.players!!");
        return;
    }
    
    NSInteger waitTime = [[[self.currentPlayList objectAtIndex:index] objectForKey:kLoop] integerValue];
    if(waitTime < 0){
        NSIndexPath * path = [[self.myTableView indexPathsForVisibleRows] objectAtIndex:index];
        [self changePlayingIcon:STOPPEDICON atIndexPath:path];
        return;
    }else if(waitTime == 0){
        NSLog(@"WaitTime should not be zero");
        player.numberOfLoops = -1;
        [player play];
        return;
    }
    NSDictionary * userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:player,kPlayerInstance, nil];
    NSTimer * tmpTimer = [NSTimer scheduledTimerWithTimeInterval:waitTime target:self selector:@selector(playPlayer:) userInfo:userInfo repeats:NO];
    [self setTimer:tmpTimer At:index];
    //[self.timersArray replaceObjectAtIndex:index withObject:tmpTimer];
    [userInfo release];
}

#pragma mark - Selectors


- (void) playPlayer:sender{
    // need to protect the player is unvalidate
    // stop need to invalidate change need to invalidate
    // 
    NSDictionary * userInfo = [sender userInfo];
    AVAudioPlayer * player = [userInfo objectForKey:kPlayerInstance];
    [player stop];
    [player prepareToPlay];
    [player play];

}

#pragma mark - players getter and setters

- (void) initPlayers {
    NSUInteger count = [self.currentPlayList count];
    self.players = [[NSMutableArray alloc] initWithCapacity:count];
    for (NSUInteger i = 0 ; i< count; i++){
        [self.players addObject:[[NSMutableDictionary alloc]init]];
    }
}


- (NSInteger) getIndexOfPlayerBy:(AVAudioPlayer *)player{
    for (int i = 0; i< [self.players count]; i++) {
        AVAudioPlayer * target = [self getPlayerAt:i];
        if ([player isEqual:target]) {
            return i;
        }
    }
    return -1;
}

- (NSTimer *) getTimerAt:(NSInteger)index{
    NSMutableDictionary * dict = [self.players objectAtIndex:index];
    NSTimer * timer = [dict objectForKey:kTimerInstance];
    return timer;
}

- (PLAYINGSTATE) getPlayingStateAt:(NSInteger) index{
    NSMutableDictionary * dict = [self.players objectAtIndex:index];
    PLAYINGSTATE isPlaying = [[dict objectForKey:kPlayingState]integerValue];
    return isPlaying;
}

- (AVAudioPlayer *) getPlayerAt:(NSInteger) index{
    NSMutableDictionary * dict = [self.players objectAtIndex:index];
    AVAudioPlayer * player = [dict objectForKey:kPlayerInstance];
    return player;
}

- (NSTimeInterval) getFireTimeIntervalAt:(NSInteger)index{
    NSMutableDictionary * dict = [self.players objectAtIndex:index];
    NSTimeInterval timeInterval = [[dict objectForKey:kTimeInterval] doubleValue];
    return timeInterval;
}

- (void) setTimer:(NSTimer *)timer At:(NSInteger)index{
    NSMutableDictionary * dict = [self.players objectAtIndex:index];
    [dict setObject:timer forKey:kTimerInstance];
}

- (void) setPlayer:(AVAudioPlayer *) player At:(NSInteger)index{
    NSMutableDictionary * dict = [self.players objectAtIndex:index];
    [dict setObject:player forKey:kPlayerInstance];
}

- (void) setPlayingState:(PLAYINGSTATE) playingState At:(NSInteger)index{
    NSMutableDictionary * dict = [self.players objectAtIndex:index];
    [dict setObject:[NSNumber numberWithInteger:playingState] forKey:kPlayingState];
}

- (void) setFireTimeInterval:(NSTimeInterval)interval At:(NSInteger)index{
    NSMutableDictionary * dict = [self.players objectAtIndex:index];
    [dict setObject:[NSNumber numberWithDouble:interval] forKey:kTimeInterval];
}

@end
