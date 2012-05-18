//
//  SelectSoundContorller.h
//  MyTableVie3
//
//  Created by Linus Lin on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "SharedObject.h"
#import "SharedDefinition.h"

#define kSelectTableViewCellImageTag 101
#define kSelectTableViewCellLabelTag 102
static NSString * originalSectionName = @"Original Ambients";
static NSString * DownloadedSectionName = @"Downloaded Ambients";

@interface SelectSoundContorller : UIViewController <UITableViewDataSource, UITableViewDelegate, AVAudioPlayerDelegate>
{
    UITableView * selectTableView;
    UITableViewCell * selectSoundTableViewCell;
    NSMutableArray * songList;
    NSMutableArray * downloadSongList;
    NSString * currentSong;
    AVAudioPlayer * myPlayer;
    NSInteger selectedRow;
    SharedObject * sharedObject;
    NSDictionary * imageMapping;
}


@property (nonatomic, retain) IBOutlet UITableView * selectTableView;
@property (nonatomic, retain) IBOutlet UITableViewCell * selectSoundTableViewCell;
@property (nonatomic, retain) NSMutableArray * songList;
@property (nonatomic, retain) NSMutableArray * downloadSongList;
@property (nonatomic, copy) NSString * currentSong;
@property (nonatomic, retain) AVAudioPlayer * myPlayer;
@property (nonatomic, assign) NSInteger selectedRow;
@property (atomic, retain) SharedObject * sharedObject;
@property (atomic, retain) NSDictionary * imageMapping;


- (IBAction)clickSelect:(id)sender;
- (void) playSound:(NSString *) seletedSong;
- (void) clickDoneButton:(id)sender;
- (void) clickBackButton:(id)sender;
- (void) notifyChange:(id)sender;
@end
