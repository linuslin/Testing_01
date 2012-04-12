//
//  LoadViewController.h
//  MyTableVie3
//
//  Created by Linus Lin on 3/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SharedDefinition.h"
#import "SharedObject.h"
#import "DataManager.h"

#define kLoadViewFileNameTag 100
#define kLoadViewDescriptionTag 110
#define kEditButtonTag 120

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

@interface LoadViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>{
    UITableView * infoTableView;
    NSMutableArray * fileInfoArray;
    UITableViewCell * loadViewTableViewCell;
    UIButton * lastButton;
    UITextField * beingEditingTextField;
    CGFloat animatedDistance;
    UIBarButtonItem * reusableCancelButton;
    NSString * originFileNameString;
    NSString * originDescriptionString;
//    NSIndexPath * lastIndexPath;
}

@property (nonatomic, retain) NSMutableArray * fileInfoArray;
@property (nonatomic, retain) IBOutlet UITableView * infoTableView;
@property (nonatomic, retain) IBOutlet UITableViewCell * loadViewTableViewCell;
@property (nonatomic, retain) UIButton * lastButton;
@property (nonatomic, retain) UITextField * beingEditingTextField;
@property (nonatomic, assign) CGFloat animatedDistance;
@property (nonatomic, retain) UIBarButtonItem * reusableCancelButton;
@property (nonatomic, copy) NSString * originFileNameString;
@property (nonatomic, copy) NSString * originDescriptionString;


//@property (nonatomic, retain) NSIndexPath * lastIndexPath;




- (IBAction) clickKeyBoardDoneButton:(id)sender;
- (void) commitChange;



@end
