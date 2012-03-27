//
//  SaveViewController.m
//  MyTableVie3
//
//  Created by Linus Lin on 1/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SaveViewController.h"

@interface SaveViewController (PrivateMethods)
- (void) __initFileInfoArray;
- (void)registerForKeyboardNotifications;
@end

@implementation SaveViewController

@synthesize saveViewTableViewCell;
@synthesize fileNameTextView;
@synthesize descriptionTextView;
@synthesize infoTableView;
@synthesize fileInfoArray;
@synthesize currentSongListDict;
@synthesize activeField;
@synthesize scrollView;
@synthesize testView;


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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"viewDidLoad");
    [self __initFileInfoArray];
    [self registerForKeyboardNotifications];
    // setting done button action to clickDoneButton
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
                                   target:self
                                   action:@selector(clickDoneButton:)];
    
    [doneButton setEnabled:NO];
    [[self navigationItem] setRightBarButtonItem:doneButton];
    [doneButton release];
    
    
    self.scrollView.contentSize = self.testView.frame.size;
}


- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
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


#pragma mark -
#pragma mark tableview delegate

//- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    //NSLog(@"%@", [listData count]);
//    return [self.fileInfoArray count] +1 ; //[listData count];
//    
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return [self.fileInfoArray count];
}
 
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * CellTableIdentifier = @"SavedFilesTableViewCell";
    UITableViewCell * cell;
    cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if(cell == nil){
        [[NSBundle mainBundle] loadNibNamed:@"SaveViewTableViewCell" owner:self options:nil];
        cell = self.saveViewTableViewCell;
        self.saveViewTableViewCell = nil;
        UIView *v = [[[UIView alloc] init] autorelease];
        v.backgroundColor = [UIColor colorWithRed:0.92 green:0.95 blue:1.0 alpha:1.0];
        cell.selectedBackgroundView = v;

    }
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    
    //load filename and description cell
    UITextField * filenameTextFiled = (UITextField *)[cell viewWithTag:kFileNameTag];
    UITextField * descriptTextFiled = (UITextField *)[cell viewWithTag:kDescriptionTag];
    
    //[cell setUserInteractionEnabled:NO];
    
    if(section == 0) {
        filenameTextFiled.placeholder = fileNamePlaceholder;
        descriptTextFiled.placeholder = descriptionPlaceholder;
        filenameTextFiled.borderStyle = UITextBorderStyleRoundedRect;
        descriptTextFiled.borderStyle = UITextBorderStyleRoundedRect;
        [filenameTextFiled setUserInteractionEnabled:YES];
        [descriptTextFiled setEnablesReturnKeyAutomatically:YES];
        return cell;
    }
    NSMutableDictionary * infoDict = [fileInfoArray objectAtIndex:row];
    NSString * desStr = [infoDict objectForKey:kFavoriteDescription];
    NSString * filenameStr = [[infoDict objectForKey:kFavoriteName] stringByDeletingPathExtension];
    filenameTextFiled.text = filenameStr;
    descriptTextFiled.text = desStr;
    filenameTextFiled.borderStyle = UITextBorderStyleNone;
    descriptTextFiled.borderStyle = UITextBorderStyleNone;
    
    return cell;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return sectionTitle1;
    }
    return sectionTitle2;
}
//- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    static NSString * CellTableIdentifier = @"SavedFilesTableViewCell";
//    UITableViewCell * cell;
//    cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
//    if(cell == nil){
//        [[NSBundle mainBundle] loadNibNamed:@"SaveViewTableViewCell" owner:self options:nil];
//        cell = self.saveViewTableViewCell;
//        self.saveViewTableViewCell = nil;
//    }
//    NSUInteger row = [indexPath row];
//
//    //load filename and description cell
//    UITextField * filenameTextFiled = (UITextField *)[cell viewWithTag:kFileNameTag];
//    UITextField * descriptTextFiled = (UITextField *)[cell viewWithTag:kDescriptionTag];
//    
//    if(row == 0) {
//        filenameTextFiled.placeholder = fileNamePlaceholder;
//        descriptTextFiled.placeholder = descriptionPlaceholder;
//        filenameTextFiled.borderStyle = UITextBorderStyleRoundedRect;
//        descriptTextFiled.borderStyle = UITextBorderStyleRoundedRect;
//        return cell;
//    }
//    NSMutableDictionary * infoDict = [fileInfoArray objectAtIndex:row];
//    NSString * desStr = [infoDict objectForKey:kFavoriteName];
//    NSString * filenameStr = [infoDict objectForKey:kFavoriteName];
//    filenameTextFiled.text = filenameStr;
//    descriptTextFiled.text = desStr;
//    filenameTextFiled.borderStyle = UITextBorderStyleNone;
//    descriptTextFiled.borderStyle = UITextBorderStyleNone;
//    
//    [cell setUserInteractionEnabled:NO];
//    return cell;
//}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //return self.saveViewTableViewCell.bounds.size.height;
    return 85.0f;
}



#pragma mark -
#pragma mark tableview dataSource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [[[self navigationItem] rightBarButtonItem] setEnabled:YES];
    //NSInteger row = [indexPath row];
//    NSInteger section = [indexPath section];
    NSLog(@"didSelectedRowAtIndexPath");
//    if(section == 0){
//        UITableViewCell * selectedCell = [tableView cellForRowAtIndexPath:indexPath];
//        [selectedCell setUserInteractionEnabled:YES];
//        UITextField * filenameTextFiled = (UITextField *)[selectedCell viewWithTag:kFileNameTag];
//        UITextField * descriptTextFiled = (UITextField *)[selectedCell viewWithTag:kDescriptionTag];
//        [filenameTextFiled setEnabled:YES];
//        [descriptTextFiled setEnabled:YES];
//        [filenameTextFiled becomeFirstResponder];
//    }
    
}



#pragma mark -
#pragma mark - inputtext field delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.activeField = textField;
    NSIndexPath * selectedPath = [infoTableView indexPathForCell:(UITableViewCell *)[[textField superview]superview]];
    NSLog(@"SelectedPath: %@", selectedPath);
    [self.infoTableView selectRowAtIndexPath:selectedPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    //[self.infoTableView scrollToRowAtIndexPath:selectedPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [[[self navigationItem]rightBarButtonItem] setEnabled:YES];
    [self.activeField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    //[self.activeField becomeFirstResponder];
    [self.activeField resignFirstResponder];
    self.activeField =nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}

- (void) backgroundTap:(id)sender{
    [sender resignFirstResponder];
}

#pragma mark -
#pragma mark instance methods

- (void)clickDoneButton:(id)sender{
    NSLog(@"Done Button Clicked");  
    [self commitChange];
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)commitChange{
    NSIndexPath * selectedPath = [self.infoTableView indexPathForSelectedRow];
    NSUInteger row = [selectedPath row];
    NSUInteger section = [selectedPath section];
    UITableViewCell * selectedCell = [self.infoTableView cellForRowAtIndexPath:selectedPath];
    UITextField * filenameTextFiled = (UITextField *)[selectedCell viewWithTag:kFileNameTag];
    UITextField * descriptTextFiled = (UITextField *)[selectedCell viewWithTag:kDescriptionTag];
    NSString * filename = filenameTextFiled.text;
    if(![[[filename pathExtension] lowercaseString] isEqualToString:@"plist"]){
        filename = [filename stringByAppendingPathExtension:@"plist"];
    }
    NSString * description = descriptTextFiled.text;
    NSMutableDictionary * resultDict = [[NSMutableDictionary alloc] initWithDictionary:self.currentSongListDict];
    [resultDict setValue:description forKey:kFavoriteDescription];
    [[DataManager defaultManger] writeToFavorite:filename :resultDict];
    if (section > 0) {
        //replace file
        NSMutableDictionary * selectedFileInfoDict = [self.fileInfoArray objectAtIndex:row];
        NSString * fileNeed2Remove = [selectedFileInfoDict objectForKey:kFavoriteName];
        if(![fileNeed2Remove isEqualToString:filename])
            [[DataManager defaultManger] removeFileFromFavorite:fileNeed2Remove];
    }
    [resultDict release];
}



#pragma mark -
#pragma mark private methods

- (void) reloadData
{
    
}

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void) __initFileInfoArray{
    NSError * error;
    DataManager * dataManager = [DataManager defaultManger];
    
    NSString * favDir = dataManager.favoriteDirectory;
    NSLog(@"FileInfoError favDir: %@", favDir);
    NSURL * fileURL = [[NSURL alloc] initFileURLWithPath: favDir isDirectory:YES];
    //NSArray * filenameArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:favDir error:&error];
    NSArray * pathArray = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:fileURL includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles error:&error];
    
    NSMutableArray * fileInfoDictArray = [[NSMutableArray alloc]initWithCapacity:[pathArray count]];
    NSMutableDictionary * fileInfoDict;
    NSMutableDictionary * fileDict;
    NSLog(@"FileInfoArray: %@", pathArray);
    NSLog(@"FileInfoError: %@", error);
    
    for (NSString * filename in pathArray) {
        fileDict = [dataManager readFromFavorite:[filename lastPathComponent]]; // need release ??
        NSString * description = [fileDict objectForKey:kFavoriteDescription];
        fileInfoDict = [[NSMutableDictionary alloc] initWithObjectsAndKeys: [filename lastPathComponent], kFavoriteName, description, kFavoriteDescription, nil];
        [fileInfoDictArray addObject:fileInfoDict];
        [fileInfoDict release];
    }
    
    self.fileInfoArray = fileInfoDictArray;
    NSLog(@"fileInfoArray: %@",fileInfoDictArray);
    [fileInfoDictArray release];
}


#pragma mark -
#pragma mark @selector for keyboard event notification


// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
   
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    UIView * cellView = [[activeField superview] superview];
    CGPoint dectectPoint = CGPointMake(cellView.frame.origin.x , self.infoTableView.frame.origin.y + cellView.frame.origin.y + cellView.frame.size.height);
//    NSLog(@"infoTable origin: %f,%f",self.infoTableView.frame.origin.x,self.infoTableView.frame.origin.y);
//    NSLog(@"activeField.frame: %f,%f",self.activeField.frame.origin.x,self.activeField.frame.origin.y);
//    NSLog(@"dectecPoint.frame: %f,%f",dectectPoint.x,dectectPoint.y);
//    NSLog(@"cellView.frame: %f,%f",cellView.frame.origin.x,cellView.frame.origin.y);
//    CGFloat toolbarHeight = [[self navigationController] toolbar].frame.size.height;
    CGRect aRect = self.view.frame;
//    NSLog(@"aRect.frame: %f,%f,%f",aRect.origin.x,aRect.origin.y,aRect.size.height);
    aRect.size.height -= (kbSize.height);
//    NSLog(@"aRect.frame: %f,%f,%f",aRect.origin.x,aRect.origin.y,aRect.size.height);
    
    if (!CGRectContainsPoint(aRect, dectectPoint) ) {
        NSLog(@"Hi Coming");
        CGFloat yPosition = dectectPoint.y;
        CGPoint scrollPoint = CGPointMake(0.0, yPosition - kbSize.height);//- kbSize.height
        [scrollView setContentOffset:scrollPoint animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{

    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    //UIView * tbCell = [[activeField superview]superview];
    //CGPoint scrollPoint = self.testView.bounds.origin;
    [scrollView scrollRectToVisible:self.scrollView.frame animated:YES];
}




#pragma mark -
#pragma mark ScrollView Delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.testView;
}

@end
