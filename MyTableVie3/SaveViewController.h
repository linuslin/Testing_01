//
//  SaveViewController.h
//  MyTableVie3
//
//  Created by Linus Lin on 1/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SharedDefinition.h"
#import "SharedObject.h"
#import "DataManager.h"


#define kFileNameTag 101
#define kDescriptionTag 102
#define fileNamePlaceholder @"Add New Name Here"
#define descriptionPlaceholder @"Description Here"
#define sectionTitle1 @"Create New Favorite"
#define sectionTitle2 @"Replace Old Favorite"


@interface SaveViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIScrollViewDelegate>
{
    UITextField * fileNameTextView;
    UITextField * descriptionTextView;
    UITableView * infoTableView;
    UITableViewCell * saveViewTableViewCell;
    NSMutableArray * fileInfoArray;
    NSMutableDictionary * currentSongListDict;
    UITextField * activeField;
    UIScrollView * scrollView;
    UIView * testView;
    //NSMutableArray * 
}

@property (nonatomic, retain) IBOutlet UITableViewCell * saveViewTableViewCell;
@property (nonatomic, retain) IBOutlet UITextField * fileNameTextView;
@property (nonatomic, retain) IBOutlet UITextField * descriptionTextView;
@property (nonatomic, retain) IBOutlet UITableView * infoTableView;
@property (nonatomic, retain) IBOutlet UIScrollView * scrollView;
@property (nonatomic, retain) IBOutlet  UIView * testView;
@property (nonatomic, retain) NSMutableArray * fileInfoArray;
@property (nonatomic, retain) NSMutableDictionary * currentSongListDict;
@property (nonatomic, retain) UITextField * activeField;



 
- (void) clickDoneButton:(id)sender;
- (void) commitChange;
- (void) reloadData;
- (IBAction) backgroundTap:(id) sender;
@end
