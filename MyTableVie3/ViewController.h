//
//  ViewController.h
//  MyTableVie3
//
//  Created by Linus Lin on 1/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SaveViewController.h"
#import "SelectSoundContorller.h"
#import <AVFoundation/AVFoundation.h>
#import "SharedObject.h"
#import "SharedDefinition.h"
#import <Foundation/Foundation.h>
#import "LoopViewController.h"

#define kTableViewCellImageTag 100
#define kTableViewCellSelectButtonTag 110
#define kTableViewCellPlayButtonTag 120
#define kTableViewCellLoopButtonTag 130
#define kTableViewCellSliderTag 140


#define kPlayerInstance @"playerInstance"
#define kTimerInstance @"timerInstance"
#define kIsPlaying @"isPlaying"


//#define kImageMappingFileName @"__icons"


@interface ViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,AVAudioPlayerDelegate,UIScrollViewDelegate,UIAlertViewDelegate>
{
    UITableViewCell * tvCell;
    UITableViewCell * btnCell;
    UITableView * myTableView;
    
    NSMutableDictionary * currentPlayListDict;
    NSMutableArray * currentPlayList;
    
    NSMutableArray * soundPlayers;
    NSMutableArray * playingIndex;
    NSDictionary * imageMapping;
    //NSMutableArray * loopArray;
    NSMutableArray * timersArray;
    NSMutableArray * players;
    
    
    SharedObject * sharedObject;
    SaveViewController * saveVC;
    SelectSoundContorller * selectVC;
    LoopViewController * loopVC;
    
    
    
    UIScrollView * scrollView;
	UIPageControl * pageControl;
    NSMutableArray * viewControllers;
    
    UIView * toolBarView0;
    UIView * toolBarView1;
    
    // To be used when scrolls originate from the UIPageControl
    BOOL pageControlUsed;
   
    
}

@property (nonatomic, assign) IBOutlet UITableViewCell * tvCell;
@property (nonatomic, assign) IBOutlet UITableViewCell * btnCell;
@property (nonatomic, retain) NSMutableArray * currentPlayList;
@property (nonatomic, retain) IBOutlet UITableView * myTableView;
@property (nonatomic, retain) SaveViewController * saveVC;
@property (nonatomic, retain) SelectSoundContorller * selectVC;
@property (nonatomic, retain) LoopViewController * loopVC;
@property (nonatomic, retain) NSMutableDictionary * currentPlayListDict;
@property (nonatomic, retain) NSMutableArray * soundPlayers;
@property (nonatomic, retain) NSMutableArray * playingIndex;
@property (atomic, retain) SharedObject * sharedObject;
@property (atomic, retain) NSDictionary * imageMapping;
@property (nonatomic, retain) NSMutableArray * timersArray;
@property (nonatomic, retain) NSMutableArray * players;

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property (nonatomic, retain) NSMutableArray *viewControllers;
@property (nonatomic, retain) IBOutlet UIView * toolBarView0;
@property (nonatomic, retain) IBOutlet UIView * toolBarView1;


- (IBAction)clickSave:(id)sender;
- (IBAction)clickSelect:(id)sender;
- (IBAction)clickPlayButton:(id)sender;
- (IBAction)clickLoopButton:(id)sender;
- (IBAction)changeSliderValue:(id)sender;
- (IBAction)clickTrackMangeButton:(id)sender;
- (IBAction)clickImage:(id) sender;
//- (void) clickBackButton: (id)sender;




- (void) _initCurrentPlayListAndDict;
- (NSInteger) _getRowOfCell:(id)sender;
- (void) _reloadTableView;
- (void) _initImageMapping;
- (void) updateSonglist:(id)sender;
- (void) updateLoopTime:(id)sender;


// players method
- (void) _initSoundPlayers;
- (void) pauseAllPlayers;
- (void) replayPausedPlayers;
- (void) playAllPlayers;
- (void) stopAllPlayers;
- (void) releaseAllPlayers;


// playing Index methods
- (void) savePlayingIndex;

// scroll view controller

- (IBAction)changePage:(id)sender;

- (NSTimer *) getTimerAt:(NSInteger)index;
- (BOOL) getIsPlayingAt:(NSInteger) index;
- (AVAudioPlayer *) getPlayerAt:(NSInteger) index;
- (void) setTimerAt:(NSInteger)index:(NSTimer *) timer;
- (void) setPlayerAt:(NSInteger)index:(AVAudioPlayer *) player;
- (void) setIsPlayingAt:(NSInteger)index:(BOOL) playingIndex;
- (NSInteger) getIndexOfPlayerBy:(AVAudioPlayer *)player;

- (NSIndexPath *) getIndexPathFromTableViewBy:(NSInteger)row;
@end
