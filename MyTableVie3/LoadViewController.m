//
//  LoadViewController.m
//  MyTableVie3
//
//  Created by Linus Lin on 3/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoadViewController.h"

@interface LoadViewController(PrivateMethod)
- (void) __initFileInfoArray;

@end

@implementation LoadViewController
//@synthesize lastIndexPath;
@synthesize lastButton;
@synthesize fileInfoArray;
@synthesize infoTableView;
@synthesize loadViewTableViewCell;
@synthesize beingEditingTextField;
@synthesize animatedDistance;
@synthesize reusableCancelButton;
@synthesize originFileNameString;
@synthesize originDescriptionString;




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
    if (self.fileInfoArray == nil)
    {
        [self __initFileInfoArray];
    }
    
    //UIBarButtonItem * editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(toggleEdit:)];
    //editButton.enabled = YES;
    //self.navigationItem.rightBarButtonItem = editButton;
    
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(clickDoneButton:)];
    [doneButton setEnabled:NO];
    //NSArray * tmpArr = [[NSArray alloc] initWithObjects:editButton,doneButton, nil];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    UIBarButtonItem * cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonSystemItemCancel target:self action:@selector(clickCancelButton:)];
    //NSArray * tmpArr = [[NSArray alloc] initWithObjects:editButton,doneButton, nil];
    //self.navigationItem.rightBarButtonItem = doneButton;
    self.reusableCancelButton = cancelButton;
    
    
    [cancelButton release];
    [doneButton release];
//    [tmpArr release];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
    //if(fileInfoArray){
    //[self reloadData];
    //}
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



- (IBAction)toggleEdit:(id)sender
{
    NSLog(@"toggleEdit");
    [sender setHidden:YES];
    NSIndexPath * path = [self.infoTableView indexPathForSelectedRow];
    UITableViewCell * cell = [infoTableView cellForRowAtIndexPath:path];
    
    UITextField * filenameTextFiled = (UITextField *)[cell viewWithTag:kLoadViewFileNameTag];
    UITextField * descriptTextFiled = (UITextField *)[cell viewWithTag:kLoadViewDescriptionTag];
    
    [filenameTextFiled setUserInteractionEnabled:YES];
    [descriptTextFiled setUserInteractionEnabled:YES];
    
    [filenameTextFiled becomeFirstResponder];
    
    //backup origin text;
    self.originDescriptionString = descriptTextFiled.text;
    self.originFileNameString = filenameTextFiled.text;
    
}

- (IBAction) clickKeyBoardDoneButton:(id)sender{
//    [sender endEditing];
    [sender resignFirstResponder];
    NSIndexPath * path = [self.infoTableView indexPathForSelectedRow];
    UITableViewCell * cell = [infoTableView cellForRowAtIndexPath:path];
    
    UITextField * filenameTextFiled = (UITextField *)[cell viewWithTag:kLoadViewFileNameTag];
    UITextField * descriptTextFiled = (UITextField *)[cell viewWithTag:kLoadViewDescriptionTag];
    
    [filenameTextFiled setUserInteractionEnabled:NO];
    [descriptTextFiled setUserInteractionEnabled:NO];
    [self.lastButton setHidden:NO];
    [self.lastButton setHighlighted:YES];
    
    NSInteger selectedRow = [path row];
    NSDictionary * selectedDict = [fileInfoArray objectAtIndex:selectedRow];
    [selectedDict setValue:filenameTextFiled.text forKey:kFavoriteName];
    [selectedDict setValue:descriptTextFiled.text forKey:kFavoriteDescription];
    NSString * realFilename = [selectedDict objectForKey:kRealFileName];
    [[DataManager defaultManger] writeToFavorite:realFilename :selectedDict];
    
    //[filenameTextFiled becomeFirstResponder];
}


#pragma mark -
#pragma mark Table Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [fileInfoArray count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *LoadViewControllerIdentifier   = @"LoadViewControllerIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LoadViewControllerIdentifier];
    if(cell == nil){
        NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"LoadViewTableViewCell" owner:self options:nil];
        if( [nib count] > 0){
            cell = self.loadViewTableViewCell;
            UIView *v = [[[UIView alloc] init] autorelease];
            v.backgroundColor = [UIColor colorWithRed:0.92 green:0.95 blue:1.0 alpha:1.0];
            cell.selectedBackgroundView = v;
        }else {
            NSLog(@"failed to load saveView cell!");
        }
        
    }
    //load filename and description cell
    UITextField * filenameTextFiled = (UITextField *)[cell viewWithTag:kLoadViewFileNameTag];
    UITextField * descriptTextFiled = (UITextField *)[cell viewWithTag:kLoadViewDescriptionTag];
    
    
    NSUInteger row = [indexPath row];
    NSDictionary * infoDict = [fileInfoArray objectAtIndex:row];
    NSString * desStr = [infoDict objectForKey:kFavoriteDescription];
    NSString * filenameStr = [[infoDict objectForKey:kFavoriteName] stringByDeletingPathExtension];

    filenameTextFiled.text = filenameStr;
    descriptTextFiled.text = desStr;

    return cell;
}

#pragma mark -
#pragma mark Table Delegate Methods

- (NSIndexPath *) tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (self.beingEditingTextField) {
//        return nil;
//    }
    
    if([[tableView indexPathForSelectedRow] isEqual: indexPath]){
        return nil;
    }
    return indexPath;
}

- (NSIndexPath *) tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSIndexPath * path = [self.infoTableView indexPathForSelectedRow];
    UITableViewCell * cell = [infoTableView cellForRowAtIndexPath:indexPath];
    
    UITextField * filenameTextFiled = (UITextField *)[cell viewWithTag:kLoadViewFileNameTag];
    UITextField * descriptTextFiled = (UITextField *)[cell viewWithTag:kLoadViewDescriptionTag];
    
    [filenameTextFiled setUserInteractionEnabled:NO];
    [descriptTextFiled setUserInteractionEnabled:NO];
    //[tableView becomeFirstResponder];
    return  indexPath;
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    if(editingStyle == UITableViewCellEditingStyleDelete){
        
        // delete the real file
        NSMutableDictionary * selectedFileInfoDict = [self.fileInfoArray objectAtIndex:row];
        NSString * fileNeed2Remove = [selectedFileInfoDict objectForKey:kRealFileName];
        [[DataManager defaultManger] removeFileFromFavorite:fileNeed2Remove];
        
        [self.fileInfoArray removeObjectAtIndex:row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * didselectedCell = [tableView cellForRowAtIndexPath:indexPath];
    UIButton * editButton = (UIButton *) [didselectedCell viewWithTag:kEditButtonTag];
    //[editButton setEnabled:YES];
    [editButton setHidden:NO];
    lastButton = editButton;
//    [tableView becomeFirstResponder];
//    self.lastIndexPath = indexPath;

}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.beingEditingTextField){
        return NO;
    }
    return YES;
}

- (void) tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"hello");
    [lastButton setHidden:YES];
}

- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * deselectedCell = [tableView cellForRowAtIndexPath:indexPath];
    UIButton * editButton = (UIButton *) [deselectedCell viewWithTag:kEditButtonTag];
    //[editButton setEnabled:NO];
    [editButton setHidden:YES];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"Size: %f",self.loadViewTableViewCell.bounds.size.height);
    //return self.loadViewTableViewCell.bounds.size.height;
    return 85.0f;
}

#pragma mark - UITextFieldDelegate

- (void) textFieldDidBeginEditing:(UITextField *)textField{
    //UITableViewCell * cell = [textField.superview.superview]
    self.beingEditingTextField = textField;
    self.navigationItem.leftBarButtonItem = self.reusableCancelButton;
    //disable tableview editing
    //disable done and back button
//    UITableViewCell * selectedCell = [self.infoTableView cellForRowAtIndexPath: [self.infoTableView indexPathForSelectedRow]];
//    [self.infoTableView scrollToRowAtIndexPath:[self.infoTableView indexPathForSelectedRow] atScrollPosition:UITableViewScrollPositionTop animated:YES];
//    [self.infoTableView scrollRectToVisible: selectedCell  animated:YES];
    [[self.navigationItem rightBarButtonItem] setEnabled:NO];
    
    
    CGRect textFieldRect =
    [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect =
    [self.view.window convertRect:self.view.bounds fromView:self.view];
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator =
    midline - viewRect.origin.y
    - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator =
    (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)
    * viewRect.size.height;
    
    CGFloat heightFraction = numerator / denominator;
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];

}

- (void) textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    self.beingEditingTextField = nil;
    //enable done and back button
    [[self.navigationItem rightBarButtonItem] setEnabled:YES];
    self.navigationItem.leftBarButtonItem = nil;

    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];

}

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    return YES;
}

#pragma mark - Private Methods


- (void) __initFileInfoArray{
    DataManager * manger = [DataManager defaultManger];
    self.fileInfoArray = [manger getFileInfoArray];
}

- (void) clickDoneButton:(id)sender{
    NSLog(@"Click done Button");
    [self.navigationController popViewControllerAnimated:YES];
}
- (void) commitChange{
    //save the change on textFiled
    
}

- (void) clickCancelButton:(id) sender {
    //self.navigationItem.leftBarButtonItem = nil;
    [beingEditingTextField endEditing:YES];
    NSIndexPath * path = [self.infoTableView indexPathForSelectedRow];
    UITableViewCell * cell = [infoTableView cellForRowAtIndexPath:path];
    
    UITextField * filenameTextFiled = (UITextField *)[cell viewWithTag:kLoadViewFileNameTag];
    UITextField * descriptTextFiled = (UITextField *)[cell viewWithTag:kLoadViewDescriptionTag];

    filenameTextFiled.text = self.originFileNameString;
    descriptTextFiled.text = self.originDescriptionString;
    
    [filenameTextFiled setEnabled:NO];
    [descriptTextFiled setEnabled:NO];
    
    [self navigationItem].rightBarButtonItem.enabled = NO;
//    [self.view becomeFirstResponder];
}

@end
